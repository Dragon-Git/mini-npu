# Equivalence target: rtl_ref/ethosu55_reg_fifo.sv
#
#   module #(FIFO_WIDTH=32, FIFO_DEPTH=16, EN_COLLISION=0, EN_DATA_X=0) (
#     clk, reset_n, flush_i, in_valid_i, in_data_i, in_ready_o,
#     out_valid_o, out_data_o, out_ready_i, data_cnt_o[$clog2(D):0]);
#
# Register-based FIFO: wr/rd pointers + data counter + per-slot write
# enables. Key equations (EN_COLLISION=0 default):
#   fifo_write = in_valid & ~full ; in_ready = ~full
#   fifo_read  = out_ready & ~empty ; out_valid = ~empty
#   max_wr_ptr = wr_ptr == DEPTH-1  (via max_data_cnt trick)
#   nxt_wr_ptr = flush ? 0 : (write && max) ? 0 : write ? wr+1 : wr
#   memory[i] write-en = write && (wr_ptr == i); async reset all.
#   out_data = memory[rd_ptr]; empty/full from data_cnt.
# data_cnt_o width in RTL: [$clog2(FIFO_DEPTH):0] (LOG2+1 bits).

from pycde import Clock, Module, System
from pycde.constructs import Mux, NamedWire
from pycde.types import Bits

from .common import async_reg, clog2, zero


def _mux_index(slots, ptr, ptr_w):
    acc = slots[0]
    for i in range(len(slots) - 1, 0, -1):
        acc = Mux((ptr == Bits(ptr_w)(i)).as_bits(1), slots[i], acc)
    return acc


def make_reg_fifo(FIFO_WIDTH: int = 32, FIFO_DEPTH: int = 16,
                  EN_COLLISION: int = 0):

    LOG2_DEPTH = clog2(FIFO_DEPTH)
    assert (FIFO_DEPTH & (FIFO_DEPTH - 1)) == 0, \
        "RTL nxt_data_cnt arithmetic assumes power-of-two depth"

    class RegFifo(Module):
        FIFO_WIDTH = FIFO_WIDTH
        FIFO_DEPTH = FIFO_DEPTH
        LOG2_DEPTH = LOG2_DEPTH
        EN_COLLISION = EN_COLLISION

        clk = Clock()
        reset_n = Clock()
        flush_i = Input(Bits(1))
        in_valid_i = Input(Bits(1))
        in_data_i = Input(Bits(FIFO_WIDTH))
        out_ready_i = Input(Bits(1))
        in_ready_o = Output(Bits(1))
        out_valid_o = Output(Bits(1))
        out_data_o = Output(Bits(FIFO_WIDTH))
        data_cnt_o = Output(Bits(LOG2_DEPTH + 1))

        @generator
        def construct(ports):
            clk, rst_n = ports.clk, ports.reset_n
            flush = ports.flush_i.as_bits(1)
            iv = ports.in_valid_i.as_bits(1)
            rdy = ports.out_ready_i.as_bits(1)
            din = ports.in_data_i

            w_wr = NamedWire(Bits(LOG2_DEPTH), "wr_ptr")
            w_rd = NamedWire(Bits(LOG2_DEPTH), "rd_ptr")
            w_cnt = NamedWire(Bits(LOG2_DEPTH + 1), "data_cnt")

            q_wr = async_reg(w_wr, clk, rst_n, name="wr_ptr")
            q_rd = async_reg(w_rd, clk, rst_n, name="rd_ptr")
            q_cnt = async_reg(w_cnt, clk, rst_n, name="data_cnt")

            full = (w_cnt == Bits(LOG2_DEPTH + 1)(FIFO_DEPTH)).as_bits(1)
            empty = (w_cnt == Bits(LOG2_DEPTH + 1)(0)).as_bits(1)

            if EN_COLLISION:
                fifo_write = (iv & (~full | rdy)).as_bits(1)
                in_ready = (~full | rdy).as_bits(1)
            else:
                fifo_write = (iv & ~full).as_bits(1)
                in_ready = ~full
            fifo_read = (rdy & ~empty).as_bits(1)
            out_valid = ~empty

            max_p = Bits(LOG2_DEPTH)(FIFO_DEPTH - 1)
            one_p = Bits(LOG2_DEPTH)(1)
            one_c = Bits(LOG2_DEPTH + 1)(1)

            def ptr_next(q, go):
                return Mux(flush, zero(LOG2_DEPTH),
                           Mux(go, Mux((q == max_p).as_bits(1),
                                       zero(LOG2_DEPTH),
                                       (q + one_p).as_uint(LOG2_DEPTH)),
                               q))

            w_wr.assign(ptr_next(q_wr, fifo_write))
            w_rd.assign(ptr_next(q_rd, fifo_read))

            dec = ((fifo_read & ~fifo_write) & ~empty).as_bits(1)
            inc = ((fifo_write & ~fifo_read) & ~full).as_bits(1)
            cnt_next = Mux(flush, zero(LOG2_DEPTH + 1),
                           Mux(dec, (q_cnt - one_c).as_uint(LOG2_DEPTH + 1),
                               Mux(inc, (q_cnt + one_c).as_uint(LOG2_DEPTH + 1),
                                   q_cnt)))
            w_cnt.assign(cnt_next)

            # memory slots (one flop per entry, per-slot write enable)
            slots = []
            for i in range(FIFO_DEPTH):
                w_slot = NamedWire(Bits(FIFO_WIDTH), f"memory_{i}")
                q = async_reg(w_slot, clk, rst_n, name=f"memory{i}")
                en = (fifo_write & (q_wr == Bits(LOG2_DEPTH)(i))).as_bits(1)
                w_slot.assign(Mux(en, din, q))
                slots.append(q)

            ports.in_ready_o = in_ready
            ports.out_valid_o = out_valid
            ports.out_data_o = _mux_index(slots, q_rd, LOG2_DEPTH)
            ports.data_cnt_o = q_cnt

    return RegFifo


def make_reg_fifo_system(FIFO_WIDTH: int = 32, FIFO_DEPTH: int = 16,
                         output_directory: str = None):
    top = make_reg_fifo(FIFO_WIDTH, FIFO_DEPTH)
    return System([top], name="reg_fifo",
                  output_directory=output_directory or "build/reg_fifo")
