# Register + expression helpers matching the Arm Ethos-U55 reset style.
#
# The ARM RTL uses asynchronous, active-low resets:
#     always_ff @(posedge clk or negedge reset_n) if (!reset_n) ...
# PyCDE's high-level `Reg()` lowers to seq.compreg (sync reset only), so
# registers here go through seq.firreg with isAsync=True to reproduce the
# exact reset behaviour -- a hard requirement for equivalence checking.
#
# Note on Mux(): pycde.constructs.Mux(sel, a, b) lowers to
# comb.mux %sel, %b, %a  i.e. it returns (sel ? b : a) -- the operand order
# is INVERTED relative to the SV ternary. We keep our own if_(sel, t, f)
# so model code reads like the SV it mirrors.

import inspect

from pycde.constructs import NamedWire
from pycde.dialects import seq
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


def u(w: int, val: int) -> Bits:
    return Bits(w)(val)


def zero(w: int) -> Bits:
    return Bits(w)(0)


def one(w: int) -> Bits:
    return Bits(w)(1)


def if_(sel, t, f):
    """(sel ? t : f) -- corrects the inverted operand order of
    pycde.constructs.Mux(sel, a, b) == comb.mux(sel, b, a)."""
    from pycde.constructs import Mux as _M
    return _M(sel, f, t)


def _caller_name(default: str) -> str:
    """Best-effort name for NamedWire from the calling variable."""
    try:
        frame = inspect.stack()[2]
        return frame.code_context[0].split("=")[0].strip() or default
    except (IndexError, AttributeError, TypeError):
        return default


def wire(bits_w: int, name: str | None = None):
    return NamedWire(Bits(bits_w), name or _caller_name(f"w_{bits_w}"))


def async_reg(next_value, clk, rst_n, name: str | None = None):
    """Register `next_value` with async active-low reset to zero.

    Mirrors: always_ff @(posedge clk or negedge rst_n) if (!rst_n) q <= '0;
    Returns the register output signal (BitVectorSignal over the same type).
    """
    w = next_value.type.width
    return seq.FirRegOp(next_value.value, clk.value, name or "reg",
                        reset=rst_n.value,
                        resetValue=Bits(w)(0).value,
                        isAsync=True).result


def sync_reg(next_value, clk, rst_n, name: str | None = None):
    """Same as async_reg but with a synchronous reset (seq default)."""
    w = next_value.type.width
    return seq.FirRegOp(next_value.value, clk.value, name or "reg",
                        reset=rst_n.value,
                        resetValue=Bits(w)(0).value,
                        isAsync=False).result
