# Register helpers matching the Arm Ethos-U55 reset style.
#
# The ARM RTL uses asynchronous, active-low resets:
#     always_ff @(posedge clk or negedge reset_n) if (!reset_n) ...
# PyCDE's high-level `Reg()` lowers to seq.compreg (sync reset only), so
# registers here go through seq.firreg with isAsync=True to reproduce the
# exact reset behaviour -- a hard requirement for equivalence checking.

from pycde.dialects import seq
from pycde.signals import BitVectorSignal
from pycde.types import Bits


def clog2(n: int) -> int:
    """Same semantics as SV $clog2: ceil(log2(n)), $clog2(1) == 0."""
    assert n > 0
    w = 0
    v = n - 1
    while v > 0:
        v >>= 1
        w += 1
    return w


def async_reg(value: BitVectorSignal, clk, rst_n, name: str = None):
    """Register `value` with async active-low reset to zero.

    Mirrors: always_ff @(posedge clk or negedge rst_n) if (!rst_n) q <= '0;
    """
    return seq.FirRegOp(value.value, clk.value, name,
                        reset=rst_n.value,
                        resetValue=Bits(value.type.width)(0).value,
                        isAsync=True)


def zero(w: int) -> BitVectorSignal:
    return Bits(w)(0)


def one(w: int) -> BitVectorSignal:
    return Bits(w)(1)
