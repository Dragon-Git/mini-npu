#!/usr/bin/env python3
"""Generate all mini-npu SystemVerilog outputs with PyCDE.

Usage:  python3 script/gen_sv.py [output_dir]

Produces <output_dir>/<module>/<ModuleName>.sv plus a flattened
<output_dir>/gold.sv containing every generated module (used as the EQY
"gate" side... actually gold side: hand-written RTL is the gate).
"""

import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from npu import (  # noqa: E402
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

CONFIGS = {
    "bin2onehot": (make_bin2onehot_system, {}),
    "onehot_mux": (make_onehot_mux_system, {}),
    "rr_arb": (make_rr_arb_system, {}),
    "rr_reg_arb": (make_rr_reg_arb_system, {}),
    "or_tree_w6": (make_or_tree_w6_system, {}),
    "back_buf": (make_back_buf_system, {}),
    "reg_fifo": (make_reg_fifo_system, {}),
    "multi_pipe_stage": (make_multi_pipe_stage_system, {}),
    "stream_len": (make_stream_len_system, {}),
}


def main():
    out_root = sys.argv[1] if len(sys.argv) > 1 else "build"
    for name, (factory, kwargs) in CONFIGS.items():
        outdir = os.path.join(out_root, name)
        print(f"== generating {name} -> {outdir}")
        system = factory(output_directory=outdir, **kwargs)
        system.compile()
        sv = os.path.join(outdir, name + ".sv")
        assert os.path.exists(sv), f"missing output {sv}"
        print(f"   ok: {sv} ({os.path.getsize(sv)} bytes)")


if __name__ == "__main__":
    main()
