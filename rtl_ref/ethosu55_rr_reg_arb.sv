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

module ethosu55_rr_reg_arb
#(
  parameter WIDTH = 6,
  parameter ALLOW_REQ_X = 1'b0
)
(
  input  wire                         clk,
  input  wire                         reset_n,
  input  wire                         enable_i,
  input  wire [WIDTH-1:0]             requests_i,
  output wire [WIDTH-1:0]             arb_o
);

  localparam INCR = 1;
  localparam MAX = WIDTH - 1;
  localparam COUNT_W = ((WIDTH>1) ? $clog2(WIDTH) : 1);

  logic [COUNT_W-1:0] rr_counter;
  logic [COUNT_W-1:0] next_rr_counter;
  logic [WIDTH-1:0]   requests;

  assign requests =
    requests_i;

  assign next_rr_counter = ((rr_counter >= MAX[COUNT_W-1:0]) ? {COUNT_W{1'b0}} :
                                                               (rr_counter + INCR[COUNT_W-1:0]));


  always_ff @(posedge clk or negedge reset_n)
  if (!reset_n) begin
    rr_counter <= {COUNT_W{1'b0}};
  end else if (enable_i) begin
    rr_counter <= next_rr_counter;
  end


  ethosu55_rr_arb #(.WIDTH(WIDTH), .ALLOW_REQ_X(ALLOW_REQ_X)) u_arb (
    .asrt_clk     (clk),
    .asrt_rst_n   (reset_n),
    .rr_counter_i (rr_counter),
    .requests_i   (requests),
    .arb_o        (arb_o)
  );



endmodule
