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

module ethosu55_rr_arb #(parameter WIDTH = 6, parameter ALLOW_REQ_X = 1'b0) (
  input wire                                          asrt_clk,
  input wire                                          asrt_rst_n,
  input  wire [((WIDTH>1) ? $clog2(WIDTH) : 1) -1:0]  rr_counter_i,
  input  wire [WIDTH-1:0]                             requests_i,
  output wire [WIDTH-1:0]                             arb_o
);

  logic [WIDTH-1:0]    req_below_counter;
  logic [WIDTH*2-1:0]  req_long;
  logic [WIDTH*2-1:0]  req_long_lower_set;

  for (genvar i = 0; i < WIDTH; i = i + 1) begin : g_req_below
    assign req_below_counter[i] = i < rr_counter_i;
  end

  assign req_long = {requests_i & req_below_counter, requests_i & ~req_below_counter};

  assign req_long_lower_set[0] = 1'b0;

  for (genvar i = 1; i < 2*WIDTH; i = i + 1) begin : g_pri
    assign req_long_lower_set[i] = req_long[i-1] | req_long_lower_set[i-1];
  end

  assign arb_o = ((req_long[WIDTH-1:0] & ~req_long_lower_set[WIDTH-1:0]) |
                  (req_long[2*WIDTH-1:WIDTH] & ~req_long_lower_set[2*WIDTH-1:WIDTH]));



endmodule
