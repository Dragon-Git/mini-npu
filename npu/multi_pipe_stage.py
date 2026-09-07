# Equivalence target: rtl_ref/ethosu55_multi_pipe_stage.sv
#
#   module #(WIDTH=64, NUM_READERS=2) (
#     clk, reset_n, in_valid_i, in_data_i, in_ready_o,
#     out_valid_o[NUM_READERS], out_data_o, out_ready_i[NUM_READERS]);
#
# Valid/data pipe stage with replicated output valid per reader:
#   nxt_valid[i] = (in_valid && in_ready) ? 1 : out_ready[i] ? 0 : s_valid[i]
#   i_in_ready[i]= !s_valid[i] || out_ready[i] ; in_ready = AND over i
#   data captured when (in_valid && in_ready)
# Async active-low reset.

from pycde import Clock, Module, System
from pycde.constructs import Mux, NamedWire
from pycde.types import Bits

from .common import async_reg, zero


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
            clk, rst_n = ports.clk, ports.reset_n
            iv = ports.in_valid_i.as_bits(1)
            o_rdy = ports.out_ready_i

            w_valid = NamedWire(Bits(NUM_READERS), "s_valid")
            q_valid = async_reg(w_valid, clk, rst_n, name="s_valid")
            w_data = NamedWire(Bits(WIDTH), "s_data")
            q_data = async_reg(w_data, clk, rst_n, name="s_data")

            # per-reader next-valid and in_ready
            in_ready_bits = []
            nxt_valid_bits = []
            for i in range(NUM_READERS):
                rd = o_rdy[i].as_bits(1)
                # note: RTL uses the *computed* in_ready_o (AND of all
                # readers) inside nxt_valid; we compute it first, then mux.
                in_ready_bits.append((~q_valid[i].as_bits(1) | rd).as_bits(1))
            in_ready = in_ready_bits[0]
            for i in range(1, NUM_READERS):
                in_ready = (in_ready & in_ready_bits[i]).as_bits(1)

            go = (iv & in_ready).as_bits(1)
            for i in range(NUM_READERS):
                rd = o_rdy[i].as_bits(1)
                nv = Mux(go, Bits(1)(1),
                         Mux(rd, Bits(1)(0), q_valid[i].as_bits(1)))
                nxt_valid_bits.append(nv)
            w_valid.assign(Bits.concat(list(reversed(nxt_valid_bits))))

            w_data.assign(Mux(go, ports.in_data_i, q_data))

            ports.in_ready_o = in_ready
            ports.out_valid_o = q_valid
            ports.out_data_o = q_data

    return MultiPipeStage


def make_multi_pipe_stage_system(WIDTH: int = 64, NUM_READERS: int = 2,
                                 output_directory: str = None):
    top = make_multi_pipe_stage(WIDTH, NUM_READERS)
    return System([top], name="multi_pipe_stage",
                  output_directory=output_directory or "build/multi_pipe_stage")
