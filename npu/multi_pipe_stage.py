# Equivalence target: rtl_ref/ethosu55_multi_pipe_stage.sv
#
#   module #(WIDTH=64, NUM_READERS=2) (
#     input  clk, reset_n,
#     input  in_valid_i, [WIDTH-1:0] in_data_i,
#     output in_ready_o, [NUM_READERS-1:0] out_valid_o,
#     output [WIDTH-1:0] out_data_o,
#     input  [NUM_READERS-1:0] out_ready_i);
#
# Exact ARM equations:
#   nxt_valid[i] = (in_valid && in_ready) ? 1 :
#                  out_ready[i]           ? 0 : s_valid[i]
#   i_in_ready[i] = !s_valid[i] || out_ready[i]
#   in_ready_o    = &i_in_ready
#   s_valid/s_data <= (async reset 0) nxt_valid / (in_valid&&in_ready ? in_data : s_data)
#   out_valid_o = s_valid ; out_data_o = s_data

from pycde import Clock, Input, Module, Output, System, generator
from pycde.constructs import Wire
from pycde.types import Bits

from .common import async_reg, if_, u


def make_multi_pipe_stage(WIDTH: int = 64, NUM_READERS: int = 2):

    class MultiPipeStage(Module):
        WIDTH = WIDTH
        NUM_READERS = NUM_READERS

        clk = Clock()
        reset_n = Clock()
        in_valid_i = Input(Bits(1))
        in_data_i = Input(Bits(WIDTH))
        out_ready_i = Input(Bits(NUM_READERS))
        in_ready_o = Output(Bits(1))
        out_valid_o = Output(Bits(NUM_READERS))
        out_data_o = Output(Bits(WIDTH))

        @generator
        def construct(ports):
            n = NUM_READERS

            s_valid = Wire(Bits(n), "s_valid")
            s_data = Wire(Bits(WIDTH), "s_data")

            in_valid = ports.in_valid_i

            # per-reader ready
            i_in_ready_bits = []
            for i in range(n):
                rdy = (~s_valid[i] | ports.out_ready_i[i]).as_bits(1)
                i_in_ready_bits.append(rdy)
            i_in_ready = Bits.concat(list(reversed(i_in_ready_bits)))
            in_ready = i_in_ready.and_reduce()  # &i_in_ready

            nxt_valid_bits = []
            for i in range(n):
                nxt_valid_bits.append(
                    if_(in_valid & in_ready, u(1, 1),
                        if_(ports.out_ready_i[i], u(1, 0),
                            s_valid[i].as_bits(1))))
            nxt_valid = Bits.concat(list(reversed(nxt_valid_bits)))

            advance = in_valid & in_ready
            nxt_data = if_(advance, ports.in_data_i, s_data.as_bits(WIDTH))

            rv = async_reg(nxt_valid, ports.clk, ports.reset_n, name="s_valid")
            rd = async_reg(nxt_data, ports.clk, ports.reset_n, name="s_data")
            s_valid.assign(rv.as_bits(n))
            s_data.assign(rd.as_bits(WIDTH))

            ports.in_ready_o = in_ready
            ports.out_valid_o = rv.as_bits(n)
            ports.out_data_o = rd.as_bits(WIDTH)

    return MultiPipeStage


def make_multi_pipe_stage_system(WIDTH: int = 64, NUM_READERS: int = 2,
                                 output_directory: str | None = None):
    top = make_multi_pipe_stage(WIDTH, NUM_READERS)
    return System([top], name="multi_pipe_stage",
                  output_directory=output_directory or "build/multi_pipe_stage")
