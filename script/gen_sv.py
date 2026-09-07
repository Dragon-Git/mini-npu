#!/usr/bin/env python3
"""Generate SystemVerilog for every mini-npu module with PyCDE.

Usage: python3 script/gen_sv.py [output_root]   (default: build)

pycde's System.compile() writes split verilog into <out>/<name>/hw/.
We collect the top-level file (named after the top module class) and copy
it to <out>/<module>/<module>.sv, which is what the eqy configs expect.
"""

import os
import shutil
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from npu import (  # noqa: E402
    make_bin2onehot_system, make_onehot_mux_system, make_rr_arb_system,
    make_rr_reg_arb_system, make_or_tree_w6_system, make_back_buf_system,
    make_reg_fifo_system, make_multi_pipe_stage_system,
    make_stream_len_system,
)


def main():
    root = sys.argv[1] if len(sys.argv) > 1 else "build"
    builders = {
        "bin2onehot": (make_bin2onehot_system, "Bin2Onehot"),
        "onehot_mux": (make_onehot_mux_system, "OnehotMux"),
        "rr_arb": (make_rr_arb_system, "RrArb"),
        "rr_reg_arb": (make_rr_reg_arb_system, "RrRegArb"),
        "or_tree_w6": (make_or_tree_w6_system, "OrTreeW6"),
        "back_buf": (make_back_buf_system, "BackBuf"),
        "reg_fifo": (make_reg_fifo_system, "RegFifo"),
        "multi_pipe_stage": (make_multi_pipe_stage_system, "MultiPipeStage"),
        "stream_len": (make_stream_len_system, "StreamLen"),
    }
    for name, (make, clsname) in builders.items():
        outdir = os.path.join(root, name)
        os.makedirs(outdir, exist_ok=True)
        print(f"=== generating {name} -> {outdir}")
        system = make(output_directory=outdir)
        system.compile()

        hw_dir = os.path.join(outdir, "hw")
        # top-level file: split verilog names it after the hw.module
        # (== the Python class name).
        src = os.path.join(hw_dir, f"{clsname}.sv")
        if not os.path.exists(src):
            # fall back: find the biggest .sv file in hw/ (top has all logic)
            cands = [f for f in os.listdir(hw_dir) if f.endswith(".sv")]
            assert cands, f"no sv files in {hw_dir}"
            src = os.path.join(hw_dir, max(
                cands, key=lambda f: os.path.getsize(os.path.join(hw_dir, f))))
            print(f"    note: top file guess -> {src}")
        dst = os.path.join(outdir, f"{name}.sv")
        shutil.copy(src, dst)
        print(f"    wrote {dst} ({os.path.getsize(dst)} bytes)")


if __name__ == "__main__":
    main()
