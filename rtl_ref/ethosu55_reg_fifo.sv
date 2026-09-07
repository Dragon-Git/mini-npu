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

module ethosu55_reg_fifo #(parameter FIFO_WIDTH = 32, parameter FIFO_DEPTH = 16, EN_COLLISION = 0, EN_DATA_X = 0)
(
  input  wire                         clk,
  input  wire                         reset_n,
  input  wire                         flush_i,
  input  wire                         in_valid_i,
  input  wire        [FIFO_WIDTH-1:0] in_data_i,
  output wire                         in_ready_o,
  output wire                         out_valid_o,
  output wire        [FIFO_WIDTH-1:0] out_data_o,
  input  wire                         out_ready_i,
  output wire  [$clog2(FIFO_DEPTH):0] data_cnt_o
);


  localparam LOG2_FIFO_DEPTH = $clog2(FIFO_DEPTH);

  logic                          fifo_write;
  logic                          fifo_read;
  logic                          fifo_empty;
  logic                          fifo_full;
  logic [LOG2_FIFO_DEPTH-1:0]    nxt_wr_ptr;
  logic [LOG2_FIFO_DEPTH-1:0]    wr_ptr;
  logic                          max_wr_ptr;
  logic [LOG2_FIFO_DEPTH-1:0]    nxt_rd_ptr;
  logic [LOG2_FIFO_DEPTH-1:0]    rd_ptr;
  logic                          max_rd_ptr;
  logic [LOG2_FIFO_DEPTH :0]     nxt_data_cnt;
  logic [LOG2_FIFO_DEPTH :0]     data_cnt;
  logic [FIFO_WIDTH-1:0]         memory [FIFO_DEPTH-1:0];

  logic [LOG2_FIFO_DEPTH-1:0]    zero_data_cnt;
  logic [31:0]                   max_data_cnt;
  logic                          wr_ptr_en;
  logic                          rd_ptr_en;
  logic                          data_cnt_en;
  logic                          memory_en [FIFO_DEPTH-1:0];

  if (EN_COLLISION == 1)
  begin : en_collision
    assign fifo_write  = in_valid_i  & (~fifo_full | out_ready_i);
    assign in_ready_o  = ~fifo_full | out_ready_i;
  end
  else
  begin : dis_collision
    assign fifo_write  = in_valid_i  & ~fifo_full;
    assign in_ready_o  = ~fifo_full;
  end
  assign fifo_read   = out_ready_i & ~fifo_empty;
  assign out_valid_o = ~fifo_empty;

  assign zero_data_cnt = '0;
  assign max_data_cnt  = FIFO_DEPTH[31:0];

  assign max_wr_ptr = wr_ptr == (max_data_cnt[LOG2_FIFO_DEPTH-1:0] - {{(LOG2_FIFO_DEPTH-1){1'b0}}, 1'b1});
  assign nxt_wr_ptr = flush_i                    ? '0 :
                      (fifo_write && max_wr_ptr) ? '0 :
                      fifo_write                 ? wr_ptr + {{(LOG2_FIFO_DEPTH-1){1'b0}}, 1'b1} :
                                                   wr_ptr;
  assign wr_ptr_en = (flush_i || fifo_write);

  always_ff @(posedge clk or negedge reset_n)
  if (!reset_n) begin
    wr_ptr <= '0;
  end else if (wr_ptr_en) begin
    wr_ptr <= nxt_wr_ptr;
  end

  assign max_rd_ptr = rd_ptr == (max_data_cnt[LOG2_FIFO_DEPTH-1:0] - {{(LOG2_FIFO_DEPTH-1){1'b0}}, 1'b1});

  assign nxt_rd_ptr = flush_i                   ? '0 :
                      (fifo_read && max_rd_ptr) ? '0 :
                      fifo_read                 ? rd_ptr + {{(LOG2_FIFO_DEPTH-1){1'b0}}, 1'b1} :
                                                  rd_ptr;
  assign rd_ptr_en = (flush_i || fifo_read);

  always_ff @(posedge clk or negedge reset_n)
  if (!reset_n) begin
    rd_ptr <= '0;
  end else if (rd_ptr_en) begin
    rd_ptr <= nxt_rd_ptr;
  end

  assign nxt_data_cnt = flush_i                                                                       ? '0 :
                        (fifo_read  && !fifo_write && (data_cnt != {1'b0, zero_data_cnt}))            ? data_cnt - {{(LOG2_FIFO_DEPTH){1'b0}}, 1'b1} :
                        (fifo_write && !fifo_read  && (data_cnt != max_data_cnt[LOG2_FIFO_DEPTH :0])) ? data_cnt + {{(LOG2_FIFO_DEPTH){1'b0}}, 1'b1} :
                                                                                                        data_cnt;
  assign data_cnt_en = flush_i | fifo_read | fifo_write;

  always_ff @(posedge clk or negedge reset_n)
  if (!reset_n) begin
    data_cnt <= '0;
  end else if (data_cnt_en) begin
    data_cnt <= nxt_data_cnt;
  end


  for (genvar i = 0; i < FIFO_DEPTH; i = i + 1) begin : p_memory_en
    assign memory_en[i] = fifo_write && (wr_ptr == i[LOG2_FIFO_DEPTH-1:0]);
  end

  for (genvar i = 0; i < FIFO_DEPTH; i = i + 1) begin : p_fifo
    always_ff @(posedge clk or negedge reset_n)
    if (!reset_n) begin
      memory[i] <= '0;
    end else if (memory_en[i]) begin
      memory[i] <= in_data_i;
    end
  end

  assign out_data_o = memory[rd_ptr];

  assign fifo_empty = (data_cnt == {1'b0, zero_data_cnt});
  assign fifo_full  = (data_cnt == max_data_cnt[LOG2_FIFO_DEPTH :0]);
  assign data_cnt_o = data_cnt;



  wire i_unused_ok = &{1'b0,
                       max_data_cnt[31:LOG2_FIFO_DEPTH+1],
                       1'b0};




endmodule
