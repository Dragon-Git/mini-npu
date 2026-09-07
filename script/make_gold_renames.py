#!/usr/bin/env python3
"""Rename each ARM reference module to <name>_gold for EQY.

The ARM RTL is the EQY *gold* side (3-valued semantics legalizes the 'x'
default arms in the ARM case statements; the PyCDE output is purely
2-valued and takes the *gate* side).

Reads the rtl_ref files, rewrites `module <name>` -> `module <name>_gold`
in a copy under build/gold_ref/, and prints the mapping. Submodules keep
their original names (EQY pairs them with the same-named gate entities).
"""

import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

MODULES = {
    "bin2onehot": ["rtl_ref/ethosu55_bin2onehot.sv"],
    "onehot_mux": ["rtl_ref/ethosu55_onehot_mux.sv"],
    "rr_arb": ["rtl_ref/ethosu55_rr_arb.sv"],
    "rr_reg_arb": ["rtl_ref/ethosu55_rr_reg_arb.sv"],
    "or_tree_w6": ["rtl_ref/ethosu55_or_tree_w6.sv"],
    "back_buf": ["rtl_ref/ethosu55_back_buf.sv"],
    "reg_fifo": ["rtl_ref/ethosu55_reg_fifo.sv"],
    "multi_pipe_stage": ["rtl_ref/ethosu55_multi_pipe_stage.sv"],
    "stream_len": ["rtl_ref/ethosu55_dma_stream_len.sv"],
}


def rename_module(text, old, new):
    pat = re.compile(r"^(\s*module\s+)%s(\s*[#(;])" % re.escape(old),
                     re.MULTILINE)
    out, n = pat.subn(r"\g<1>%s\g<2>" % new, text, count=1)
    assert n == 1, f"module {old} not found"
    return out


def main():
    outdir = os.path.join(ROOT, "build", "gold_ref")
    os.makedirs(outdir, exist_ok=True)
    for gold, files in MODULES.items():
        gold_name = gold + "_gold"
        chunks = []
        for f in files:
            with open(os.path.join(ROOT, f)) as fh:
                chunks.append(fh.read())
        text = "\n".join(chunks)
        text = rename_module(text, gold, gold_name)
        out = os.path.join(outdir, gold_name + ".sv")
        with open(out, "w") as fh:
            fh.write(text)
        print(f"{gold} -> {out}")


if __name__ == "__main__":
    main()
