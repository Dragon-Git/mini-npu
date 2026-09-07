#!/usr/bin/env python3
"""Generate SystemVerilog for every mini-npu module with PyCDE.

Usage: python3 script/gen_sv.py [output_root]   (default: build)

Each module gets its own System (and thus its own top-level .sv):
    build/<module>/<module>.sv
"""

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from npu import (
    make_back_buf_system,
    make_bin2onehot_system,
    make_multi_pipe_stage_system,
    make_onehot_mux_system,
    make_or_tree_w6_system,
    make_reg_fifo_system,
    make_rr_arb_system,
    make_rr_reg_arb_system,
    make_stream_len_system,
)


def main():
    root = sys.argv[1] if len(sys.argv) > 1 else "build"
    builders = {
        "bin2onehot": make_bin2onehot_system,
        "onehot_mux": make_onehot_mux_system,
        "rr_arb": make_rr_arb_system,
        "rr_reg_arb": make_rr_reg_arb_system,
        "or_tree_w6": make_or_tree_w6_system,
        "back_buf": make_back_buf_system,
        "reg_fifo": make_reg_fifo_system,
        "multi_pipe_stage": make_multi_pipe_stage_system,
        "stream_len": make_stream_len_system,
    }
    for name, make in builders.items():
        outdir = os.path.join(root, name)
        os.makedirs(outdir, exist_ok=True)
        print(f"=== generating {name} -> {outdir}")
        system = make(output_directory=outdir)
        system.compile()
        sv = os.path.join(outdir, f"{name}.sv")
        assert os.path.exists(sv), f"expected {sv}"
        print(f"    wrote {sv} ({os.path.getsize(sv)} bytes)")


if __name__ == "__main__":
    main()
