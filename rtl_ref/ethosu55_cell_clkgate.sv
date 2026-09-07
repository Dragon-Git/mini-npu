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



module ethosu55_cell_clkgate (
  input  wire clk,
  input  wire clk_enable_i,
  input  wire clk_senable_i,
  output wire clk_gated_o
);

  wire clk_en;
  reg  clk_en_reg;

  assign clk_en = clk_enable_i | clk_senable_i;

  always_latch begin
    if (clk == 1'b0) begin
      clk_en_reg <= clk_en;
    end
  end

  assign clk_gated_o = clk & clk_en_reg;

endmodule
