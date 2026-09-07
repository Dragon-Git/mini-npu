//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from Arm Limited or its affiliates.
//
//            (C) COPYRIGHT 2018-2020 Arm Limited or its affiliates.
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

module ethosu55_bin2onehot
  #(ONEHOT_W = 128, BIN_W = $clog2(ONEHOT_W), DIS_ASRT = 0)
(
  input wire                 asrt_clk,
  input wire                 asrt_rst_n,
  input wire [BIN_W-1:0]     bin_i,
  output wire [ONEHOT_W-1:0] vec_o
);

  for (genvar v = 0; v < ONEHOT_W; v = v + 1) begin: g_vec
    assign vec_o[v] = (bin_i == v[BIN_W-1:0]);
  end



endmodule
