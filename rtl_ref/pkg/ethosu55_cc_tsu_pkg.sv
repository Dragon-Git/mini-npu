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

package ethosu55_cc_tsu_pkg;
  import ethosu55_pkg::*;
  import ethosu55_cc_reg_pkg::*;

  localparam TSU_ADDR_W = 11;

  localparam TSU_DATA_W = 32 + 16;

  localparam TSU_OP_W      = 3;

  localparam NUM_STRIPE_BANKS = 2;
  localparam NUM_BLOCK_BANKS  = 4;

  localparam STRIPE_IDX_W = $clog2(NUM_STRIPE_BANKS);
  localparam BLK_IDX_W = $clog2(NUM_BLOCK_BANKS);

  typedef struct packed {
    logic [NUM_STRIPE_BANKS-1:0]    stripe_sel;
    logic [NUM_BLOCK_BANKS-1:0]     blk_sel;
  } blk_cmd_t;

  typedef struct packed {
    logic [NUM_STRIPE_BANKS-1:0]    stripe_sel;
  } ofd_cmd_t;

  typedef enum logic {
    AXI_RAM = 1'b0,
    SB_RAM  = 1'b1
  } mem2mem_ram_t;


  typedef logic [REGION_IDX_W-1:0] region_idx_t;
  typedef logic [REGION_IDX_W-1:0] core_t;


  typedef union packed {
    region_idx_t   region;
    core_t         core;
  } region_or_core_t;

  typedef struct packed {
    mem2mem_ram_t          ram;
    logic [7:REGION_IDX_W] unused;
    region_or_core_t       region_or_core;
  } m2m_dst_region_t;

  typedef logic [REGION_IDX_W-1:0] m2m_src_region_t;

  typedef struct packed {
    m2m_src_region_t               src_region;
    m2m_dst_region_t               dst_region;
    logic [AXI_ADDR_W-1:0]         src_offset;
    logic [AXI_ADDR_W-1:0]         dst_offset;
    logic [M2M_LENGTH_W-1:0]       length;
  } mem2mem_cmd_t;

endpackage: ethosu55_cc_tsu_pkg
