# Equivalence target: rtl_ref/ethosu55_bin2onehot.sv
#
#   module #(ONEHOT_W, BIN_W = $clog2(ONEHOT_W), DIS_ASRT) (
#     input  asrt_clk, asrt_rst_n,
#     input  [BIN_W-1:0]  bin_i,
#     output [ONEHOT_W-1:0] vec_o);
#   vec_o[v] = (bin_i == v[BIN_W-1:0]);
#
# Pure combinational one-hot decoder. The asrt_* ports are assertion-only
# plumbing and carry no logic; we keep identically-named (unused) ports so
# the port lists of gold and gate line up for EQY.

from pycde import Clock, Input, Module, Output, System, generator
from pycde.types import Bits

from .common import clog2


def make_bin2onehot(ONEHOT_W: int = 128):

    BIN_W = clog2(ONEHOT_W)

    class Bin2Onehot(Module):
        # Ports match rtl_ref/ethosu55_bin2onehot.sv exactly.
        asrt_clk = Clock()
        asrt_rst_n = Clock()
        bin_i = Input(Bits(BIN_W))
        vec_o = Output(Bits(ONEHOT_W))

        @generator
        def construct(ports):
            bin_v = ports.bin_i
            parts = []
            for v in range(ONEHOT_W):
                parts.append((bin_v == Bits(BIN_W)(v)).as_bits(1))
            # Bits.concat takes a list ordered MSB-first.
            ports.vec_o = Bits.concat(list(reversed(parts)))

    return Bin2Onehot


def make_bin2onehot_system(ONEHOT_W: int = 128, output_directory: str | None = None):
    top = make_bin2onehot(ONEHOT_W)
    return System([top], name="bin2onehot",
                  output_directory=output_directory or "build/bin2onehot")
