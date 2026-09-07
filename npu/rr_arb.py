# Equivalence target: rtl_ref/ethosu55_rr_arb.sv
#
#   module #(WIDTH = 6, ALLOW_REQ_X) (
#     input  asrt_clk, asrt_rst_n,
#     input  [clog2(WIDTH)-1:0] rr_counter_i,
#     input  [WIDTH-1:0] requests_i,
#     output [WIDTH-1:0] arb_o);
#
# Round-robin arbiter, combinational. The RTL doubles the request vector
# ({requests & below_cnt, requests & ~below_cnt}) and finds the first set
# bit with a prefix-OR priority chain:
#   arb = first_req(req_long[0+:WIDTH]) | first_req(req_long[WIDTH+:WIDTH])
# We build the identical prefix chain bit-by-bit.

from pycde import Clock, Module, System
from pycde.types import Bits

from .common import clog2, zero


def make_rr_arb(WIDTH: int = 6):

    CNT_W = clog2(WIDTH) if WIDTH > 1 else 1

    class RrArb(Module):
        WIDTH = WIDTH
        CNT_W = CNT_W

        asrt_clk = Clock()
        asrt_rst_n = Clock()
        rr_counter_i = Input(Bits(CNT_W))
        requests_i = Input(Bits(WIDTH))
        arb_o = Output(Bits(WIDTH))

        @generator
        def construct(ports):
            reqs = ports.requests_i
            cnt = ports.rr_counter_i

            # req_below_counter[i] = (i < rr_counter_i)
            below = [(cnt > Bits(CNT_W)(i)).as_bits(1) for i in range(WIDTH)]

            # SV: req_long = {requests & below, requests & ~below}
            # LSB half (indices [0:WIDTH])      = requests & ~below (i >= cnt)
            # MSB half (indices [WIDTH:2WIDTH]) = requests &  below (i <  cnt)
            req_long = [(reqs[i] & ~below[i]).as_bits(1) for i in range(WIDTH)] + \
                       [(reqs[i] & below[i]).as_bits(1) for i in range(WIDTH)]

            # prefix-OR "lower set" chain over 2*WIDTH bits
            lower = [zero(1)]
            for i in range(1, 2 * WIDTH):
                lower.append((lower[i - 1] | req_long[i - 1]).as_bits(1))

            first = [(req_long[i] & ~lower[i]).as_bits(1)
                     for i in range(2 * WIDTH)]

            arb_bits = [(first[i] | first[i + WIDTH]).as_bits(1)
                        for i in range(WIDTH)]
            ports.arb_o = Bits.concat(list(reversed(arb_bits)))

    return RrArb


def make_rr_arb_system(WIDTH: int = 6, output_directory: str = None):
    top = make_rr_arb(WIDTH)
    return System([top], name="rr_arb",
                  output_directory=output_directory or "build/rr_arb")
