# Equivalence target: rtl_ref/ethosu55_rr_reg_arb.sv
#
#   module #(WIDTH = 6, ALLOW_REQ_X) (
#     input  clk, reset_n, enable_i,
#     input  [WIDTH-1:0] requests_i,
#     output [WIDTH-1:0] arb_o);
#
# Wraps ethosu55_rr_arb with an enable-gated round-robin counter:
#   next_rr_counter = (rr_counter >= WIDTH-1) ? 0 : rr_counter + 1
# The counter register has an async active-low reset (-> async_reg).
# The combinational arbiter is instantiated as a nested PyCDE module with
# port names matching the inner ethosu55_rr_arb instance.

from pycde import Clock, Module, System
from pycde.constructs import Mux, NamedWire
from pycde.types import Bits

from .common import async_reg, clog2, zero
from .rr_arb import make_rr_arb


def make_rr_reg_arb(WIDTH: int = 6):

    CNT_W = clog2(WIDTH) if WIDTH > 1 else 1
    Arb = make_rr_arb(WIDTH)

    class RrRegArb(Module):
        WIDTH = WIDTH
        CNT_W = CNT_W

        clk = Clock()
        reset_n = Clock()
        enable_i = Input(Bits(1))
        requests_i = Input(Bits(WIDTH))
        arb_o = Output(Bits(WIDTH))

        @generator
        def construct(ports):
            clk, rst_n, en = ports.clk, ports.reset_n, ports.enable_i

            zero_v = zero(CNT_W)
            one_v = Bits(CNT_W)(1)
            max_v = Bits(CNT_W)(WIDTH - 1)

            # counter next-value logic (mirrors nxt_rr_counter / enable gate)
            cnt_free = NamedWire(Bits(CNT_W), "next_rr_counter")
            cnt_free.assign(Mux(cnt_free == max_v, zero_v,
                                (cnt_free + one_v).as_uint(CNT_W)))

            from pycde.constructs import Wire
            nxt = Wire(Bits(CNT_W))
            nxt.assign(Mux(en.as_bits(1), cnt_free, cnt_free))

            # register: async reset, enable-gated update
            # RTL: if (!reset_n) 0 elif (enable) nxt
            # -> compreg input = Mux(enable, nxt, cnt)
            w_cnt = NamedWire(Bits(CNT_W), "rr_counter")
            cnt_q = async_reg(w_cnt, clk, rst_n, name="rr_counter")
            w_cnt.assign(Mux(en.as_bits(1), cnt_free, cnt_q))

            arb = Arb(clk=clk, rst_n=rst_n, rr_counter_i=cnt_q,
                      requests_i=ports.requests_i)
            ports.arb_o = arb.arb_o

    return RrRegArb


def make_rr_reg_arb_system(WIDTH: int = 6, output_directory: str = None):
    top = make_rr_reg_arb(WIDTH)
    return System([top], name="rr_reg_arb",
                  output_directory=output_directory or "build/rr_reg_arb")
