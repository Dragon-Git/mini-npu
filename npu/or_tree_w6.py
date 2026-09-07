# Equivalence target: rtl_ref/ethosu55_or_tree_w6.sv
#
#   module (inputs_i[5:0], output_o);
#   5x ethosu55_cdc_or2 cells in the exact same tree:
#     s00 = in0|in1 ; s01 = in2|in3 ; s10 = in4|in5
#     s11 = s00|s01 ; out = s10|s11
#
# The gate side instantiates ethosu55_cdc_or2 (a `rtl_ref` cell with a
# `cell_define` pragma that yosys treats as a blackbox unless the model is
# provided -- rtl_ref/ethosu55_cdc_or2.sv gives the functional model).
# We build the same 2-input OR tree shape.

from pycde import Clock, Module, System
from pycde.types import Bits


def make_or_tree_w6():

    class OrTreeW6(Module):
        inputs_i = Input(Bits(6))
        output_o = Output(Bits(1))

        @generator
        def construct(ports):
            i = ports.inputs_i
            # stage 0
            s00 = (i[0] | i[1]).as_bits(1)
            s01 = (i[2] | i[3]).as_bits(1)
            s10 = (i[4] | i[5]).as_bits(1)
            # stage 1
            s11 = (s00 | s01).as_bits(1)
            # stage 2
            ports.output_o = (s10 | s11).as_bits(1)

    return OrTreeW6


def make_or_tree_w6_system(output_directory: str = None):
    top = make_or_tree_w6()
    return System([top], name="or_tree_w6",
                  output_directory=output_directory or "build/or_tree_w6")
