# Equivalence target: rtl_ref/ethosu55_dma_stream_len.sv
#
#   module (
#     input  asrt_clk, asrt_rst_n,
#     input  stream_type_t  stream_type_i,   // 2 bits
#     input  [31:0]         addr_i,
#     input  len_words_t    rem_len_i,       // 29 bits
#     input  region_t       region_i,        // 2 bits
#     input  axi_config_t   axi_cfg_i,       // unpacked [3:0] x 22 bits
#     output axi_len_t      calc_len_o);     // 8 bits
#
#   get_max_beats: WGT -> axi_cfg[region].max_beats
#                  BAS/CMD/M2M -> BEATS_64_BYTES
#                  default     -> 'x     (gold x-prop makes this a don't care)
#   case (i_max_beats)
#     BEATS_64_BYTES, BEATS_RESERVED_0:
#         burst_len = 64>>3 = 8 ; offset = addr[5:3]
#     BEATS_128_BYTES, BEATS_256_BYTES:
#         burst_len = 128>>3 = 16 ; offset = addr[6:3]
#     default: 'x
#   aligned   = (offset == 0)
#   unal_len  = burst_len - offset
#   i_len     = !aligned ? (rem_len < unal_len ? rem_len[7:0] : unal_len)
#                        : (rem_len < burst_len ? rem_len[7:0] : burst_len)
#   calc_len_o = i_len - 1
#
# axi_cfg_i arrives packed as [87:0]: element r occupies [22r +: 22]; within
# an element (struct packed {u8 max_outst_wr; u8 max_outst_rd; u4 memtype;
# u2 max_beats;}) the first member is the MSB, so max_beats = elem[21:20].

from pycde import Input, Module, Output, System, generator
from pycde.constructs import Mux
from pycde.types import Bits

from .common import clog2, if_, u, zero

AXI_DATA_W = 64
AXI_ADDR_W = 32
AXI_LEN_W = 8
AXI_DATA_W_BYTES_LG = 3          # $clog2(64/8)
AXI_CFG_ELEM_W = 22              # 2 + 4 + 8 + 8
REGION_CNT = 4                   # axi_config_t = elem[3:0]
AXI_CFG_W = AXI_CFG_ELEM_W * REGION_CNT
STREAM_TYPE_W = 2
AXI_MAX_BEATS_W = 2
LEN_W = AXI_LEN_W
LEN_WORDS_W = AXI_ADDR_W - AXI_DATA_W_BYTES_LG   # 29
REGION_W = 2

WGT_STREAMER, BAS_STREAMER, CMD_STREAMER, M2M_STREAMER = 0, 1, 2, 3
BURST64 = 64 >> AXI_DATA_W_BYTES_LG      # 8
BURST128 = 128 >> AXI_DATA_W_BYTES_LG    # 16


def make_stream_len():

    class StreamLen(Module):
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
            elem = zero(AXI_CFG_ELEM_W)
            for r in range(REGION_CNT):
                elem = Mux((region == u(REGION_W, r)).as_bits(1),
                           ports.axi_cfg_i[r * AXI_CFG_ELEM_W:
                                           (r + 1) * AXI_CFG_ELEM_W],
                           elem)
            max_beats = elem[20:22]     # elem = {..., memtype[3:0], beats[1:0]}

            is_wgt = (st == u(STREAM_TYPE_W, WGT_STREAMER)).as_bits(1)
            beats_sel = Mux(is_wgt, max_beats, u(AXI_MAX_BEATS_W, 0))

            # ---- burst_len / offset select ----
            off64 = ports.addr_i[AXI_DATA_W_BYTES_LG:clog2(64)]     # [5:3]
            off128 = ports.addr_i[AXI_DATA_W_BYTES_LG:clog2(128)]   # [6:3]
            b64 = u(LEN_W, BURST64)
            b128 = u(LEN_W, BURST128)

            # beats == BEATS_64_BYTES(0) or BEATS_RESERVED_0(3) -> 64B arm;
            # BEATS_128_BYTES(1)/BEATS_256_BYTES(2) -> 128B arm
            use128 = ((beats_sel == u(AXI_MAX_BEATS_W, 1)).as_bits(1) |
                      (beats_sel == u(AXI_MAX_BEATS_W, 2)).as_bits(1))
            burst_len = if_(use128, b128, b64)
            off = Mux(use128, off128, off64)

            aligned = (off == u(LEN_W, 0)).as_bits(1)
            off_z = off.pad_or_truncate(LEN_W)
            unal_len = (burst_len.as_uint(LEN_W) -
                        off_z.as_uint(LEN_W)).as_uint(LEN_W)

            # rem_len compared against 8-bit values: zero-extend to 29 bits
            rem_z = ports.rem_len_i.as_uint(LEN_WORDS_W)
            unal_z = unal_len.pad_or_truncate(LEN_WORDS_W).as_uint(LEN_WORDS_W)
            burst_z = burst_len.pad_or_truncate(LEN_WORDS_W).as_uint(
                LEN_WORDS_W)
            rem_lt_unal = (rem_z < unal_z).as_bits(1)
            rem_lt_burst = (rem_z < burst_z).as_bits(1)
            rem8 = ports.rem_len_i[0:LEN_W]

            i_len = if_(~aligned,
                        if_(rem_lt_unal, rem8, unal_len),
                        if_(rem_lt_burst, rem8, burst_len))

            ports.calc_len_o = \
                (i_len.as_uint(LEN_W) - 1).as_uint(LEN_W)

    return StreamLen


def make_stream_len_system(output_directory: str | None = None):
    top = make_stream_len()
    return System([top], name="stream_len",
                  output_directory=output_directory or "build/stream_len")
