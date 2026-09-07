# Equivalence target: rtl_ref/ethosu55_dma_stream_len.sv
#
# AXI burst-length calculator for the Ethos-U55 DMA streamers.
#
#   module (asrt_clk, asrt_rst_n,
#     stream_type_t stream_type_i, [31:0] addr_i, len_words_t rem_len_i,
#     region_t region_i, axi_config_t axi_cfg_i, axi_len_t calc_len_o)
#
# Reference constants (ethosu55_pkg / ethosu55_dma_pkg / ethosu55_cc_reg_pkg):
#   AXI_DATA_W=64, AXI_ADDR_W=32, AXI_LEN_W=8
#   AXI_DATA_W_BYTES=8, AXI_DATA_W_BYTES_LG=3
#   axi_len_t   = logic [7:0]
#   len_words_t = logic [32-3-1:0] = logic [27:0]
#   region_t    = logic [1:0]
#   axi_config_t = axi_config_elem_t[3:0], each elem (packed, 20 bits):
#       { max_beats[1:0], memtype[3:0], max_outst_rd[7:0], max_outst_wr[7:0] }
#     -> element i occupies axi_cfg_i bits [20*i +: 20]; max_beats of region i
#        is at bits [20*i+18 +: 2] (first member of the packed struct).
#   stream_type_t = 2 bits: 0=WGT, 1=BAS, 2=CMD, 3=M2M
#   axi_max_beats_t = 2 bits: 0=64B, 1=128B, 2=256B, 3=reserved
#
# Behaviour (get_max_beats):
#   WGT_STREAMER -> max_beats = axi_cfg[region].max_beats
#   BAS/CMD/M2M  -> BEATS_64_BYTES
#   (the RTL default 'x' case is unreachable for the 2-bit enum; EQY's
#    3-valued gold semantics would allow it, but stream_type_i is a 2-bit
#    signal so all 4 values are covered by the case arms we model. The
#    same holds for max_beats: all four 2-bit values have defined arms.)
#
# Burst computation:
#   64B/reserved : burst_len = 64>>3 = 8 beats; offset = addr[5:3]
#   128B / 256B  : burst_len = 128>>3 = 16 beats; offset = addr[6:3]
#   aligned      = (offset == 0)
#   unaligned_len= burst_len - offset
#   i_len = aligned ? min(rem_len, burst_len) : min(rem_len, unaligned_len)
#   calc_len_o = i_len - 1
#
# The 'x' defaults in the RTL case arms are dead code for enum inputs;
# EQY's x-prop-aware gold interpretation makes gold=x match anything the
# gate produces, so omitting them is safe.

from pycde import Clock, Module, System
from pycde.constructs import Mux
from pycde.types import Bits

from .common import clog2, zero

AXI_DATA_W = 64
AXI_ADDR_W = 32
AXI_LEN_W = 8
AXI_DATA_W_BYTES_LG = 3          # $clog2(64/8)
# axi_config_elem_t = max_beats(2) + memtype(4) + max_outst_rd(8) +
#                     max_outst_wr(8) = 22 bits
AXI_CFG_ELEM_W = 22
REGION_CNT = 4                   # MEMTYPE_CNT_NUM (region_t is 2 bits)
AXI_CFG_W = AXI_CFG_ELEM_W * REGION_CNT
STREAM_TYPE_W = 2
AXI_MAX_BEATS_W = 2
LEN_W = AXI_LEN_W
LEN_WORDS_W = AXI_ADDR_W - AXI_DATA_W_BYTES_LG   # 29
REGION_W = 2

WGT_STREAMER, BAS_STREAMER, CMD_STREAMER, M2M_STREAMER = 0, 1, 2, 3
BEATS_64, BEATS_128, BEATS_256, BEATS_RESERVED = 0, 1, 2, 3


def make_stream_len():

    class StreamLen(Module):
        asrt_clk = Clock()
        asrt_rst_n = Clock()
        stream_type_i = Input(Bits(STREAM_TYPE_W))
        addr_i = Input(Bits(AXI_ADDR_W))
        rem_len_i = Input(Bits(LEN_WORDS_W))
        region_i = Input(Bits(REGION_W))
        axi_cfg_i = Input(Bits(AXI_CFG_W))
        calc_len_o = Output(Bits(LEN_W))

        @generator
        def construct(ports):
            st = ports.stream_type_i
            region = ports.region_i

            # ---- get_max_beats ----
            # BAS/CMD/M2M -> BEATS_64; WGT -> axi_cfg[region].max_beats
            elem = zero(AXI_CFG_ELEM_W)
            for r in range(REGION_CNT):
                elem = Mux((region == Bits(REGION_W)(r)).as_bits(1),
                           ports.axi_cfg_i[r * AXI_CFG_ELEM_W:
                                           (r + 1) * AXI_CFG_ELEM_W],
                           elem)
            cfg_max_beats = elem[AXI_CFG_ELEM_W - 2:AXI_CFG_ELEM_W]

            is_wgt = (st == Bits(STREAM_TYPE_W)(WGT_STREAMER)).as_bits(1)
            i_max_beats = Mux(is_wgt, cfg_max_beats,
                              Bits(AXI_MAX_BEATS_W)(BEATS_64))

            # ---- burst length / unaligned offset ----
            b64 = (i_max_beats == Bits(2)(BEATS_64)).as_bits(1)
            brsv = (i_max_beats == Bits(2)(BEATS_RESERVED)).as_bits(1)
            b128 = (i_max_beats == Bits(2)(BEATS_128)).as_bits(1)
            b256 = (i_max_beats == Bits(2)(BEATS_256)).as_bits(1)

            # 64B arm
            burst64 = Bits(LEN_W)(64 >> AXI_DATA_W_BYTES_LG)
            off64 = ports.addr_i[AXI_DATA_W_BYTES_LG:clog2(64)]

            # 128B arm (also used by the 256B arm in the RTL)
            burst128 = Bits(LEN_W)(128 >> AXI_DATA_W_BYTES_LG)
            off128 = ports.addr_i[AXI_DATA_W_BYTES_LG:clog2(128)]

            burst_len = Mux(b64 | brsv, burst64,
                            Mux(b128 | b256, burst128, zero(LEN_W)))
            off = Mux(b64 | brsv, off64.pad_or_truncate(LEN_W),
                      Mux(b128 | b256, off128.pad_or_truncate(LEN_W),
                          zero(LEN_W)))

            aligned = (off == zero(LEN_W)).as_bits(1)
            unaligned_len = (burst_len - off).as_uint(LEN_W)

            rem_lo = ports.rem_len_i[0:LEN_W]   # rem_len_i[LEN_W-1:0]

            i_len = Mux(aligned,
                        _min(rem_lo, burst_len),
                        _min(rem_lo, unaligned_len))

            ports.calc_len_o = (i_len - Bits(LEN_W)(1)).as_uint(LEN_W)

    return StreamLen


def _min(a, b):
    return Mux((a < b).as_bits(1), a, b)


def make_stream_len_system(output_directory: str = None):
    top = make_stream_len()
    return System([top], name="stream_len",
                  output_directory=output_directory or "build/stream_len")
