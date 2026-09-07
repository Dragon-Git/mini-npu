# Equivalence target: rtl_ref/ethosu55_rr_arb.sv
#
#   module #(WIDTH, ALLOW_REQ_X) (
#     input  asrt_clk, asrt_rst_n,
#     input  [$clog2(WIDTH)-1:0] rr_counter_i,
#     input  [WIDTH-1:0] requests_i,
#     output [WIDTH-1:0] arb_o);
#
#   req_below_counter[i] = (i < rr_counter_i)
#   req_long = {requests_i & req_below_counter,     // high half: i <  ctr
#               requests_i & ~req_below_counter}    // low  half: i >= ctr
#   req_long_lower_set[0] = 0
#   req_long_lower_set[i] = req_long[i-1] | req_long_lower_set[i-1]
#   arb_o = (req_long[W-1:0]     & ~req_long_lower_set[W-1:0]) |
#           (req_long[2*W-1:W]   & ~req_long_lower_set[2*W-1:W])
#
# Pure combinational rotating-priority arbiter. Bit i of the low half
# corresponds to requester (ctr + i) mod W.

from pycde import Clock, Input, Module, Output, System, generator
from pycde.types import Bits

from .common import clog2


def make_rr_arb(WIDTH: int = 6):

    CTR_W = clog2(WIDTH) if WIDTH > 1 else 1

    class RrArb(Module):

        asrt_clk = Clock()
        asrt_rst_n = Clock()
        rr_counter_i = Input(Bits(CTR_W))
        requests_i = Input(Bits(WIDTH))
        arb_o = Output(Bits(WIDTH))

        @generator
        def construct(ports):
            w = WIDTH
            req = ports.requests_i
            ctr = ports.rr_counter_i

            # req_below_counter[i] = (i < rr_counter_i)
            below_bits = []
            for i in range(w):
                below_bits.append((ctr.as_uint(CTR_W) > i).as_bits(1))
            below = req.concat(list(reversed(below_bits)))  # [w-1:0]

            req_long_lo = req & ~below          # requesters i >= ctr
            req_long_hi = req & below           # requesters i <  ctr
            # req_long = {hi, lo}: hi occupies [2w-1:w], lo occupies [w-1:0]
            req_long = req.concat([req_long_hi, req_long_lo])  # [2w-1:0]

            # prefix-OR shifted by one: lower_set[i] = |req_long[i-1:0]
            lower_bits = []
            run = None
            for i in range(2 * w):
                bit_i = req_long[i].as_bits(1)
                if i == 0:
                    lower_bits.append(Bits(1)(0))
                    run = bit_i
                else:
                    lower_bits.append(run)
                    run = run | bit_i
            lower_set = req.concat(list(reversed(lower_bits)))  # [2w-1:0]

            arb = (req_long & ~lower_set)
            ports.arb_o = arb[0:w] | arb[w:2 * w]

    return RrArb


def make_rr_arb_system(WIDTH: int = 6, output_directory: str | None = None):
    top = make_rr_arb(WIDTH)
    return System([top], name="rr_arb",
                  output_directory=output_directory or "build/rr_arb")
