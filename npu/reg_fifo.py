# Equivalence target: rtl_ref/ethosu55_reg_fifo.sv
#
#   module #(FIFO_WIDTH=32, FIFO_DEPTH=16, EN_COLLISION=0, EN_DATA_X=0) (
#     input  clk, reset_n, flush_i, in_valid_i, [W-1:0] in_data_i,
#     output in_ready_o, out_valid_o, [W-1:0] out_data_o,
#     input  out_ready_i, output [$clog2(D):0] data_cnt_o);
#
# Exact ARM equations (EN_COLLISION = 0):
#   fifo_write  = in_valid & ~full
#   in_ready_o  = ~full
#   fifo_read   = out_ready & ~empty
#   out_valid_o = ~empty
#   fifo_empty  = (data_cnt == 0)     (data_cnt is LOG2+1 bits)
#   fifo_full   = (data_cnt == DEPTH)
#   wr_ptr nxt  = flush ? 0 : write&&max ? 0 : write ? wr+1 : wr   (en=flush|write)
#   rd_ptr nxt  = flush ? 0 : read &&max ? 0 : read ? rd+1 : rd   (en=flush|read)
#   data_cnt nxt= flush ? 0 : read&&!write&&cnt!=0 ? cnt-1 :
#                 write&&!read&&cnt!=D ? cnt+1 : cnt            (en=flush|read|write)
#   memory[i]   = en[i] = write && (wr_ptr == i); q = en ? in_data : q
#   out_data_o  = memory[rd_ptr]  (decoded mux over slots)
#
# The slot memory becomes DEPTH DFFs with decoded enables; out_data_o is a
# decoded one-hot mux (ethosu55_onehot_mux shape) -- no SV memory cells.

from pycde import Clock, Input, Module, Output, System, generator
from pycde.constructs import Wire
from pycde.types import Bits

from .common import async_reg, clog2, if_, u


def make_reg_fifo(FIFO_WIDTH: int = 32, FIFO_DEPTH: int = 16):

    LOG2D = clog2(FIFO_DEPTH)
    CNT_W = LOG2D + 1
    MAXP = FIFO_DEPTH - 1

    class RegFifo(Module):

        clk = Clock()
        reset_n = Clock()
        flush_i = Input(Bits(1))
        in_valid_i = Input(Bits(1))
        in_data_i = Input(Bits(FIFO_WIDTH))
        out_ready_i = Input(Bits(1))
        in_ready_o = Output(Bits(1))
        out_valid_o = Output(Bits(1))
        out_data_o = Output(Bits(FIFO_WIDTH))
        data_cnt_o = Output(Bits(CNT_W))

        @generator
        def construct(ports):
            # state wires
            wr_ptr = Wire(Bits(LOG2D), "wr_ptr")
            rd_ptr = Wire(Bits(LOG2D), "rd_ptr")
            data_cnt = Wire(Bits(CNT_W), "data_cnt")
            memory = [Wire(Bits(FIFO_WIDTH), f"mem_{i}")
                      for i in range(FIFO_DEPTH)]

            flush = ports.flush_i
            in_valid = ports.in_valid_i
            out_ready = ports.out_ready_i

            fifo_empty = (data_cnt == u(CNT_W, 0)).as_bits(1)
            fifo_full = (data_cnt == u(CNT_W, FIFO_DEPTH)).as_bits(1)

            fifo_write = in_valid & ~fifo_full
            fifo_read = out_ready & ~fifo_empty

            ports.in_ready_o = (~fifo_full).as_bits(1)
            ports.out_valid_o = (~fifo_empty).as_bits(1)
            ports.data_cnt_o = data_cnt.as_bits(CNT_W)

            # memory slots
            for i in range(FIFO_DEPTH):
                en = fifo_write & (wr_ptr == u(LOG2D, i)).as_bits(1)
                nxt = if_(en, ports.in_data_i, memory[i].as_bits(FIFO_WIDTH))
                r = async_reg(nxt, ports.clk, ports.reset_n, name=f"mem{i}")
                memory[i].assign(r.as_bits(FIFO_WIDTH))

            # out_data_o: decoded mux over memory[rd_ptr]
            out_sel = None
            for i in range(FIFO_DEPTH - 1, -1, -1):
                if out_sel is None:
                    out_sel = memory[i].as_bits(FIFO_WIDTH)
                else:
                    sel = (rd_ptr == u(LOG2D, i)).as_bits(1)
                    out_sel = if_(sel, memory[i].as_bits(FIFO_WIDTH), out_sel)
            ports.out_data_o = out_sel

            # pointers
            wr_max = (wr_ptr == u(LOG2D, MAXP)).as_bits(1)
            rd_max = (rd_ptr == u(LOG2D, MAXP)).as_bits(1)
            nxt_wr = if_(flush, u(LOG2D, 0),
                         if_(fifo_write & wr_max, u(LOG2D, 0),
                             if_(fifo_write,
                                 (wr_ptr.as_uint(LOG2D) + 1)
                                 .as_uint(LOG2D),
                                 wr_ptr)))
            nxt_rd = if_(flush, u(LOG2D, 0),
                         if_(fifo_read & rd_max, u(LOG2D, 0),
                             if_(fifo_read,
                                 (rd_ptr.as_uint(LOG2D) + 1)
                                 .as_uint(LOG2D),
                                 rd_ptr)))
            # data_cnt next (CNT_W wide arithmetic)
            dec = (data_cnt.as_uint(CNT_W) - 1).as_uint(CNT_W)
            inc = (data_cnt.as_uint(CNT_W) + 1).as_uint(CNT_W)
            nxt_cnt = if_(flush, u(CNT_W, 0),
                          if_(fifo_read & ~fifo_write & ~fifo_empty,
                              dec,
                              if_(fifo_write & ~fifo_read & ~fifo_full,
                                  inc,
                                  data_cnt.as_bits(CNT_W))))

            rw = async_reg(nxt_wr, ports.clk, ports.reset_n, name="wr_ptr")
            rr = async_reg(nxt_rd, ports.clk, ports.reset_n, name="rd_ptr")
            rc = async_reg(nxt_cnt, ports.clk, ports.reset_n, name="data_cnt")
            wr_ptr.assign(rw.as_bits(LOG2D))
            rd_ptr.assign(rr.as_bits(LOG2D))
            data_cnt.assign(rc.as_bits(CNT_W))

    return RegFifo


def make_reg_fifo_system(FIFO_WIDTH: int = 32, FIFO_DEPTH: int = 16,
                         output_directory: str | None = None):
    top = make_reg_fifo(FIFO_WIDTH, FIFO_DEPTH)
    return System([top], name="reg_fifo",
                  output_directory=output_directory or "build/reg_fifo")
