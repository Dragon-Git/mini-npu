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


module ethosu55_cdc_sync_flop
  (
    input  wire clk,
    input  wire reset_n,
    input  wire din_i,
    output reg  dout_o
  );

  always_ff @(posedge clk or negedge reset_n)
    begin : ethosu55_cdc_sync_flop_cell
      if (!reset_n)
        dout_o <=  1'b0;
      else
        dout_o <=  din_i;
    end

endmodule
