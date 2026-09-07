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

module ethosu55_or_tree_w6 (
  input  wire [5:0] inputs_i,
  output wire       output_o
);

  wire [1:0][1:0] i_stage;

  ethosu55_cdc_or2
    u_or2_0_0 (
           .din0_i (inputs_i[0]),
           .din1_i (inputs_i[1]),
           .dout_o (i_stage[0][0])
           );
  ethosu55_cdc_or2
    u_or2_0_1 (
           .din0_i (inputs_i[2]),
           .din1_i (inputs_i[3]),
           .dout_o (i_stage[0][1])
           );
  ethosu55_cdc_or2
    u_or2_1_0 (
           .din0_i (inputs_i[4]),
           .din1_i (inputs_i[5]),
           .dout_o (i_stage[1][0])
           );
  ethosu55_cdc_or2
    u_or2_1_1 (
           .din0_i (i_stage[0][0]),
           .din1_i (i_stage[0][1]),
           .dout_o (i_stage[1][1])
           );
  ethosu55_cdc_or2
    u_or2_2_0 (
           .din0_i (i_stage[1][0]),
           .din1_i (i_stage[1][1]),
           .dout_o (output_o)
           );


endmodule
