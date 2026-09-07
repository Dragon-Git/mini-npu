"""Expose the top-level PyCDE modules for programmatic use."""

from .back_buf import make_back_buf, make_back_buf_system
from .bin2onehot import make_bin2onehot, make_bin2onehot_system
from .multi_pipe_stage import make_multi_pipe_stage, make_multi_pipe_stage_system
from .onehot_mux import make_onehot_mux, make_onehot_mux_system
from .or_tree_w6 import make_or_tree_w6, make_or_tree_w6_system
from .reg_fifo import make_reg_fifo, make_reg_fifo_system
from .rr_arb import make_rr_arb, make_rr_arb_system
from .rr_reg_arb import make_rr_reg_arb, make_rr_reg_arb_system
from .stream_len import make_stream_len, make_stream_len_system

__all__ = [
    "make_back_buf",
    "make_back_buf_system",
    "make_bin2onehot",
    "make_bin2onehot_system",
    "make_multi_pipe_stage",
    "make_multi_pipe_stage_system",
    "make_onehot_mux",
    "make_onehot_mux_system",
    "make_or_tree_w6",
    "make_or_tree_w6_system",
    "make_reg_fifo",
    "make_reg_fifo_system",
    "make_rr_arb",
    "make_rr_arb_system",
    "make_rr_reg_arb",
    "make_rr_reg_arb_system",
    "make_stream_len",
    "make_stream_len_system",
]
