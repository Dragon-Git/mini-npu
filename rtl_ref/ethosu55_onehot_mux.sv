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

module ethosu55_onehot_mux #(
  parameter integer N = 0,
  parameter type    T = logic [0:0],
  parameter         DIS_ASRT = 0
) (
  input  wire          asrt_clk,
  input  wire          asrt_rst_n,
  input  wire  [N-1:0] s_i,
  input  T             d_i [N-1:0],
  output T             m_o
);

  localparam WIDTH = $bits(T);

  logic [N-1:0] d_trans [WIDTH-1:0];
  logic [WIDTH-1:0] m_tmp;

  for (genvar i = 0; i < N; i = i + 1) begin: g_trans_outer
    logic [WIDTH-1:0] tmp_d;
    assign tmp_d = d_i[i];

    for (genvar j = 0; j < WIDTH; j = j + 1) begin: g_trans_inner
      assign d_trans[j][i] = tmp_d[j];
    end
  end

  for (genvar i = 0; i < WIDTH; i = i + 1) begin : g_mux
    assign m_tmp[i] = |(s_i & d_trans[i]);
  end

  assign m_o = T'(m_tmp);



endmodule
