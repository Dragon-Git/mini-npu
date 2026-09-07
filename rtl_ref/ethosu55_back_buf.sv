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

module ethosu55_back_buf
#(
  parameter                           DEPTH = 3,
  parameter                           WIDTH = 64
)
(
  input  wire                         clk,
  input  wire                         reset_n,
  input  wire                         in_valid_i,
  input  wire [WIDTH - 1:0]           in_data_i,
  output wire                         out_valid_o,
  output wire [WIDTH - 1:0]           out_data_o,
  input  wire                         out_ready_i
);

  typedef logic [WIDTH - 1:0] word_t;
  word_t                        s_regs[DEPTH-1:0];
  logic [DEPTH - 1:0]           i_clock_enable;
  logic                         i_fifo_get;
  logic                         i_fifo_put;
  logic                         i_fifo_empty;
  typedef logic [$clog2(DEPTH)-1:0] ptr_t;
  ptr_t                         s_in_ptr;
  ptr_t                         s_out_ptr;
  logic                         s_maybe_full;
  ptr_t                         nxt_in_ptr;
  ptr_t                         nxt_out_ptr;
  logic                         nxt_maybe_full;

  assign i_fifo_get = out_ready_i && !i_fifo_empty ? 1'b1 : 1'b0;
  assign i_fifo_put = (in_valid_i && !out_ready_i) || (in_valid_i && !i_fifo_empty) ? 1'b1 : 1'b0;
  assign i_fifo_empty = (s_in_ptr == s_out_ptr) ?  !s_maybe_full : 1'b0;
  assign out_data_o = i_fifo_empty ? in_data_i : s_regs[s_out_ptr];
  assign out_valid_o = !i_fifo_empty || in_valid_i;

  for (genvar i = 0; i <= DEPTH - 1; i = i + 1) begin : gen_reg
    assign i_clock_enable[i] = (i == s_in_ptr) ? i_fifo_put : 1'b0;

    always_ff @(posedge clk or negedge reset_n) begin : p_ff_regs
      if (!reset_n) begin
        s_regs[i] <=  '0;
      end else begin
        if (i_clock_enable[i]) begin
          s_regs[i] <= in_data_i;
        end
      end
    end
  end

  always_comb begin : p_ptr
    nxt_in_ptr     = s_in_ptr;
    nxt_out_ptr    = s_out_ptr;
    nxt_maybe_full = s_maybe_full;

    if (i_fifo_put) begin
      if (s_in_ptr == ptr_t'(DEPTH - 1)) begin
        nxt_in_ptr = '0;
      end
      else begin
        nxt_in_ptr = s_in_ptr + ptr_t'(1);
      end
      if (!i_fifo_get) begin
        nxt_maybe_full = '1;
      end
    end
    if (i_fifo_get) begin
      if (s_out_ptr == ptr_t'(DEPTH - 1)) begin
        nxt_out_ptr = '0;
      end
      else begin
        nxt_out_ptr = s_out_ptr + ptr_t'(1);
      end
      if (!i_fifo_put) begin
        nxt_maybe_full = '0;
      end
    end
  end

  always_ff @(posedge clk or negedge reset_n) begin : p_ff_ptr
    if (!reset_n) begin
      s_in_ptr     <= '0;
      s_out_ptr    <= '0;
      s_maybe_full <= '0;
    end else begin
      if (i_fifo_put) begin
        s_in_ptr <= nxt_in_ptr;
      end
      if (i_fifo_get) begin
        s_out_ptr <= nxt_out_ptr;
      end
      if (i_fifo_put || i_fifo_get) begin
        s_maybe_full <= nxt_maybe_full;
      end
    end
  end

endmodule
