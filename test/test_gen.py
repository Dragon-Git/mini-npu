"""Local smoke tests: PyCDE generation must produce SV for every module.

These run on x86_64 with pycde installed; in CI the generation job covers
this implicitly, and the equiv jobs do the real verification.
"""

import os
import re
import subprocess
import sys

import pytest

pytest.importorskip("pycde", reason="pycde requires x86_64 manylinux wheel")

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

MODULES = [
    "bin2onehot", "onehot_mux", "rr_arb", "rr_reg_arb", "or_tree_w6",
    "back_buf", "reg_fifo", "multi_pipe_stage", "stream_len",
]


def test_generate_all(tmp_path):
    out = tmp_path / "build"
    res = subprocess.run(
        [sys.executable, os.path.join(ROOT, "script", "gen_sv.py"), str(out)],
        cwd=ROOT, capture_output=True, text=True)
    assert res.returncode == 0, res.stdout + res.stderr
    for m in MODULES:
        sv = out / m / f"{m}.sv"
        assert sv.exists(), f"missing {sv}"
        text = sv.read_text()
        assert f"module {m}" in text


def test_gold_renames(tmp_path):
    res = subprocess.run(
        [sys.executable, os.path.join(ROOT, "script", "make_gold_renames.py")],
        cwd=ROOT, capture_output=True, text=True)
    assert res.returncode == 0, res.stdout + res.stderr
    for m in MODULES:
        gold = os.path.join(ROOT, "build", "gold_ref", f"{m}_gold.sv")
        assert os.path.exists(gold), f"missing {gold}"
        text = open(gold).read()
        assert re.search(rf"module\s+{m}_gold\s*[#(;]", text), gold
    # stream_len wrapper
    res = subprocess.run(
        [sys.executable, os.path.join(ROOT, "script",
                                      "make_gold_wrapper_stream_len.py")],
        cwd=ROOT, capture_output=True, text=True)
    assert res.returncode == 0, res.stdout + res.stderr
    wrap = os.path.join(ROOT, "build", "gold_ref", "stream_len_gold_wrapper.sv")
    assert os.path.exists(wrap)
    assert "module stream_len_gold" in open(wrap).read()
