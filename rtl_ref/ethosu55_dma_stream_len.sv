//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from Arm Limited or its affiliates.
//
//            (C) COPYRIGHT 2019-2020 Arm Limited or its affiliates.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from Arm Limited or its affiliates.
//
//            Release Information : ETHOSU55-ML004-r1p0-00eac0
//
//-----------------------------------------------------------------------------
// SystemVerilog (IEEE Std 1800-2012)
//-----------------------------------------------------------------------------

module ethosu55_dma_stream_len
  import ethosu55_pkg::*;
  import ethosu55_cc_reg_pkg::*;
  import ethosu55_dma_pkg::*;
(
  input  wire                  asrt_clk,
  input  wire                  asrt_rst_n,
  input  wire stream_type_t    stream_type_i,
  input  wire [AXI_ADDR_W-1:0] addr_i,
  input  wire len_words_t      rem_len_i,
  input  wire region_t         region_i,
  input  wire axi_config_t     axi_cfg_i,
  output wire axi_len_t        calc_len_o
);

  axi_max_beats_t    i_max_beats;
  axi_len_t          i_burst_len;
  axi_len_t          i_unaligned_burst_offset;
  logic              i_is_addr_aligned;
  axi_len_t          i_unaligned_len;
  axi_len_t          i_len;

  wire i_unused_ok = &{1'b0,
                       addr_i,
                       1'b0};

  always_comb begin
    i_max_beats = get_max_beats(stream_type_i, region_i, axi_cfg_i);

    case (i_max_beats)
      BEATS_64_BYTES,
      BEATS_RESERVED_0: begin
        i_burst_len = axi_len_t'(64 >> AXI_DATA_W_BYTES_LG);
        i_unaligned_burst_offset = axi_len_t'(addr_i[$clog2(64) - 1:AXI_DATA_W_BYTES_LG]);
      end
      BEATS_128_BYTES: begin
        i_burst_len = axi_len_t'(128 >> AXI_DATA_W_BYTES_LG);
        i_unaligned_burst_offset = axi_len_t'(addr_i[$clog2(128) - 1:AXI_DATA_W_BYTES_LG]);
      end
      BEATS_256_BYTES: begin
        i_burst_len = axi_len_t'(128 >> AXI_DATA_W_BYTES_LG);
        i_unaligned_burst_offset = axi_len_t'(addr_i[$clog2(128) - 1:AXI_DATA_W_BYTES_LG]);
      end

      default: begin
        i_burst_len = axi_len_t'('x);
        i_unaligned_burst_offset = axi_len_t'('x);
      end
    endcase

    i_is_addr_aligned = i_unaligned_burst_offset == axi_len_t'(0);

    i_unaligned_len = (i_burst_len - i_unaligned_burst_offset);

    i_len = !i_is_addr_aligned ?
      ((rem_len_i < i_unaligned_len) ? rem_len_i[$bits(axi_len_t)-1:0] : i_unaligned_len) :
      ((rem_len_i < i_burst_len) ? rem_len_i[$bits(axi_len_t)-1:0] : i_burst_len);
  end

  assign calc_len_o = axi_len_t'(i_len) - axi_len_t'(1);



endmodule
