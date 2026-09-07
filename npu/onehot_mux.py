# Equivalence target: rtl_ref/ethosu55_onehot_mux.sv
#
#   module #(N, T = logic[0:0]) (
#     input  asrt_clk, asrt_rst_n,
#     input  [N-1:0] s_i,
#     input  T d_i [N-1:0],
#     output T m_o);
#   // for each bit j: m = |(s_i & d_transposed_j)
#
# We fix T = logic [W-1:0]. The unpacked array port d_i is passed as a
# single packed [N*W-1:0] vector: element i occupies bits [i*W +: W]
# (element 0 at the LSB end). The gold wrapper (make_gold_renames.py)
# provides the matching packed view on the ARM side.

from pycde import Input, Module, Output, System, generator
from pycde.types import Bits

from .common import zero


def make_onehot_mux(N: int = 4, W: int = 8):

    class OnehotMux(Module):

        s_i = Input(Bits(N))
        d_i = Input(Bits(N * W))
        m_o = Output(Bits(W))

        @generator
        def construct(ports):
            acc = zero(W)
            for i in range(N):
                sel = ports.s_i[i].as_bits(1)
                di = ports.d_i[i * W:(i + 1) * W]  # slice [i*W +: W]
                # sel & d_i[i], zero-extended to W bits, then OR-accumulate
                masked = sel.pad_or_truncate(W) & di
                acc = acc | masked
            ports.m_o = acc

    return OnehotMux


def make_onehot_mux_system(N: int = 4, W: int = 8, output_directory: str | None = None):
    top = make_onehot_mux(N, W)
    return System([top], name="onehot_mux",
                  output_directory=output_directory or "build/onehot_mux")
