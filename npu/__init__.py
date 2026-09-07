"""Expose the top-level PyCDE modules for programmatic use."""

from .bin2onehot import make_bin2onehot
from .back_buf import make_back_buf
from .multi_pipe_stage import make_multi_pipe_stage
from .onehot_mux import make_onehot_mux
from .or_tree_w6 import make_or_tree_w6
from .reg_fifo import make_reg_fifo
from .rr_arb import make_rr_arb
from .rr_reg_arb import make_rr_reg_arb
from .stream_len import make_stream_len

__all__ = [
    "make_bin2onehot", "make_onehot_mux", "make_rr_arb", "make_rr_reg_arb",
    "make_or_tree_w6", "make_back_buf", "make_reg_fifo",
    "make_multi_pipe_stage", "make_stream_len",
]
