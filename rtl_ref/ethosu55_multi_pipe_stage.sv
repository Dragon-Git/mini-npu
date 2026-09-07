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

module ethosu55_multi_pipe_stage
#(
  parameter                                              WIDTH = 64,
  parameter                                              NUM_READERS = 2
)
(
  input  wire                                            clk,
  input  wire                                            reset_n,
  input  wire                                            in_valid_i,
  input  wire [WIDTH - 1:0]                              in_data_i,
  output wire                                            in_ready_o,
  output wire [NUM_READERS - 1:0]                        out_valid_o,
  output wire [WIDTH - 1:0]                              out_data_o,
  input  wire [NUM_READERS - 1:0]                        out_ready_i
);

  logic [NUM_READERS - 1:0]                   nxt_valid;
  logic [NUM_READERS - 1:0]                   s_valid;
  logic [NUM_READERS - 1:0]                   i_in_ready;
  logic [WIDTH - 1:0]                         nxt_data;
  logic [WIDTH - 1:0]                         s_data;

  assign nxt_data = in_data_i;

  for (genvar i = 0; i < NUM_READERS; i++) begin : gen_comb
    always_comb begin : p_ctrl
      if (in_valid_i && in_ready_o) begin
        nxt_valid[i] = '1;
      end else if (out_ready_i[i]) begin
        nxt_valid[i] = '0;
      end else begin
        nxt_valid[i] = s_valid[i];
      end

      i_in_ready[i] = !s_valid[i] || out_ready_i[i];
    end
  end

  always_ff @(posedge clk or negedge reset_n) begin : p_ff
    if (!reset_n) begin
      s_valid <= '0;
      s_data <= '0;
    end else begin
      s_valid <= nxt_valid;
      if (in_valid_i && in_ready_o) begin
        s_data <= nxt_data;
      end
    end
  end

  assign in_ready_o  = &i_in_ready;
  assign out_valid_o = s_valid;
  assign out_data_o  = s_data;



endmodule
