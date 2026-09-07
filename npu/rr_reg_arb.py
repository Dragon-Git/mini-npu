# Equivalence target: rtl_ref/ethosu55_rr_reg_arb.sv
#
#   module #(WIDTH) (
#     input  clk, reset_n, enable_i,
#     input  [WIDTH-1:0] requests_i,
#     output [WIDTH-1:0] arb_o);
#
#   next_rr_counter = (rr_counter >= WIDTH-1) ? 0 : rr_counter + 1;
#   rr_counter <= reset_n ? (enable_i ? next : rr_counter) : 0;  // async rst
#   u_arb: ethosu55_rr_arb (see rr_arb.py) drives arb_o.
#
# The counter's next-value expression depends on the counter itself, so we
# build it through a pycde Wire (backedge): declare wire q, compute next
# from q, register it, assign q <= reg output.
#
# Gate hierarchy mirrors the ARM hierarchy 1:1 (rr_reg_arb -> rr_arb) so
# EQY partitions map onto the inner arbiter naturally.

from pycde import Clock, Input, Module, Output, System, generator
from pycde.constructs import Wire
from pycde.types import Bits

from .common import async_reg, clog2, if_, u
from .rr_arb import make_rr_arb


def make_rr_reg_arb(WIDTH: int = 6):

    rr_arb_mod = make_rr_arb(WIDTH)
    CTR_W = clog2(WIDTH) if WIDTH > 1 else 1
    MAX = WIDTH - 1

    class RrRegArb(Module):

        clk = Clock()
        reset_n = Input(Bits(1))
        enable_i = Input(Bits(1))
        requests_i = Input(Bits(WIDTH))
        arb_o = Output(Bits(WIDTH))

        @generator
        def construct(ports):
            q = Wire(Bits(CTR_W), "rr_counter")

            en = ports.enable_i
            ge_max = (q.as_uint(CTR_W) >=
                      u(CTR_W, MAX).as_uint(CTR_W)).as_bits(1)
            nxt = if_(en,
                      if_(ge_max,
                          Bits(CTR_W)(0).as_uint(CTR_W),
                          (q.as_uint(CTR_W) + 1).as_uint(CTR_W)),
                      q.as_bits(CTR_W).as_uint(CTR_W))

            r = async_reg(nxt, ports.clk, ports.reset_n, name="rr_counter")
            q.assign(r.as_bits(CTR_W))

            arb = rr_arb_mod(rr_counter_i=q.as_bits(CTR_W),
                             requests_i=ports.requests_i)
            ports.arb_o = arb.arb_o

    return RrRegArb


def make_rr_reg_arb_system(WIDTH: int = 6, output_directory: str | None = None):
    top = make_rr_reg_arb(WIDTH)
    return System([top], name="rr_reg_arb",
                  output_directory=output_directory or "build/rr_reg_arb")
