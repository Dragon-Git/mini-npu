# Equivalence target: rtl_ref/ethosu55_back_buf.sv
#
#   module #(DEPTH = 3, WIDTH = 64) (
#     clk, reset_n, in_valid_i, in_data_i[WIDTH-1:0],
#     out_valid_o, out_data_o[WIDTH-1:0], out_ready_i);
#
# Bypass buffer (skid FIFO of DEPTH registers + bypass path):
#   i_fifo_empty = (in_ptr == out_ptr) ? !maybe_full : 0
#   i_fifo_get   = out_ready_i && !empty
#   i_fifo_put   = (in_valid && !out_ready) || (in_valid && !empty)
#   out_data_o   = empty ? in_data_i : s_regs[out_ptr]
#   out_valid_o  = !empty || in_valid
#   slot enable  = (in_ptr == i) && put ; ptrs wrap at DEPTH-1
# All registers use async active-low reset.  Data slots are individual
# named registers (RTL uses `logic [W-1:0] s_regs [DEPTH-1:0]`; `prep`
# lowers that to one flop per slot, so the netlists correspond).

from pycde import Clock, Module, System
from pycde.constructs import Mux, NamedWire
from pycde.types import Bits

from .common import async_reg, clog2, zero


def _mux_index(slots, ptr, ptr_w):
    """Unrolled one-hot select of slots[ptr] (matches reading
    s_regs[s_out_ptr] after memory lowering)."""
    acc = slots[0]
    for i in range(len(slots) - 1, 0, -1):
        acc = Mux((ptr == Bits(ptr_w)(i)).as_bits(1), slots[i], acc)
    return acc


def make_back_buf(DEPTH: int = 3, WIDTH: int = 64):

    PTR_W = clog2(DEPTH)

    class BackBuf(Module):
        DEPTH = DEPTH
        WIDTH = WIDTH
        PTR_W = PTR_W

        clk = Clock()
        reset_n = Clock()
        in_valid_i = Input(Bits(1))
        in_data_i = Input(Bits(WIDTH))
        out_ready_i = Input(Bits(1))
        out_valid_o = Output(Bits(1))
        out_data_o = Output(Bits(WIDTH))

        @generator
        def construct(ports):
            clk, rst_n = ports.clk, ports.reset_n
            iv = ports.in_valid_i.as_bits(1)
            rdy = ports.out_ready_i.as_bits(1)
            din = ports.in_data_i

            w_in_ptr = NamedWire(Bits(PTR_W), "s_in_ptr")
            w_out_ptr = NamedWire(Bits(PTR_W), "s_out_ptr")
            w_maybe_full = NamedWire(Bits(1), "s_maybe_full")

            # state registers (async active-low reset)
            q_in_ptr = async_reg(w_in_ptr, clk, rst_n, name="s_in_ptr")
            q_out_ptr = async_reg(w_out_ptr, clk, rst_n, name="s_out_ptr")
            q_maybe_full = async_reg(w_maybe_full, clk, rst_n,
                                     name="s_maybe_full")

            # control
            ptr_eq = (w_in_ptr == w_out_ptr).as_bits(1)
            empty = (ptr_eq & ~q_maybe_full.as_bits(1)).as_bits(1)

            f_get = (rdy & ~empty).as_bits(1)
            f_put = ((iv & ~rdy) | (iv & ~empty)).as_bits(1)

            # data slots: q = en ? din : q, async active-low reset
            slots = []
            for i in range(DEPTH):
                w_slot = NamedWire(Bits(WIDTH), f"s_regs_{i}")
                q = async_reg(w_slot, clk, rst_n, name=f"s_regs{i}")
                en = ((w_in_ptr == Bits(PTR_W)(i)).as_bits(1) & f_put).as_bits(1)
                w_slot.assign(Mux(en, din, q))
                slots.append(q)

            # pointer next-state with wrap at DEPTH-1
            def wrap_inc(p):
                return Mux((p == Bits(PTR_W)(DEPTH - 1)).as_bits(1),
                           zero(PTR_W),
                           (p + Bits(PTR_W)(1)).as_uint(PTR_W))

            w_in_ptr.assign(Mux(f_put, wrap_inc(q_in_ptr), q_in_ptr))
            w_out_ptr.assign(Mux(f_get, wrap_inc(q_out_ptr), q_out_ptr))

            nxt_mf = Mux(f_put,
                         Mux(f_get, q_maybe_full, Bits(1)(1)),
                         Mux(f_get, Bits(1)(0), q_maybe_full))
            w_maybe_full.assign(nxt_mf)

            # outputs
            sel = _mux_index(slots, q_out_ptr, PTR_W)
            ports.out_data_o = Mux(empty, din, sel)
            ports.out_valid_o = (~empty | iv).as_bits(1)

    return BackBuf


def make_back_buf_system(DEPTH: int = 3, WIDTH: int = 64,
                         output_directory: str = None):
    top = make_back_buf(DEPTH, WIDTH)
    return System([top], name="back_buf",
                  output_directory=output_directory or "build/back_buf")
