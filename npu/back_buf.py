# Equivalence target: rtl_ref/ethosu55_back_buf.sv
#
#   module #(DEPTH=3, WIDTH=64) (
#     input  clk, reset_n,
#     input  in_valid_i [WIDTH-1:0] in_data_i,
#     output out_valid_o [WIDTH-1:0] out_data_o,
#     input  out_ready_i);
#
# A DEPTH-deep bypass buffer. Exact ARM equations:
#   i_fifo_empty = (in_ptr == out_ptr) ? !maybe_full : 0
#   i_fifo_get   = out_ready && !empty
#   i_fifo_put   = in_valid && (!out_ready || !empty)
#   out_data_o   = empty ? in_data : s_regs[out_ptr]
#   out_valid_o  = !empty || in_valid
#   slot regs:   en[i] = (in_ptr == i) && put;  q = en ? in_data : q
#   in_ptr/out_ptr/maybe_full updated per nxt_* equations (async reset 0)
#
# The slot memory becomes DEPTH DFFs with clock enables -- no yosys memory
# modelling needed (each slot is addressed by a decoded enable), which
# keeps the equivalence partition simple.

from pycde import Clock, Input, Module, Output, System, generator
from pycde.constructs import Wire
from pycde.types import Bits

from .common import async_reg, clog2, if_, u


def make_back_buf(DEPTH: int = 3, WIDTH: int = 64):

    PTR_W = clog2(DEPTH)          # ptr_t is $clog2(DEPTH) bits
    MAXP = DEPTH - 1              # last pointer value (wraps to 0)

    class BackBuf(Module):

        clk = Clock()
        reset_n = Clock()
        in_valid_i = Input(Bits(1))
        in_data_i = Input(Bits(WIDTH))
        out_ready_i = Input(Bits(1))
        out_valid_o = Output(Bits(1))
        out_data_o = Output(Bits(WIDTH))

        @generator
        def construct(ports):
            # state wires (backedges)
            s_in_ptr = Wire(Bits(PTR_W), "s_in_ptr")
            s_out_ptr = Wire(Bits(PTR_W), "s_out_ptr")
            s_maybe_full = Wire(Bits(1), "s_maybe_full")
            s_regs = [Wire(Bits(WIDTH), f"s_regs_{i}") for i in range(DEPTH)]

            in_valid = ports.in_valid_i
            out_ready = ports.out_ready_i

            # control
            empty = (s_in_ptr == s_out_ptr).as_bits(1) & ~s_maybe_full
            f_get = out_ready & ~empty
            f_put = in_valid & (~out_ready | ~empty)

            # outputs
            out_data = if_(empty, ports.in_data_i, s_regs[0].as_bits(WIDTH))
            ports.out_data_o = out_data
            ports.out_valid_o = (~empty | in_valid).as_bits(1)

            # slot registers: en[i] = (in_ptr == i) & put
            for i in range(DEPTH):
                en = (s_in_ptr == u(PTR_W, i)).as_bits(1) & f_put
                nxt = if_(en, ports.in_data_i, s_regs[i].as_bits(WIDTH))
                r = async_reg(nxt, ports.clk, ports.reset_n,
                              name=f"s_regs{i}")
                s_regs[i].assign(r.as_bits(WIDTH))

            # next-pointer logic
            in_wrap = (s_in_ptr == u(PTR_W, MAXP)).as_bits(1)
            out_wrap = (s_out_ptr == u(PTR_W, MAXP)).as_bits(1)
            nxt_in_ptr = if_(f_put,
                             if_(in_wrap, u(PTR_W, 0),
                                 (s_in_ptr.as_uint(PTR_W) + 1)
                                 .as_uint(PTR_W)),
                             s_in_ptr)
            nxt_out_ptr = if_(f_get,
                              if_(out_wrap, u(PTR_W, 0),
                                  (s_out_ptr.as_uint(PTR_W) + 1)
                                  .as_uint(PTR_W)),
                              s_out_ptr)
            # maybe_full: put&&!get -> 1 ; get&&!put -> 0 ; else hold
            nxt_mf = if_(f_put & ~f_get, u(1, 1),
                         if_(f_get & ~f_put, u(1, 0),
                             s_maybe_full))

            rin = async_reg(nxt_in_ptr, ports.clk, ports.reset_n,
                            name="s_in_ptr")
            rout = async_reg(nxt_out_ptr, ports.clk, ports.reset_n,
                             name="s_out_ptr")
            rmf = async_reg(nxt_mf, ports.clk, ports.reset_n,
                            name="s_maybe_full")
            s_in_ptr.assign(rin.as_bits(PTR_W))
            s_out_ptr.assign(rout.as_bits(PTR_W))
            s_maybe_full.assign(rmf.as_bits(1))

    return BackBuf


def make_back_buf_system(DEPTH: int = 3, WIDTH: int = 64,
                         output_directory: str | None = None):
    top = make_back_buf(DEPTH, WIDTH)
    return System([top], name="back_buf",
                  output_directory=output_directory or "build/back_buf")
