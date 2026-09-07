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




module ethosu55_cdc_syncn
  #(parameter
      LEVELS           = 2
  )
  (
    input  wire clk,
    input  wire reset_n,
    input  wire din_i,
    output wire dout_o
  );

  wire [LEVELS-1:0] d_int;

  ethosu55_cdc_sync_flop u_cdc_sync_flop_async
  (
    .clk     (clk),
    .reset_n   (reset_n),
    .din_i     (din_i),
    .dout_o    (d_int[0])
  );

  if (LEVELS>2)
    begin : g_levels_gt_2
      for (genvar i=0 ; i<LEVELS-2 ; i=i+1)
        begin : g_i
          ethosu55_cdc_sync_flop u_cdc_sync_flop_part
          (
            .clk     (clk),
            .reset_n   (reset_n),
            .din_i     (d_int[i]),
            .dout_o    (d_int[i+1])
          );
        end
    end

  ethosu55_cdc_sync_flop u_cdc_sync_flop_sync
  (
    .clk     (clk),
    .reset_n   (reset_n),
    .din_i     (d_int[LEVELS-2]),
    .dout_o    (d_int[LEVELS-1])
  );

  assign dout_o = d_int[LEVELS-1];

endmodule
