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

package ethosu55_cc_reg_pkg;

  import ethosu55_pkg::*;
  import ethosu55_cc_cmd_parser_pkg::*;

  localparam PAGE_BASE          = 1'b0;
  localparam PAGE_PMU           = PAGE_BASE;
  localparam PAGE_BASE_POINTERS = PAGE_BASE;
  localparam PAGE_ID            = PAGE_BASE;
  localparam PAGE_TSU           = PAGE_BASE;
  localparam PAGE_TSU_DEBUG     = PAGE_BASE;
  localparam PAGE_DEBUG         = PAGE_BASE;
  localparam PAGE_NPU_MEM     = 1'b1;

  localparam FPGA_BUILD_GIT_HASH = 32'd0;

  localparam VERSION_MINOR  = 4'd0;
  localparam VERSION_STATUS = 4'd1;
  localparam PRODUCT_MAJOR  = 4'd4;
  localparam VERSION_MAJOR  = 4'd1;



  localparam ARCH_MAJOR_REV = 4'd1;
  localparam ARCH_MINOR_REV = 8'd0;
  localparam ARCH_PATCH_REV = 4'd6;


  typedef enum logic [15:0] {
    BASE_ID = 16'h0000,
    BASE_STATUS = 16'h0004,
    BASE_CMD = 16'h0008,
    BASE_RESET = 16'h000C,
    BASE_QBASE0 = 16'h0010,
    BASE_QBASE1 = 16'h0014,
    BASE_QREAD = 16'h0018,
    BASE_QCONFIG = 16'h001C,
    BASE_QSIZE = 16'h0020,
    BASE_PROT = 16'h0024,
    BASE_CONFIG = 16'h0028,
    BASE_LOCK = 16'h002C,
    BASE_REGIONCFG = 16'h003C,
    BASE_AXI_LIMIT0 = 16'h0040,
    BASE_AXI_LIMIT1 = 16'h0044,
    BASE_AXI_LIMIT2 = 16'h0048,
    BASE_AXI_LIMIT3 = 16'h004C,
    BASE_X = 16'hxxxx
  } base_addr_t;

  typedef enum logic [15:0] {
    BASE_POINTERS_BASEP0 = 16'h0080,
    BASE_POINTERS_BASEP1 = 16'h0084,
    BASE_POINTERS_BASEP2 = 16'h0088,
    BASE_POINTERS_BASEP3 = 16'h008C,
    BASE_POINTERS_BASEP4 = 16'h0090,
    BASE_POINTERS_BASEP5 = 16'h0094,
    BASE_POINTERS_BASEP6 = 16'h0098,
    BASE_POINTERS_BASEP7 = 16'h009C,
    BASE_POINTERS_BASEP8 = 16'h00A0,
    BASE_POINTERS_BASEP9 = 16'h00A4,
    BASE_POINTERS_BASEP10 = 16'h00A8,
    BASE_POINTERS_BASEP11 = 16'h00AC,
    BASE_POINTERS_BASEP12 = 16'h00B0,
    BASE_POINTERS_BASEP13 = 16'h00B4,
    BASE_POINTERS_BASEP14 = 16'h00B8,
    BASE_POINTERS_BASEP15 = 16'h00BC,
    BASE_POINTERS_X = 16'hxxxx
  } base_pointers_addr_t;

  typedef enum logic [15:0] {
    ID_REVISION = 16'h0FC0,
    ID_PID4 = 16'h0FD0,
    ID_PID5 = 16'h0FD4,
    ID_PID6 = 16'h0FD8,
    ID_PID7 = 16'h0FDC,
    ID_PID0 = 16'h0FE0,
    ID_PID1 = 16'h0FE4,
    ID_PID2 = 16'h0FE8,
    ID_PID3 = 16'h0FEC,
    ID_CID0 = 16'h0FF0,
    ID_CID1 = 16'h0FF4,
    ID_CID2 = 16'h0FF8,
    ID_CID3 = 16'h0FFC,
    ID_X = 16'hxxxx
  } id_addr_t;

  typedef enum logic [15:0] {
    DEBUG_WD_STATUS = 16'h0100,
    DEBUG_MAC_STATUS = 16'h0104,
    DEBUG_AO_STATUS = 16'h0108,
    DEBUG_DMA_STATUS0 = 16'h0110,
    DEBUG_DMA_STATUS1 = 16'h0114,
    DEBUG_CLKFORCE = 16'h0140,
    DEBUG_DEBUG_ADDRESS = 16'h0144,
    DEBUG_DEBUG_MISC = 16'h0148,
    DEBUG_DEBUGCORE = 16'h014C,
    DEBUG_DEBUG_BLOCK = 16'h0150,
    DEBUG_X = 16'hxxxx
  } debug_addr_t;

  typedef enum logic [15:0] {
    PMU_PMCR = 16'h0180,
    PMU_PMCNTENSET = 16'h0184,
    PMU_PMCNTENCLR = 16'h0188,
    PMU_PMOVSSET = 16'h018C,
    PMU_PMOVSCLR = 16'h0190,
    PMU_PMINTSET = 16'h0194,
    PMU_PMINTCLR = 16'h0198,
    PMU_PMCCNTR_LO = 16'h01A0,
    PMU_PMCCNTR_HI = 16'h01A4,
    PMU_PMCCNTR_CFG = 16'h01A8,
    PMU_PMCAXI_CHAN = 16'h01AC,
    PMU_PMEVCNTR0 = 16'h0300,
    PMU_PMEVCNTR1 = 16'h0304,
    PMU_PMEVCNTR2 = 16'h0308,
    PMU_PMEVCNTR3 = 16'h030C,
    PMU_PMEVTYPER0 = 16'h0380,
    PMU_PMEVTYPER1 = 16'h0384,
    PMU_PMEVTYPER2 = 16'h0388,
    PMU_PMEVTYPER3 = 16'h038C,
    PMU_X = 16'hxxxx
  } pmu_addr_t;

  typedef enum logic [15:0] {
    TSU_DEBUG_KERNEL_X = 16'h0200,
    TSU_DEBUG_KERNEL_Y = 16'h0204,
    TSU_DEBUG_KERNEL_W_M1 = 16'h0208,
    TSU_DEBUG_KERNEL_H_M1 = 16'h020C,
    TSU_DEBUG_OFM_CBLK_WIDTH_M1 = 16'h0210,
    TSU_DEBUG_OFM_CBLK_HEIGHT_M1 = 16'h0214,
    TSU_DEBUG_OFM_CBLK_DEPTH_M1 = 16'h0218,
    TSU_DEBUG_IFM_CBLK_DEPTH_M1 = 16'h021C,
    TSU_DEBUG_OFM_X = 16'h0220,
    TSU_DEBUG_OFM_Y = 16'h0224,
    TSU_DEBUG_OFM_Z = 16'h0228,
    TSU_DEBUG_IFM_Z = 16'h022C,
    TSU_DEBUG_PAD_TOP = 16'h0230,
    TSU_DEBUG_PAD_LEFT = 16'h0234,
    TSU_DEBUG_IFM_CBLK_WIDTH = 16'h0238,
    TSU_DEBUG_IFM_CBLK_HEIGHT = 16'h023C,
    TSU_DEBUG_DMA_IFM_SRC = 16'h0240,
    TSU_DEBUG_DMA_IFM_SRC_HI = 16'h0244,
    TSU_DEBUG_DMA_IFM_DST = 16'h0248,
    TSU_DEBUG_DMA_OFM_SRC = 16'h024C,
    TSU_DEBUG_DMA_OFM_DST = 16'h0250,
    TSU_DEBUG_DMA_OFM_DST_HI = 16'h0254,
    TSU_DEBUG_DMA_WEIGHT_SRC = 16'h0258,
    TSU_DEBUG_DMA_WEIGHT_SRC_HI = 16'h025C,
    TSU_DEBUG_DMA_CMD_SRC = 16'h0260,
    TSU_DEBUG_DMA_CMD_SRC_HI = 16'h0264,
    TSU_DEBUG_DMA_CMD_SIZE = 16'h0268,
    TSU_DEBUG_DMA_M2M_SRC = 16'h026C,
    TSU_DEBUG_DMA_M2M_SRC_HI = 16'h0270,
    TSU_DEBUG_DMA_M2M_DST = 16'h0274,
    TSU_DEBUG_DMA_M2M_DST_HI = 16'h0278,
    TSU_DEBUG_CURRENT_QREAD = 16'h027C,
    TSU_DEBUG_DMA_SCALE_SRC = 16'h0280,
    TSU_DEBUG_DMA_SCALE_SRC_HI = 16'h0284,
    TSU_DEBUG_CURRENT_BLOCK = 16'h02B4,
    TSU_DEBUG_CURRENT_OP = 16'h02B8,
    TSU_DEBUG_CURRENT_CMD = 16'h02BC,
    TSU_DEBUG_X = 16'hxxxx
  } tsu_debug_addr_t;

  typedef enum logic [15:0] {
    TSU_IFM_PAD_TOP = 16'h0800,
    TSU_IFM_PAD_LEFT = 16'h0804,
    TSU_IFM_PAD_RIGHT = 16'h0808,
    TSU_IFM_PAD_BOTTOM = 16'h080C,
    TSU_IFM_DEPTH_M1 = 16'h0810,
    TSU_IFM_PRECISION = 16'h0814,
    TSU_IFM_UPSCALE = 16'h081C,
    TSU_IFM_ZERO_POINT = 16'h0824,
    TSU_IFM_WIDTH0_M1 = 16'h0828,
    TSU_IFM_HEIGHT0_M1 = 16'h082C,
    TSU_IFM_HEIGHT1_M1 = 16'h0830,
    TSU_IFM_IB_END = 16'h0834,
    TSU_IFM_REGION = 16'h083C,
    TSU_OFM_WIDTH_M1 = 16'h0844,
    TSU_OFM_HEIGHT_M1 = 16'h0848,
    TSU_OFM_DEPTH_M1 = 16'h084C,
    TSU_OFM_PRECISION = 16'h0850,
    TSU_OFM_BLK_WIDTH_M1 = 16'h0854,
    TSU_OFM_BLK_HEIGHT_M1 = 16'h0858,
    TSU_OFM_BLK_DEPTH_M1 = 16'h085C,
    TSU_OFM_ZERO_POINT = 16'h0860,
    TSU_OFM_WIDTH0_M1 = 16'h0868,
    TSU_OFM_HEIGHT0_M1 = 16'h086C,
    TSU_OFM_HEIGHT1_M1 = 16'h0870,
    TSU_OFM_REGION = 16'h087C,
    TSU_KERNEL_WIDTH_M1 = 16'h0880,
    TSU_KERNEL_HEIGHT_M1 = 16'h0884,
    TSU_KERNEL_STRIDE = 16'h0888,
    TSU_PARALLEL_MODE = 16'h088C,
    TSU_ACC_FORMAT = 16'h0890,
    TSU_ACTIVATION = 16'h0894,
    TSU_ACTIVATION_MIN = 16'h0898,
    TSU_ACTIVATION_MAX = 16'h089C,
    TSU_WEIGHT_REGION = 16'h08A0,
    TSU_SCALE_REGION = 16'h08A4,
    TSU_AB_START = 16'h08B4,
    TSU_BLOCKDEP = 16'h08BC,
    TSU_DMA0_SRC_REGION = 16'h08C0,
    TSU_DMA0_DST_REGION = 16'h08C4,
    TSU_DMA0_SIZE0 = 16'h08C8,
    TSU_DMA0_SIZE1 = 16'h08CC,
    TSU_IFM2_BROADCAST = 16'h0900,
    TSU_IFM2_SCALAR = 16'h0904,
    TSU_IFM2_PRECISION = 16'h0914,
    TSU_IFM2_ZERO_POINT = 16'h0924,
    TSU_IFM2_WIDTH0_M1 = 16'h0928,
    TSU_IFM2_HEIGHT0_M1 = 16'h092C,
    TSU_IFM2_HEIGHT1_M1 = 16'h0930,
    TSU_IFM2_IB_START = 16'h0934,
    TSU_IFM2_REGION = 16'h093C,
    TSU_IFM_BASE0 = 16'h0A00,
    TSU_IFM_BASE0_HI = 16'h0A04,
    TSU_IFM_BASE1 = 16'h0A08,
    TSU_IFM_BASE1_HI = 16'h0A0C,
    TSU_IFM_BASE2 = 16'h0A10,
    TSU_IFM_BASE2_HI = 16'h0A14,
    TSU_IFM_BASE3 = 16'h0A18,
    TSU_IFM_BASE3_HI = 16'h0A1C,
    TSU_IFM_STRIDE_X = 16'h0A20,
    TSU_IFM_STRIDE_X_HI = 16'h0A24,
    TSU_IFM_STRIDE_Y = 16'h0A28,
    TSU_IFM_STRIDE_Y_HI = 16'h0A2C,
    TSU_IFM_STRIDE_C = 16'h0A30,
    TSU_IFM_STRIDE_C_HI = 16'h0A34,
    TSU_OFM_BASE0 = 16'h0A40,
    TSU_OFM_BASE0_HI = 16'h0A44,
    TSU_OFM_BASE1 = 16'h0A48,
    TSU_OFM_BASE1_HI = 16'h0A4C,
    TSU_OFM_BASE2 = 16'h0A50,
    TSU_OFM_BASE2_HI = 16'h0A54,
    TSU_OFM_BASE3 = 16'h0A58,
    TSU_OFM_BASE3_HI = 16'h0A5C,
    TSU_OFM_STRIDE_X = 16'h0A60,
    TSU_OFM_STRIDE_X_HI = 16'h0A64,
    TSU_OFM_STRIDE_Y = 16'h0A68,
    TSU_OFM_STRIDE_Y_HI = 16'h0A6C,
    TSU_OFM_STRIDE_C = 16'h0A70,
    TSU_OFM_STRIDE_C_HI = 16'h0A74,
    TSU_WEIGHT_BASE = 16'h0A80,
    TSU_WEIGHT_BASE_HI = 16'h0A84,
    TSU_WEIGHT_LENGTH = 16'h0A88,
    TSU_SCALE_BASE = 16'h0A90,
    TSU_SCALE_BASE_HI = 16'h0A94,
    TSU_SCALE_LENGTH = 16'h0A98,
    TSU_OFM_SCALE = 16'h0AA0,
    TSU_OFM_SCALE_SHIFT = 16'h0AA4,
    TSU_OPA_SCALE = 16'h0AA8,
    TSU_OPA_SCALE_SHIFT = 16'h0AAC,
    TSU_OPB_SCALE = 16'h0AB0,
    TSU_DMA0_SRC = 16'h0AC0,
    TSU_DMA0_SRC_HI = 16'h0AC4,
    TSU_DMA0_DST = 16'h0AC8,
    TSU_DMA0_DST_HI = 16'h0ACC,
    TSU_DMA0_LEN = 16'h0AD0,
    TSU_DMA0_LEN_HI = 16'h0AD4,
    TSU_DMA0_SKIP0 = 16'h0AD8,
    TSU_DMA0_SKIP0_HI = 16'h0ADC,
    TSU_DMA0_SKIP1 = 16'h0AE0,
    TSU_DMA0_SKIP1_HI = 16'h0AE4,
    TSU_IFM2_BASE0 = 16'h0B00,
    TSU_IFM2_BASE0_HI = 16'h0B04,
    TSU_IFM2_BASE1 = 16'h0B08,
    TSU_IFM2_BASE1_HI = 16'h0B0C,
    TSU_IFM2_BASE2 = 16'h0B10,
    TSU_IFM2_BASE2_HI = 16'h0B14,
    TSU_IFM2_BASE3 = 16'h0B18,
    TSU_IFM2_BASE3_HI = 16'h0B1C,
    TSU_IFM2_STRIDE_X = 16'h0B20,
    TSU_IFM2_STRIDE_X_HI = 16'h0B24,
    TSU_IFM2_STRIDE_Y = 16'h0B28,
    TSU_IFM2_STRIDE_Y_HI = 16'h0B2C,
    TSU_IFM2_STRIDE_C = 16'h0B30,
    TSU_IFM2_STRIDE_C_HI = 16'h0B34,
    TSU_WEIGHT1_BASE = 16'h0B40,
    TSU_WEIGHT1_BASE_HI = 16'h0B44,
    TSU_WEIGHT1_LENGTH = 16'h0B48,
    TSU_SCALE1_BASE = 16'h0B50,
    TSU_SCALE1_BASE_HI = 16'h0B54,
    TSU_SCALE1_LENGTH = 16'h0B58,
    TSU_X = 16'hxxxx
  } tsu_addr_t;




  typedef struct packed {
    logic [3:0] arch_major_rev;
    logic [7:0] arch_minor_rev;
    logic [3:0] arch_patch_rev;
    logic [3:0] product_major;
    logic [3:0] version_major;
    logic [3:0] version_minor;
    logic [3:0] version_status;
  } id_t;

  typedef struct packed {
    logic [15:0] irq_history_mask;
    logic [3:0] faulting_channel;
    logic       faulting_interface;
    logic       ecc_fault;
    logic       wd_fault;
    logic       pmu_irq_raised;
    logic       cmd_end_reached;
    logic       cmd_parse_err;
    logic       reset_status;
    logic       bus_status;
    logic       irq_raised;
    logic       state;
  } status_t;

  typedef struct packed {
    logic [15:0] clear_irq_history;
    logic       stop_request;
    logic       power_q_enable;
    logic       clock_q_enable;
    logic       clear_irq;
    logic       transition_to_running_state;
  } cmd_t;

  typedef struct packed {
    logic [15:0] clear_irq_history;
    logic       stop_request;
    logic       power_q_enable;
    logic       clock_q_enable;
    logic       clear_irq;
    logic       transition_to_running_state;
  } cmd_reg_t;

  typedef struct packed {
    logic       pending_csl;
    logic       pending_cpl;
  } reset_t;

  typedef struct packed {
    logic       pending_csl;
    logic       pending_cpl;
  } reset_reg_t;

  typedef logic [31:0] qbase0_t;

  typedef logic [31:0] qbase1_t;

  typedef logic [31:0] qread_t;

  typedef logic [31:0] qconfig_t;

  typedef logic [31:0] qsize_t;

  typedef struct packed {
    logic       active_csl;
    logic       active_cpl;
  } prot_t;

  typedef struct packed {
    logic [3:0] product;
    logic [7:0] shram_size;
    logic [3:0] cmd_stream_version;
    logic [3:0] macs_per_cc;
  } config_t;

  typedef logic [31:0] lock_t;

  typedef struct packed {
    logic [1:0] region7;
    logic [1:0] region6;
    logic [1:0] region5;
    logic [1:0] region4;
    logic [1:0] region3;
    logic [1:0] region2;
    logic [1:0] region1;
    logic [1:0] region0;
  } regioncfg_t;

  typedef struct packed {
    logic [1:0] region7;
    logic [1:0] region6;
    logic [1:0] region5;
    logic [1:0] region4;
    logic [1:0] region3;
    logic [1:0] region2;
    logic [1:0] region1;
    logic [1:0] region0;
  } regioncfg_reg_t;

  typedef struct packed {
    logic [7:0] max_outstanding_write_m1;
    logic [7:0] max_outstanding_read_m1;
    logic [3:0] memtype;
    logic [1:0] max_beats;
  } axi_limit0_t;

  typedef struct packed {
    logic [7:0] max_outstanding_write_m1;
    logic [7:0] max_outstanding_read_m1;
    logic [3:0] memtype;
    logic [1:0] max_beats;
  } axi_limit0_reg_t;

  typedef struct packed {
    logic [7:0] max_outstanding_write_m1;
    logic [7:0] max_outstanding_read_m1;
    logic [3:0] memtype;
    logic [1:0] max_beats;
  } axi_limit1_t;

  typedef struct packed {
    logic [7:0] max_outstanding_write_m1;
    logic [7:0] max_outstanding_read_m1;
    logic [3:0] memtype;
    logic [1:0] max_beats;
  } axi_limit1_reg_t;

  typedef struct packed {
    logic [7:0] max_outstanding_write_m1;
    logic [7:0] max_outstanding_read_m1;
    logic [3:0] memtype;
    logic [1:0] max_beats;
  } axi_limit2_t;

  typedef struct packed {
    logic [7:0] max_outstanding_write_m1;
    logic [7:0] max_outstanding_read_m1;
    logic [3:0] memtype;
    logic [1:0] max_beats;
  } axi_limit2_reg_t;

  typedef struct packed {
    logic [7:0] max_outstanding_write_m1;
    logic [7:0] max_outstanding_read_m1;
    logic [3:0] memtype;
    logic [1:0] max_beats;
  } axi_limit3_t;

  typedef struct packed {
    logic [7:0] max_outstanding_write_m1;
    logic [7:0] max_outstanding_read_m1;
    logic [3:0] memtype;
    logic [1:0] max_beats;
  } axi_limit3_reg_t;



  typedef logic [31:0] basep0_t;

  typedef logic [31:0] basep1_t;

  typedef logic [31:0] basep2_t;

  typedef logic [31:0] basep3_t;

  typedef logic [31:0] basep4_t;

  typedef logic [31:0] basep5_t;

  typedef logic [31:0] basep6_t;

  typedef logic [31:0] basep7_t;

  typedef logic [31:0] basep8_t;

  typedef logic [31:0] basep9_t;

  typedef logic [31:0] basep10_t;

  typedef logic [31:0] basep11_t;

  typedef logic [31:0] basep12_t;

  typedef logic [31:0] basep13_t;

  typedef logic [31:0] basep14_t;

  typedef logic [31:0] basep15_t;



  typedef logic [31:0] revision_t;

  typedef logic [31:0] pid4_t;

  typedef logic [31:0] pid5_t;

  typedef logic [31:0] pid6_t;

  typedef logic [31:0] pid7_t;

  typedef logic [31:0] pid0_t;

  typedef logic [31:0] pid1_t;

  typedef logic [31:0] pid2_t;

  typedef logic [31:0] pid3_t;

  typedef logic [31:0] cid0_t;

  typedef logic [31:0] cid1_t;

  typedef logic [31:0] cid2_t;

  typedef logic [31:0] cid3_t;



  typedef struct packed {
    logic [11:0] events;
    logic       write_buf_idle1;
    logic       write_buf_valid1;
    logic [2:0] write_buf_index1;
    logic       write_buf_idle0;
    logic       write_buf_valid0;
    logic [2:0] write_buf_index0;
    logic       ctrl_idle;
    logic [1:0] ctrl_state;
    logic       core_idle;
    logic [1:0] core_slice_state;
  } wd_status_t;

  typedef struct packed {
    logic [10:0] events;
    logic       acc1_valid;
    logic       acc0_valid;
    logic       acc_buf_sel_aa;
    logic       wait_for_acc1_ready;
    logic       wait_for_acc0_ready;
    logic       acc_buf_sel_ai;
    logic       wait_for_dw1_ready;
    logic       wait_for_dw0_ready;
    logic       dw_sel;
    logic       stall_stripe;
    logic       wait_for_weights;
    logic       wait_for_acc_buf;
    logic       wait_for_ib;
    logic       trav_en;
    logic       block_cfg_valid;
  } mac_status_t;

  typedef struct packed {
    logic [7:0] events;
    logic       blk_cmd_valid;
    logic       blk_cmd_ready;
    logic       cmd_ofm_valid;
    logic       cmd_sbr_valid;
    logic       cmd_scl_valid;
    logic       cmd_ctl_valid;
    logic       cmd_act_valid;
    logic       cmd_sbw_valid;
  } ao_status_t;

  typedef struct packed {
    logic       axi0_w_stalled;
    logic       axi0_aw_stalled;
    logic       axi0_rd_limit_stall;
    logic       axi0_ar_stalled;
    logic       bs_bitstream_ready_c0;
    logic       bs_bitstream_valid_c0;
    logic       wd_bitstream_ready_c0;
    logic       wd_bitstream_valid_c0;
    logic       cmd_ready;
    logic       cmd_valid;
    logic       ob1_ready_c0;
    logic       ob1_valid_c0;
    logic       ob0_ready_c0;
    logic       ob0_valid_c0;
    logic       ib1_ao_ready_c0;
    logic       ib1_ao_valid_c0;
    logic       ib0_ao_ready_c0;
    logic       ib0_ao_valid_c0;
    logic       ib1_ai_ready_c0;
    logic       ib1_ai_valid_c0;
    logic       ib0_ai_ready_c0;
    logic       ib0_ai_valid_c0;
    logic       pause_ack;
    logic       pause_req;
    logic       halt_ack;
    logic       halt_req;
    logic       ofm_idle;
    logic       m2m_idle;
    logic       bas_idle_c0;
    logic       wgt_idle_c0;
    logic       ifm_idle;
    logic       cmd_idle;
  } dma_status0_t;

  typedef struct packed {
    logic       bs_bitstream_ready_c1;
    logic       bs_bitstream_valid_c1;
    logic       wd_bitstream_ready_c1;
    logic       wd_bitstream_valid_c1;
    logic       ob1_ready_c1;
    logic       ob1_valid_c1;
    logic       ob0_ready_c1;
    logic       ob0_valid_c1;
    logic       ib1_ao_ready_c1;
    logic       ib1_ao_valid_c1;
    logic       ib0_ao_ready_c1;
    logic       ib0_ao_valid_c1;
    logic       ib1_ai_ready_c1;
    logic       ib1_ai_valid_c1;
    logic       ib0_ai_ready_c1;
    logic       ib0_ai_valid_c1;
    logic       bas_idle_c1;
    logic       wgt_idle_c1;
    logic       axi1_wr_limit_stall;
    logic       axi1_w_stalled;
    logic       axi1_wr_stalled;
    logic       axi1_rd_limit_stall;
    logic       axi1_ar_stalled;
    logic       axi0_wr_limit_stall;
  } dma_status1_t;

  typedef struct packed {
    logic       wd_clk;
    logic       ao_clk;
    logic       mac_clk;
    logic       dma_clk;
    logic       cc_clk;
    logic       top_level_clk;
  } clkforce_t;

  typedef struct packed {
    logic       wd_clk;
    logic       ao_clk;
    logic       mac_clk;
    logic       dma_clk;
    logic       cc_clk;
    logic       top_level_clk;
  } clkforce_reg_t;

  typedef logic [31:0] debug_address_t;

  typedef logic [31:0] debug_misc_t;

  typedef logic [31:0] debugcore_t;

  typedef logic [31:0] debug_block_t;



  typedef struct packed {
    logic [4:0] num_event_cnt;
    logic       mask_en;
    logic       cycle_cnt_rst;
    logic       event_cnt_rst;
    logic       cnt_en;
  } pmcr_t;

  typedef struct packed {
    logic       mask_en;
    logic       cycle_cnt_rst;
    logic       event_cnt_rst;
    logic       cnt_en;
  } pmcr_reg_t;

  typedef struct packed {
    logic       cycle_cnt;
    logic       event_cnt_3;
    logic       event_cnt_2;
    logic       event_cnt_1;
    logic       event_cnt_0;
  } pmcntenset_t;

  typedef struct packed {
    logic       cycle_cnt;
    logic       event_cnt_3;
    logic       event_cnt_2;
    logic       event_cnt_1;
    logic       event_cnt_0;
  } pmcntenset_reg_t;

  typedef struct packed {
    logic       cycle_cnt;
    logic       event_cnt_3;
    logic       event_cnt_2;
    logic       event_cnt_1;
    logic       event_cnt_0;
  } pmcntenclr_t;

  typedef struct packed {
    logic       cycle_cnt;
    logic       event_cnt_3;
    logic       event_cnt_2;
    logic       event_cnt_1;
    logic       event_cnt_0;
  } pmcntenclr_reg_t;

  typedef struct packed {
    logic       cycle_cnt_ovf;
    logic       event_cnt_3_ovf;
    logic       event_cnt_2_ovf;
    logic       event_cnt_1_ovf;
    logic       event_cnt_0_ovf;
  } pmovsset_t;

  typedef struct packed {
    logic       cycle_cnt_ovf;
    logic       event_cnt_3_ovf;
    logic       event_cnt_2_ovf;
    logic       event_cnt_1_ovf;
    logic       event_cnt_0_ovf;
  } pmovsset_reg_t;

  typedef struct packed {
    logic       cycle_cnt_ovf;
    logic       event_cnt_3_ovf;
    logic       event_cnt_2_ovf;
    logic       event_cnt_1_ovf;
    logic       event_cnt_0_ovf;
  } pmovsclr_t;

  typedef struct packed {
    logic       cycle_cnt_ovf;
    logic       event_cnt_3_ovf;
    logic       event_cnt_2_ovf;
    logic       event_cnt_1_ovf;
    logic       event_cnt_0_ovf;
  } pmovsclr_reg_t;

  typedef struct packed {
    logic       cycle_cnt_int;
    logic       event_cnt_3_int;
    logic       event_cnt_2_int;
    logic       event_cnt_1_int;
    logic       event_cnt_0_int;
  } pmintset_t;

  typedef struct packed {
    logic       cycle_cnt_int;
    logic       event_cnt_3_int;
    logic       event_cnt_2_int;
    logic       event_cnt_1_int;
    logic       event_cnt_0_int;
  } pmintset_reg_t;

  typedef struct packed {
    logic       cycle_cnt_int;
    logic       event_cnt_3_int;
    logic       event_cnt_2_int;
    logic       event_cnt_1_int;
    logic       event_cnt_0_int;
  } pmintclr_t;

  typedef struct packed {
    logic       cycle_cnt_int;
    logic       event_cnt_3_int;
    logic       event_cnt_2_int;
    logic       event_cnt_1_int;
    logic       event_cnt_0_int;
  } pmintclr_reg_t;

  typedef logic [31:0] pmccntr_lo_t;

  typedef struct packed {
    logic [15:0] cycle_cnt_hi;
  } pmccntr_hi_t;

  typedef struct packed {
    logic [15:0] cycle_cnt_hi;
  } pmccntr_hi_reg_t;

  typedef struct packed {
    logic [9:0] cycle_cnt_cfg_stop;
    logic [9:0] cycle_cnt_cfg_start;
  } pmccntr_cfg_t;

  typedef struct packed {
    logic [9:0] cycle_cnt_cfg_stop;
    logic [9:0] cycle_cnt_cfg_start;
  } pmccntr_cfg_reg_t;

  typedef struct packed {
    logic       bw_ch_sel_en;
    logic [1:0] axi_cnt_sel;
    logic [3:0] ch_sel;
  } pmcaxi_chan_t;

  typedef struct packed {
    logic       bw_ch_sel_en;
    logic [1:0] axi_cnt_sel;
    logic [3:0] ch_sel;
  } pmcaxi_chan_reg_t;

  typedef logic [31:0] pmevcntr0_t;

  typedef logic [31:0] pmevcntr1_t;

  typedef logic [31:0] pmevcntr2_t;

  typedef logic [31:0] pmevcntr3_t;

  typedef struct packed {
    logic [9:0] ev_type;
  } pmevtyper0_t;

  typedef struct packed {
    logic [9:0] ev_type;
  } pmevtyper0_reg_t;

  typedef struct packed {
    logic [9:0] ev_type;
  } pmevtyper1_t;

  typedef struct packed {
    logic [9:0] ev_type;
  } pmevtyper1_reg_t;

  typedef struct packed {
    logic [9:0] ev_type;
  } pmevtyper2_t;

  typedef struct packed {
    logic [9:0] ev_type;
  } pmevtyper2_reg_t;

  typedef struct packed {
    logic [9:0] ev_type;
  } pmevtyper3_t;

  typedef struct packed {
    logic [9:0] ev_type;
  } pmevtyper3_reg_t;



  typedef logic [31:0] kernel_x_t;

  typedef logic [31:0] kernel_y_t;

  typedef logic [31:0] kernel_w_m1_t;

  typedef logic [31:0] kernel_h_m1_t;

  typedef logic [31:0] ofm_cblk_width_m1_t;

  typedef logic [31:0] ofm_cblk_height_m1_t;

  typedef logic [31:0] ofm_cblk_depth_m1_t;

  typedef logic [31:0] ifm_cblk_depth_m1_t;

  typedef logic [31:0] ofm_x_t;

  typedef logic [31:0] ofm_y_t;

  typedef logic [31:0] ofm_z_t;

  typedef logic [31:0] ifm_z_t;

  typedef logic [31:0] pad_top_t;

  typedef logic [31:0] pad_left_t;

  typedef logic [31:0] ifm_cblk_width_t;

  typedef logic [31:0] ifm_cblk_height_t;

  typedef logic [31:0] dma_ifm_src_t;

  typedef logic [31:0] dma_ifm_src_hi_t;

  typedef logic [31:0] dma_ifm_dst_t;

  typedef logic [31:0] dma_ofm_src_t;

  typedef logic [31:0] dma_ofm_dst_t;

  typedef logic [31:0] dma_ofm_dst_hi_t;

  typedef logic [31:0] dma_weight_src_t;

  typedef logic [31:0] dma_weight_src_hi_t;

  typedef logic [31:0] dma_cmd_src_t;

  typedef logic [31:0] dma_cmd_src_hi_t;

  typedef logic [31:0] dma_cmd_size_t;

  typedef logic [31:0] dma_m2m_src_t;

  typedef logic [31:0] dma_m2m_src_hi_t;

  typedef logic [31:0] dma_m2m_dst_t;

  typedef logic [31:0] dma_m2m_dst_hi_t;

  typedef logic [31:0] current_qread_t;

  typedef logic [31:0] dma_scale_src_t;

  typedef logic [31:0] dma_scale_src_hi_t;

  typedef logic [31:0] current_block_t;

  typedef logic [31:0] current_op_t;

  typedef logic [31:0] current_cmd_t;



  typedef logic [31:0] ifm_pad_top_t;

  typedef logic [31:0] ifm_pad_left_t;

  typedef logic [31:0] ifm_pad_right_t;

  typedef logic [31:0] ifm_pad_bottom_t;

  typedef logic [31:0] ifm_depth_m1_t;

  typedef logic [31:0] ifm_upscale_t;

  typedef logic [31:0] ifm_zero_point_t;

  typedef logic [31:0] ifm_width0_m1_t;

  typedef logic [31:0] ifm_height0_m1_t;

  typedef logic [31:0] ifm_height1_m1_t;

  typedef logic [31:0] ifm_ib_end_t;

  typedef logic [31:0] ifm_region_t;

  typedef logic [31:0] ofm_width_m1_t;

  typedef logic [31:0] ofm_height_m1_t;

  typedef logic [31:0] ofm_depth_m1_t;

  typedef logic [31:0] ofm_blk_width_m1_t;

  typedef logic [31:0] ofm_blk_height_m1_t;

  typedef logic [31:0] ofm_blk_depth_m1_t;

  typedef logic [31:0] ofm_zero_point_t;

  typedef logic [31:0] ofm_width0_m1_t;

  typedef logic [31:0] ofm_height0_m1_t;

  typedef logic [31:0] ofm_height1_m1_t;

  typedef logic [31:0] ofm_region_t;

  typedef logic [31:0] kernel_width_m1_t;

  typedef logic [31:0] kernel_height_m1_t;

  typedef logic [31:0] kernel_stride_t;

  typedef logic [31:0] parallel_mode_t;

  typedef logic [31:0] activation_min_t;

  typedef logic [31:0] activation_max_t;

  typedef logic [31:0] weight_region_t;

  typedef logic [31:0] scale_region_t;

  typedef logic [31:0] ab_start_t;

  typedef logic [31:0] blockdep_t;

  typedef logic [31:0] dma0_src_region_t;

  typedef logic [31:0] dma0_dst_region_t;

  typedef logic [31:0] dma0_size0_t;

  typedef logic [31:0] dma0_size1_t;

  typedef logic [31:0] ifm2_broadcast_t;

  typedef logic [31:0] ifm2_scalar_t;

  typedef logic [31:0] ifm2_precision_t;

  typedef logic [31:0] ifm2_zero_point_t;

  typedef logic [31:0] ifm2_width0_m1_t;

  typedef logic [31:0] ifm2_height0_m1_t;

  typedef logic [31:0] ifm2_height1_m1_t;

  typedef logic [31:0] ifm2_ib_start_t;

  typedef logic [31:0] ifm2_region_t;

  typedef logic [31:0] ifm_base0_t;

  typedef logic [31:0] ifm_base0_hi_t;

  typedef logic [31:0] ifm_base1_t;

  typedef logic [31:0] ifm_base1_hi_t;

  typedef logic [31:0] ifm_base2_t;

  typedef logic [31:0] ifm_base2_hi_t;

  typedef logic [31:0] ifm_base3_t;

  typedef logic [31:0] ifm_base3_hi_t;

  typedef logic [31:0] ifm_stride_x_t;

  typedef logic [31:0] ifm_stride_x_hi_t;

  typedef logic [31:0] ifm_stride_y_t;

  typedef logic [31:0] ifm_stride_y_hi_t;

  typedef logic [31:0] ifm_stride_c_t;

  typedef logic [31:0] ifm_stride_c_hi_t;

  typedef logic [31:0] ofm_base0_t;

  typedef logic [31:0] ofm_base0_hi_t;

  typedef logic [31:0] ofm_base1_t;

  typedef logic [31:0] ofm_base1_hi_t;

  typedef logic [31:0] ofm_base2_t;

  typedef logic [31:0] ofm_base2_hi_t;

  typedef logic [31:0] ofm_base3_t;

  typedef logic [31:0] ofm_base3_hi_t;

  typedef logic [31:0] ofm_stride_x_t;

  typedef logic [31:0] ofm_stride_x_hi_t;

  typedef logic [31:0] ofm_stride_y_t;

  typedef logic [31:0] ofm_stride_y_hi_t;

  typedef logic [31:0] ofm_stride_c_t;

  typedef logic [31:0] ofm_stride_c_hi_t;

  typedef logic [31:0] weight_base_t;

  typedef logic [31:0] weight_base_hi_t;

  typedef logic [31:0] weight_length_t;

  typedef logic [31:0] scale_base_t;

  typedef logic [31:0] scale_base_hi_t;

  typedef logic [31:0] scale_length_t;

  typedef logic [31:0] ofm_scale_t;

  typedef logic [31:0] ofm_scale_shift_t;

  typedef logic [31:0] opa_scale_t;

  typedef logic [31:0] opa_scale_shift_t;

  typedef logic [31:0] opb_scale_t;

  typedef logic [31:0] dma0_src_t;

  typedef logic [31:0] dma0_src_hi_t;

  typedef logic [31:0] dma0_dst_t;

  typedef logic [31:0] dma0_dst_hi_t;

  typedef logic [31:0] dma0_len_t;

  typedef logic [31:0] dma0_len_hi_t;

  typedef logic [31:0] dma0_skip0_t;

  typedef logic [31:0] dma0_skip0_hi_t;

  typedef logic [31:0] dma0_skip1_t;

  typedef logic [31:0] dma0_skip1_hi_t;

  typedef logic [31:0] ifm2_base0_t;

  typedef logic [31:0] ifm2_base0_hi_t;

  typedef logic [31:0] ifm2_base1_t;

  typedef logic [31:0] ifm2_base1_hi_t;

  typedef logic [31:0] ifm2_base2_t;

  typedef logic [31:0] ifm2_base2_hi_t;

  typedef logic [31:0] ifm2_base3_t;

  typedef logic [31:0] ifm2_base3_hi_t;

  typedef logic [31:0] ifm2_stride_x_t;

  typedef logic [31:0] ifm2_stride_x_hi_t;

  typedef logic [31:0] ifm2_stride_y_t;

  typedef logic [31:0] ifm2_stride_y_hi_t;

  typedef logic [31:0] ifm2_stride_c_t;

  typedef logic [31:0] ifm2_stride_c_hi_t;

  typedef logic [31:0] weight1_base_t;

  typedef logic [31:0] weight1_base_hi_t;

  typedef logic [31:0] weight1_length_t;

  typedef logic [31:0] scale1_base_t;

  typedef logic [31:0] scale1_base_hi_t;

  typedef logic [31:0] scale1_length_t;





  typedef struct packed {
    logic [3:0] arch_major_rev;
    logic [7:0] arch_minor_rev;
    logic [3:0] arch_patch_rev;
    logic [3:0] product_major;
    logic [3:0] version_major;
    logic [3:0] version_minor;
    logic [3:0] version_status;
  } id_word_t;

  typedef struct packed {
    logic [15:0] irq_history_mask;
    logic [3:0] faulting_channel;
    logic       faulting_interface;
    logic [1:0] reserved0;
    logic       ecc_fault;
    logic       wd_fault;
    logic       pmu_irq_raised;
    logic       cmd_end_reached;
    logic       cmd_parse_err;
    logic       reset_status;
    logic       bus_status;
    logic       irq_raised;
    logic       state;
  } status_word_t;

  typedef struct packed {
    logic [15:0] clear_irq_history;
    logic [10:0] reserved0;
    logic       stop_request;
    logic       power_q_enable;
    logic       clock_q_enable;
    logic       clear_irq;
    logic       transition_to_running_state;
  } cmd_word_t;

  typedef struct packed {
    logic [29:0] reserved0;
    logic       pending_csl;
    logic       pending_cpl;
  } reset_word_t;

  typedef logic [31:0] qbase0_word_t;

  typedef logic [31:0] qbase1_word_t;

  typedef logic [31:0] qread_word_t;

  typedef logic [31:0] qconfig_word_t;

  typedef logic [31:0] qsize_word_t;

  typedef struct packed {
    logic [29:0] reserved0;
    logic       active_csl;
    logic       active_cpl;
  } prot_word_t;

  typedef struct packed {
    logic [3:0] product;
    logic [11:0] reserved0;
    logic [7:0] shram_size;
    logic [3:0] cmd_stream_version;
    logic [3:0] macs_per_cc;
  } config_word_t;

  typedef logic [31:0] lock_word_t;

  typedef struct packed {
    logic [15:0] reserved0;
    logic [1:0] region7;
    logic [1:0] region6;
    logic [1:0] region5;
    logic [1:0] region4;
    logic [1:0] region3;
    logic [1:0] region2;
    logic [1:0] region1;
    logic [1:0] region0;
  } regioncfg_word_t;

  typedef struct packed {
    logic [7:0] max_outstanding_write_m1;
    logic [7:0] max_outstanding_read_m1;
    logic [7:0] reserved1;
    logic [3:0] memtype;
    logic [1:0] reserved0;
    logic [1:0] max_beats;
  } axi_limit0_word_t;

  typedef struct packed {
    logic [7:0] max_outstanding_write_m1;
    logic [7:0] max_outstanding_read_m1;
    logic [7:0] reserved1;
    logic [3:0] memtype;
    logic [1:0] reserved0;
    logic [1:0] max_beats;
  } axi_limit1_word_t;

  typedef struct packed {
    logic [7:0] max_outstanding_write_m1;
    logic [7:0] max_outstanding_read_m1;
    logic [7:0] reserved1;
    logic [3:0] memtype;
    logic [1:0] reserved0;
    logic [1:0] max_beats;
  } axi_limit2_word_t;

  typedef struct packed {
    logic [7:0] max_outstanding_write_m1;
    logic [7:0] max_outstanding_read_m1;
    logic [7:0] reserved1;
    logic [3:0] memtype;
    logic [1:0] reserved0;
    logic [1:0] max_beats;
  } axi_limit3_word_t;



  typedef logic [31:0] basep0_word_t;

  typedef logic [31:0] basep1_word_t;

  typedef logic [31:0] basep2_word_t;

  typedef logic [31:0] basep3_word_t;

  typedef logic [31:0] basep4_word_t;

  typedef logic [31:0] basep5_word_t;

  typedef logic [31:0] basep6_word_t;

  typedef logic [31:0] basep7_word_t;

  typedef logic [31:0] basep8_word_t;

  typedef logic [31:0] basep9_word_t;

  typedef logic [31:0] basep10_word_t;

  typedef logic [31:0] basep11_word_t;

  typedef logic [31:0] basep12_word_t;

  typedef logic [31:0] basep13_word_t;

  typedef logic [31:0] basep14_word_t;

  typedef logic [31:0] basep15_word_t;



  typedef logic [31:0] revision_word_t;

  typedef logic [31:0] pid4_word_t;

  typedef logic [31:0] pid5_word_t;

  typedef logic [31:0] pid6_word_t;

  typedef logic [31:0] pid7_word_t;

  typedef logic [31:0] pid0_word_t;

  typedef logic [31:0] pid1_word_t;

  typedef logic [31:0] pid2_word_t;

  typedef logic [31:0] pid3_word_t;

  typedef logic [31:0] cid0_word_t;

  typedef logic [31:0] cid1_word_t;

  typedef logic [31:0] cid2_word_t;

  typedef logic [31:0] cid3_word_t;



  typedef struct packed {
    logic [3:0] reserved0;
    logic [11:0] events;
    logic       write_buf_idle1;
    logic       write_buf_valid1;
    logic [2:0] write_buf_index1;
    logic       write_buf_idle0;
    logic       write_buf_valid0;
    logic [2:0] write_buf_index0;
    logic       ctrl_idle;
    logic [1:0] ctrl_state;
    logic       core_idle;
    logic [1:0] core_slice_state;
  } wd_status_word_t;

  typedef struct packed {
    logic [4:0] reserved1;
    logic [10:0] events;
    logic       reserved0;
    logic       acc1_valid;
    logic       acc0_valid;
    logic       acc_buf_sel_aa;
    logic       wait_for_acc1_ready;
    logic       wait_for_acc0_ready;
    logic       acc_buf_sel_ai;
    logic       wait_for_dw1_ready;
    logic       wait_for_dw0_ready;
    logic       dw_sel;
    logic       stall_stripe;
    logic       wait_for_weights;
    logic       wait_for_acc_buf;
    logic       wait_for_ib;
    logic       trav_en;
    logic       block_cfg_valid;
  } mac_status_word_t;

  typedef struct packed {
    logic [7:0] reserved1;
    logic [7:0] events;
    logic [7:0] reserved0;
    logic       blk_cmd_valid;
    logic       blk_cmd_ready;
    logic       cmd_ofm_valid;
    logic       cmd_sbr_valid;
    logic       cmd_scl_valid;
    logic       cmd_ctl_valid;
    logic       cmd_act_valid;
    logic       cmd_sbw_valid;
  } ao_status_word_t;

  typedef struct packed {
    logic       axi0_w_stalled;
    logic       axi0_aw_stalled;
    logic       axi0_rd_limit_stall;
    logic       axi0_ar_stalled;
    logic       bs_bitstream_ready_c0;
    logic       bs_bitstream_valid_c0;
    logic       wd_bitstream_ready_c0;
    logic       wd_bitstream_valid_c0;
    logic       cmd_ready;
    logic       cmd_valid;
    logic       ob1_ready_c0;
    logic       ob1_valid_c0;
    logic       ob0_ready_c0;
    logic       ob0_valid_c0;
    logic       ib1_ao_ready_c0;
    logic       ib1_ao_valid_c0;
    logic       ib0_ao_ready_c0;
    logic       ib0_ao_valid_c0;
    logic       ib1_ai_ready_c0;
    logic       ib1_ai_valid_c0;
    logic       ib0_ai_ready_c0;
    logic       ib0_ai_valid_c0;
    logic       pause_ack;
    logic       pause_req;
    logic       halt_ack;
    logic       halt_req;
    logic       ofm_idle;
    logic       m2m_idle;
    logic       bas_idle_c0;
    logic       wgt_idle_c0;
    logic       ifm_idle;
    logic       cmd_idle;
  } dma_status0_word_t;

  typedef struct packed {
    logic [7:0] reserved0;
    logic       bs_bitstream_ready_c1;
    logic       bs_bitstream_valid_c1;
    logic       wd_bitstream_ready_c1;
    logic       wd_bitstream_valid_c1;
    logic       ob1_ready_c1;
    logic       ob1_valid_c1;
    logic       ob0_ready_c1;
    logic       ob0_valid_c1;
    logic       ib1_ao_ready_c1;
    logic       ib1_ao_valid_c1;
    logic       ib0_ao_ready_c1;
    logic       ib0_ao_valid_c1;
    logic       ib1_ai_ready_c1;
    logic       ib1_ai_valid_c1;
    logic       ib0_ai_ready_c1;
    logic       ib0_ai_valid_c1;
    logic       bas_idle_c1;
    logic       wgt_idle_c1;
    logic       axi1_wr_limit_stall;
    logic       axi1_w_stalled;
    logic       axi1_wr_stalled;
    logic       axi1_rd_limit_stall;
    logic       axi1_ar_stalled;
    logic       axi0_wr_limit_stall;
  } dma_status1_word_t;

  typedef struct packed {
    logic [25:0] reserved0;
    logic       wd_clk;
    logic       ao_clk;
    logic       mac_clk;
    logic       dma_clk;
    logic       cc_clk;
    logic       top_level_clk;
  } clkforce_word_t;

  typedef logic [31:0] debug_address_word_t;

  typedef logic [31:0] debug_misc_word_t;

  typedef logic [31:0] debugcore_word_t;

  typedef logic [31:0] debug_block_word_t;



  typedef struct packed {
    logic [15:0] reserved1;
    logic [4:0] num_event_cnt;
    logic [6:0] reserved0;
    logic       mask_en;
    logic       cycle_cnt_rst;
    logic       event_cnt_rst;
    logic       cnt_en;
  } pmcr_word_t;

  typedef struct packed {
    logic       cycle_cnt;
    logic [26:0] reserved0;
    logic       event_cnt_3;
    logic       event_cnt_2;
    logic       event_cnt_1;
    logic       event_cnt_0;
  } pmcntenset_word_t;

  typedef struct packed {
    logic       cycle_cnt;
    logic [26:0] reserved0;
    logic       event_cnt_3;
    logic       event_cnt_2;
    logic       event_cnt_1;
    logic       event_cnt_0;
  } pmcntenclr_word_t;

  typedef struct packed {
    logic       cycle_cnt_ovf;
    logic [26:0] reserved0;
    logic       event_cnt_3_ovf;
    logic       event_cnt_2_ovf;
    logic       event_cnt_1_ovf;
    logic       event_cnt_0_ovf;
  } pmovsset_word_t;

  typedef struct packed {
    logic       cycle_cnt_ovf;
    logic [26:0] reserved0;
    logic       event_cnt_3_ovf;
    logic       event_cnt_2_ovf;
    logic       event_cnt_1_ovf;
    logic       event_cnt_0_ovf;
  } pmovsclr_word_t;

  typedef struct packed {
    logic       cycle_cnt_int;
    logic [26:0] reserved0;
    logic       event_cnt_3_int;
    logic       event_cnt_2_int;
    logic       event_cnt_1_int;
    logic       event_cnt_0_int;
  } pmintset_word_t;

  typedef struct packed {
    logic       cycle_cnt_int;
    logic [26:0] reserved0;
    logic       event_cnt_3_int;
    logic       event_cnt_2_int;
    logic       event_cnt_1_int;
    logic       event_cnt_0_int;
  } pmintclr_word_t;

  typedef logic [31:0] pmccntr_lo_word_t;

  typedef struct packed {
    logic [15:0] reserved0;
    logic [15:0] cycle_cnt_hi;
  } pmccntr_hi_word_t;

  typedef struct packed {
    logic [5:0] reserved1;
    logic [9:0] cycle_cnt_cfg_stop;
    logic [5:0] reserved0;
    logic [9:0] cycle_cnt_cfg_start;
  } pmccntr_cfg_word_t;

  typedef struct packed {
    logic [20:0] reserved1;
    logic       bw_ch_sel_en;
    logic [1:0] axi_cnt_sel;
    logic [3:0] reserved0;
    logic [3:0] ch_sel;
  } pmcaxi_chan_word_t;

  typedef logic [31:0] pmevcntr0_word_t;

  typedef logic [31:0] pmevcntr1_word_t;

  typedef logic [31:0] pmevcntr2_word_t;

  typedef logic [31:0] pmevcntr3_word_t;

  typedef struct packed {
    logic [21:0] reserved0;
    logic [9:0] ev_type;
  } pmevtyper0_word_t;

  typedef struct packed {
    logic [21:0] reserved0;
    logic [9:0] ev_type;
  } pmevtyper1_word_t;

  typedef struct packed {
    logic [21:0] reserved0;
    logic [9:0] ev_type;
  } pmevtyper2_word_t;

  typedef struct packed {
    logic [21:0] reserved0;
    logic [9:0] ev_type;
  } pmevtyper3_word_t;



  typedef logic [31:0] kernel_x_word_t;

  typedef logic [31:0] kernel_y_word_t;

  typedef logic [31:0] kernel_w_m1_word_t;

  typedef logic [31:0] kernel_h_m1_word_t;

  typedef logic [31:0] ofm_cblk_width_m1_word_t;

  typedef logic [31:0] ofm_cblk_height_m1_word_t;

  typedef logic [31:0] ofm_cblk_depth_m1_word_t;

  typedef logic [31:0] ifm_cblk_depth_m1_word_t;

  typedef logic [31:0] ofm_x_word_t;

  typedef logic [31:0] ofm_y_word_t;

  typedef logic [31:0] ofm_z_word_t;

  typedef logic [31:0] ifm_z_word_t;

  typedef logic [31:0] pad_top_word_t;

  typedef logic [31:0] pad_left_word_t;

  typedef logic [31:0] ifm_cblk_width_word_t;

  typedef logic [31:0] ifm_cblk_height_word_t;

  typedef logic [31:0] dma_ifm_src_word_t;

  typedef logic [31:0] dma_ifm_src_hi_word_t;

  typedef logic [31:0] dma_ifm_dst_word_t;

  typedef logic [31:0] dma_ofm_src_word_t;

  typedef logic [31:0] dma_ofm_dst_word_t;

  typedef logic [31:0] dma_ofm_dst_hi_word_t;

  typedef logic [31:0] dma_weight_src_word_t;

  typedef logic [31:0] dma_weight_src_hi_word_t;

  typedef logic [31:0] dma_cmd_src_word_t;

  typedef logic [31:0] dma_cmd_src_hi_word_t;

  typedef logic [31:0] dma_cmd_size_word_t;

  typedef logic [31:0] dma_m2m_src_word_t;

  typedef logic [31:0] dma_m2m_src_hi_word_t;

  typedef logic [31:0] dma_m2m_dst_word_t;

  typedef logic [31:0] dma_m2m_dst_hi_word_t;

  typedef logic [31:0] current_qread_word_t;

  typedef logic [31:0] dma_scale_src_word_t;

  typedef logic [31:0] dma_scale_src_hi_word_t;

  typedef logic [31:0] current_block_word_t;

  typedef logic [31:0] current_op_word_t;

  typedef logic [31:0] current_cmd_word_t;



  typedef logic [31:0] ifm_pad_top_word_t;

  typedef logic [31:0] ifm_pad_left_word_t;

  typedef logic [31:0] ifm_pad_right_word_t;

  typedef logic [31:0] ifm_pad_bottom_word_t;

  typedef logic [31:0] ifm_depth_m1_word_t;

  typedef logic [31:0] ifm_precision_word_t;

  typedef logic [31:0] ifm_upscale_word_t;

  typedef logic [31:0] ifm_zero_point_word_t;

  typedef logic [31:0] ifm_width0_m1_word_t;

  typedef logic [31:0] ifm_height0_m1_word_t;

  typedef logic [31:0] ifm_height1_m1_word_t;

  typedef logic [31:0] ifm_ib_end_word_t;

  typedef logic [31:0] ifm_region_word_t;

  typedef logic [31:0] ofm_width_m1_word_t;

  typedef logic [31:0] ofm_height_m1_word_t;

  typedef logic [31:0] ofm_depth_m1_word_t;

  typedef logic [31:0] ofm_precision_word_t;

  typedef logic [31:0] ofm_blk_width_m1_word_t;

  typedef logic [31:0] ofm_blk_height_m1_word_t;

  typedef logic [31:0] ofm_blk_depth_m1_word_t;

  typedef logic [31:0] ofm_zero_point_word_t;

  typedef logic [31:0] ofm_width0_m1_word_t;

  typedef logic [31:0] ofm_height0_m1_word_t;

  typedef logic [31:0] ofm_height1_m1_word_t;

  typedef logic [31:0] ofm_region_word_t;

  typedef logic [31:0] kernel_width_m1_word_t;

  typedef logic [31:0] kernel_height_m1_word_t;

  typedef logic [31:0] kernel_stride_word_t;

  typedef logic [31:0] parallel_mode_word_t;

  typedef logic [31:0] acc_format_word_t;

  typedef logic [31:0] activation_word_t;

  typedef logic [31:0] activation_min_word_t;

  typedef logic [31:0] activation_max_word_t;

  typedef logic [31:0] weight_region_word_t;

  typedef logic [31:0] scale_region_word_t;

  typedef logic [31:0] ab_start_word_t;

  typedef logic [31:0] blockdep_word_t;

  typedef logic [31:0] dma0_src_region_word_t;

  typedef logic [31:0] dma0_dst_region_word_t;

  typedef logic [31:0] dma0_size0_word_t;

  typedef logic [31:0] dma0_size1_word_t;

  typedef logic [31:0] ifm2_broadcast_word_t;

  typedef logic [31:0] ifm2_scalar_word_t;

  typedef logic [31:0] ifm2_precision_word_t;

  typedef logic [31:0] ifm2_zero_point_word_t;

  typedef logic [31:0] ifm2_width0_m1_word_t;

  typedef logic [31:0] ifm2_height0_m1_word_t;

  typedef logic [31:0] ifm2_height1_m1_word_t;

  typedef logic [31:0] ifm2_ib_start_word_t;

  typedef logic [31:0] ifm2_region_word_t;

  typedef logic [31:0] ifm_base0_word_t;

  typedef logic [31:0] ifm_base0_hi_word_t;

  typedef logic [31:0] ifm_base1_word_t;

  typedef logic [31:0] ifm_base1_hi_word_t;

  typedef logic [31:0] ifm_base2_word_t;

  typedef logic [31:0] ifm_base2_hi_word_t;

  typedef logic [31:0] ifm_base3_word_t;

  typedef logic [31:0] ifm_base3_hi_word_t;

  typedef logic [31:0] ifm_stride_x_word_t;

  typedef logic [31:0] ifm_stride_x_hi_word_t;

  typedef logic [31:0] ifm_stride_y_word_t;

  typedef logic [31:0] ifm_stride_y_hi_word_t;

  typedef logic [31:0] ifm_stride_c_word_t;

  typedef logic [31:0] ifm_stride_c_hi_word_t;

  typedef logic [31:0] ofm_base0_word_t;

  typedef logic [31:0] ofm_base0_hi_word_t;

  typedef logic [31:0] ofm_base1_word_t;

  typedef logic [31:0] ofm_base1_hi_word_t;

  typedef logic [31:0] ofm_base2_word_t;

  typedef logic [31:0] ofm_base2_hi_word_t;

  typedef logic [31:0] ofm_base3_word_t;

  typedef logic [31:0] ofm_base3_hi_word_t;

  typedef logic [31:0] ofm_stride_x_word_t;

  typedef logic [31:0] ofm_stride_x_hi_word_t;

  typedef logic [31:0] ofm_stride_y_word_t;

  typedef logic [31:0] ofm_stride_y_hi_word_t;

  typedef logic [31:0] ofm_stride_c_word_t;

  typedef logic [31:0] ofm_stride_c_hi_word_t;

  typedef logic [31:0] weight_base_word_t;

  typedef logic [31:0] weight_base_hi_word_t;

  typedef logic [31:0] weight_length_word_t;

  typedef logic [31:0] scale_base_word_t;

  typedef logic [31:0] scale_base_hi_word_t;

  typedef logic [31:0] scale_length_word_t;

  typedef logic [31:0] ofm_scale_word_t;

  typedef logic [31:0] ofm_scale_shift_word_t;

  typedef logic [31:0] opa_scale_word_t;

  typedef logic [31:0] opa_scale_shift_word_t;

  typedef logic [31:0] opb_scale_word_t;

  typedef logic [31:0] dma0_src_word_t;

  typedef logic [31:0] dma0_src_hi_word_t;

  typedef logic [31:0] dma0_dst_word_t;

  typedef logic [31:0] dma0_dst_hi_word_t;

  typedef logic [31:0] dma0_len_word_t;

  typedef logic [31:0] dma0_len_hi_word_t;

  typedef logic [31:0] dma0_skip0_word_t;

  typedef logic [31:0] dma0_skip0_hi_word_t;

  typedef logic [31:0] dma0_skip1_word_t;

  typedef logic [31:0] dma0_skip1_hi_word_t;

  typedef logic [31:0] ifm2_base0_word_t;

  typedef logic [31:0] ifm2_base0_hi_word_t;

  typedef logic [31:0] ifm2_base1_word_t;

  typedef logic [31:0] ifm2_base1_hi_word_t;

  typedef logic [31:0] ifm2_base2_word_t;

  typedef logic [31:0] ifm2_base2_hi_word_t;

  typedef logic [31:0] ifm2_base3_word_t;

  typedef logic [31:0] ifm2_base3_hi_word_t;

  typedef logic [31:0] ifm2_stride_x_word_t;

  typedef logic [31:0] ifm2_stride_x_hi_word_t;

  typedef logic [31:0] ifm2_stride_y_word_t;

  typedef logic [31:0] ifm2_stride_y_hi_word_t;

  typedef logic [31:0] ifm2_stride_c_word_t;

  typedef logic [31:0] ifm2_stride_c_hi_word_t;

  typedef logic [31:0] weight1_base_word_t;

  typedef logic [31:0] weight1_base_hi_word_t;

  typedef logic [31:0] weight1_length_word_t;

  typedef logic [31:0] scale1_base_word_t;

  typedef logic [31:0] scale1_base_hi_word_t;

  typedef logic [31:0] scale1_length_word_t;




  typedef enum logic [0:0] {
    STATUS_STATE_stopped = 1'h0,
    STATUS_STATE_running = 1'h1,
    STATUS_STATE_X = 1'hx
  } status_state_t;

  typedef enum logic [0:0] {
    RESET_PENDING_CPL_user = 1'h0,
    RESET_PENDING_CPL_privileged = 1'h1,
    RESET_PENDING_CPL_X = 1'hx
  } reset_pending_cpl_t;

  typedef enum logic [0:0] {
    RESET_PENDING_CSL_secure = 1'h0,
    RESET_PENDING_CSL_non_secure = 1'h1,
    RESET_PENDING_CSL_X = 1'hx
  } reset_pending_csl_t;

  typedef enum logic [0:0] {
    PROT_ACTIVE_CPL_user = 1'h0,
    PROT_ACTIVE_CPL_privileged = 1'h1,
    PROT_ACTIVE_CPL_X = 1'hx
  } prot_active_cpl_t;

  typedef enum logic [0:0] {
    PROT_ACTIVE_CSL_secure = 1'h0,
    PROT_ACTIVE_CSL_non_secure = 1'h1,
    PROT_ACTIVE_CSL_X = 1'hx
  } prot_active_csl_t;

  typedef enum logic [3:0] {
    CONFIG_MACS_PER_CC_RESERVED0 = 4'h0,
    CONFIG_MACS_PER_CC_RESERVED1 = 4'h1,
    CONFIG_MACS_PER_CC_RESERVED2 = 4'h2,
    CONFIG_MACS_PER_CC_RESERVED3 = 4'h3,
    CONFIG_MACS_PER_CC_RESERVED4 = 4'h4,
    CONFIG_MACS_PER_CC_Macs_per_cc_is_5 = 4'h5,
    CONFIG_MACS_PER_CC_Macs_per_cc_is_6 = 4'h6,
    CONFIG_MACS_PER_CC_Macs_per_cc_is_7 = 4'h7,
    CONFIG_MACS_PER_CC_Macs_per_cc_is_8 = 4'h8,
    CONFIG_MACS_PER_CC_RESERVED5 = 4'h9,
    CONFIG_MACS_PER_CC_RESERVED6 = 4'ha,
    CONFIG_MACS_PER_CC_RESERVED7 = 4'hb,
    CONFIG_MACS_PER_CC_RESERVED8 = 4'hc,
    CONFIG_MACS_PER_CC_RESERVED9 = 4'hd,
    CONFIG_MACS_PER_CC_RESERVED10 = 4'he,
    CONFIG_MACS_PER_CC_RESERVED11 = 4'hf,
    CONFIG_MACS_PER_CC_X = 4'hx
  } config_macs_per_cc_t;

  typedef enum logic [7:0] {
    CONFIG_SHRAM_SIZE_SHRAM_96KB = 8'h60,
    CONFIG_SHRAM_SIZE_SHRAM_48KB = 8'h30,
    CONFIG_SHRAM_SIZE_SHRAM_24KB = 8'h18,
    CONFIG_SHRAM_SIZE_SHRAM_16KB = 8'h10,
    CONFIG_SHRAM_SIZE_X = 8'hx
  } config_shram_size_t;

  typedef enum logic [1:0] {
    REGIONCFG_REGION0_axi0_outstanding_counter0 = 2'h0,
    REGIONCFG_REGION0_axi0_outstanding_counter1 = 2'h1,
    REGIONCFG_REGION0_axi1_outstanding_counter2 = 2'h2,
    REGIONCFG_REGION0_axi1_outstanding_counter3 = 2'h3,
    REGIONCFG_REGION0_X = 2'hx
  } regioncfg_region0_t;

  typedef enum logic [1:0] {
    REGIONCFG_REGION1_axi0_outstanding_counter0 = 2'h0,
    REGIONCFG_REGION1_axi0_outstanding_counter1 = 2'h1,
    REGIONCFG_REGION1_axi1_outstanding_counter2 = 2'h2,
    REGIONCFG_REGION1_axi1_outstanding_counter3 = 2'h3,
    REGIONCFG_REGION1_X = 2'hx
  } regioncfg_region1_t;

  typedef enum logic [1:0] {
    REGIONCFG_REGION2_axi0_outstanding_counter0 = 2'h0,
    REGIONCFG_REGION2_axi0_outstanding_counter1 = 2'h1,
    REGIONCFG_REGION2_axi1_outstanding_counter2 = 2'h2,
    REGIONCFG_REGION2_axi1_outstanding_counter3 = 2'h3,
    REGIONCFG_REGION2_X = 2'hx
  } regioncfg_region2_t;

  typedef enum logic [1:0] {
    REGIONCFG_REGION3_axi0_outstanding_counter0 = 2'h0,
    REGIONCFG_REGION3_axi0_outstanding_counter1 = 2'h1,
    REGIONCFG_REGION3_axi1_outstanding_counter2 = 2'h2,
    REGIONCFG_REGION3_axi1_outstanding_counter3 = 2'h3,
    REGIONCFG_REGION3_X = 2'hx
  } regioncfg_region3_t;

  typedef enum logic [1:0] {
    REGIONCFG_REGION4_axi0_outstanding_counter0 = 2'h0,
    REGIONCFG_REGION4_axi0_outstanding_counter1 = 2'h1,
    REGIONCFG_REGION4_axi1_outstanding_counter2 = 2'h2,
    REGIONCFG_REGION4_axi1_outstanding_counter3 = 2'h3,
    REGIONCFG_REGION4_X = 2'hx
  } regioncfg_region4_t;

  typedef enum logic [1:0] {
    REGIONCFG_REGION5_axi0_outstanding_counter0 = 2'h0,
    REGIONCFG_REGION5_axi0_outstanding_counter1 = 2'h1,
    REGIONCFG_REGION5_axi1_outstanding_counter2 = 2'h2,
    REGIONCFG_REGION5_axi1_outstanding_counter3 = 2'h3,
    REGIONCFG_REGION5_X = 2'hx
  } regioncfg_region5_t;

  typedef enum logic [1:0] {
    REGIONCFG_REGION6_axi0_outstanding_counter0 = 2'h0,
    REGIONCFG_REGION6_axi0_outstanding_counter1 = 2'h1,
    REGIONCFG_REGION6_axi1_outstanding_counter2 = 2'h2,
    REGIONCFG_REGION6_axi1_outstanding_counter3 = 2'h3,
    REGIONCFG_REGION6_X = 2'hx
  } regioncfg_region6_t;

  typedef enum logic [1:0] {
    REGIONCFG_REGION7_axi0_outstanding_counter0 = 2'h0,
    REGIONCFG_REGION7_axi0_outstanding_counter1 = 2'h1,
    REGIONCFG_REGION7_axi1_outstanding_counter2 = 2'h2,
    REGIONCFG_REGION7_axi1_outstanding_counter3 = 2'h3,
    REGIONCFG_REGION7_X = 2'hx
  } regioncfg_region7_t;

  typedef enum logic [3:0] {
    AXI_LIMIT0_MEMTYPE_Device_Non_Bufferable = 4'h0,
    AXI_LIMIT0_MEMTYPE_Device_Bufferable = 4'h1,
    AXI_LIMIT0_MEMTYPE_Normal_Non_cacheable_Non_bufferable = 4'h2,
    AXI_LIMIT0_MEMTYPE_Normal_Non_cacheable_Bufferable = 4'h3,
    AXI_LIMIT0_MEMTYPE_Write_through_No_allocate = 4'h4,
    AXI_LIMIT0_MEMTYPE_Write_through_Read_allocate = 4'h5,
    AXI_LIMIT0_MEMTYPE_Write_through_Write_allocate = 4'h6,
    AXI_LIMIT0_MEMTYPE_Write_through_Read_and_Write_allocate = 4'h7,
    AXI_LIMIT0_MEMTYPE_Write_back_No_allocate = 4'h8,
    AXI_LIMIT0_MEMTYPE_Write_back_Read_allocate = 4'h9,
    AXI_LIMIT0_MEMTYPE_Write_back_Write_allocate = 4'ha,
    AXI_LIMIT0_MEMTYPE_Write_back_Read_and_Write_allocate = 4'hb,
    AXI_LIMIT0_MEMTYPE_RESERVED_12 = 4'hc,
    AXI_LIMIT0_MEMTYPE_RESERVED_13 = 4'hd,
    AXI_LIMIT0_MEMTYPE_RESERVED_14 = 4'he,
    AXI_LIMIT0_MEMTYPE_RESERVED_15 = 4'hf,
    AXI_LIMIT0_MEMTYPE_X = 4'hx
  } axi_limit0_memtype_t;

  typedef enum logic [3:0] {
    AXI_LIMIT1_MEMTYPE_Device_Non_Bufferable = 4'h0,
    AXI_LIMIT1_MEMTYPE_Device_Bufferable = 4'h1,
    AXI_LIMIT1_MEMTYPE_Normal_Non_cacheable_Non_bufferable = 4'h2,
    AXI_LIMIT1_MEMTYPE_Normal_Non_cacheable_Bufferable = 4'h3,
    AXI_LIMIT1_MEMTYPE_Write_through_No_allocate = 4'h4,
    AXI_LIMIT1_MEMTYPE_Write_through_Read_allocate = 4'h5,
    AXI_LIMIT1_MEMTYPE_Write_through_Write_allocate = 4'h6,
    AXI_LIMIT1_MEMTYPE_Write_through_Read_and_Write_allocate = 4'h7,
    AXI_LIMIT1_MEMTYPE_Write_back_No_allocate = 4'h8,
    AXI_LIMIT1_MEMTYPE_Write_back_Read_allocate = 4'h9,
    AXI_LIMIT1_MEMTYPE_Write_back_Write_allocate = 4'ha,
    AXI_LIMIT1_MEMTYPE_Write_back_Read_and_Write_allocate = 4'hb,
    AXI_LIMIT1_MEMTYPE_RESERVED_12 = 4'hc,
    AXI_LIMIT1_MEMTYPE_RESERVED_13 = 4'hd,
    AXI_LIMIT1_MEMTYPE_RESERVED_14 = 4'he,
    AXI_LIMIT1_MEMTYPE_RESERVED_15 = 4'hf,
    AXI_LIMIT1_MEMTYPE_X = 4'hx
  } axi_limit1_memtype_t;

  typedef enum logic [3:0] {
    AXI_LIMIT2_MEMTYPE_Device_Non_Bufferable = 4'h0,
    AXI_LIMIT2_MEMTYPE_Device_Bufferable = 4'h1,
    AXI_LIMIT2_MEMTYPE_Normal_Non_cacheable_Non_bufferable = 4'h2,
    AXI_LIMIT2_MEMTYPE_Normal_Non_cacheable_Bufferable = 4'h3,
    AXI_LIMIT2_MEMTYPE_Write_through_No_allocate = 4'h4,
    AXI_LIMIT2_MEMTYPE_Write_through_Read_allocate = 4'h5,
    AXI_LIMIT2_MEMTYPE_Write_through_Write_allocate = 4'h6,
    AXI_LIMIT2_MEMTYPE_Write_through_Read_and_Write_allocate = 4'h7,
    AXI_LIMIT2_MEMTYPE_Write_back_No_allocate = 4'h8,
    AXI_LIMIT2_MEMTYPE_Write_back_Read_allocate = 4'h9,
    AXI_LIMIT2_MEMTYPE_Write_back_Write_allocate = 4'ha,
    AXI_LIMIT2_MEMTYPE_Write_back_Read_and_Write_allocate = 4'hb,
    AXI_LIMIT2_MEMTYPE_RESERVED_12 = 4'hc,
    AXI_LIMIT2_MEMTYPE_RESERVED_13 = 4'hd,
    AXI_LIMIT2_MEMTYPE_RESERVED_14 = 4'he,
    AXI_LIMIT2_MEMTYPE_RESERVED_15 = 4'hf,
    AXI_LIMIT2_MEMTYPE_X = 4'hx
  } axi_limit2_memtype_t;

  typedef enum logic [3:0] {
    AXI_LIMIT3_MEMTYPE_Device_Non_Bufferable = 4'h0,
    AXI_LIMIT3_MEMTYPE_Device_Bufferable = 4'h1,
    AXI_LIMIT3_MEMTYPE_Normal_Non_cacheable_Non_bufferable = 4'h2,
    AXI_LIMIT3_MEMTYPE_Normal_Non_cacheable_Bufferable = 4'h3,
    AXI_LIMIT3_MEMTYPE_Write_through_No_allocate = 4'h4,
    AXI_LIMIT3_MEMTYPE_Write_through_Read_allocate = 4'h5,
    AXI_LIMIT3_MEMTYPE_Write_through_Write_allocate = 4'h6,
    AXI_LIMIT3_MEMTYPE_Write_through_Read_and_Write_allocate = 4'h7,
    AXI_LIMIT3_MEMTYPE_Write_back_No_allocate = 4'h8,
    AXI_LIMIT3_MEMTYPE_Write_back_Read_allocate = 4'h9,
    AXI_LIMIT3_MEMTYPE_Write_back_Write_allocate = 4'ha,
    AXI_LIMIT3_MEMTYPE_Write_back_Read_and_Write_allocate = 4'hb,
    AXI_LIMIT3_MEMTYPE_RESERVED_12 = 4'hc,
    AXI_LIMIT3_MEMTYPE_RESERVED_13 = 4'hd,
    AXI_LIMIT3_MEMTYPE_RESERVED_14 = 4'he,
    AXI_LIMIT3_MEMTYPE_RESERVED_15 = 4'hf,
    AXI_LIMIT3_MEMTYPE_X = 4'hx
  } axi_limit3_memtype_t;

  typedef enum logic [9:0] {
    PMEVTYPER0_EV_TYPE_no_event = 10'h000,
    PMEVTYPER0_EV_TYPE_cycle = 10'h011,
    PMEVTYPER0_EV_TYPE_npu_idle = 10'h020,
    PMEVTYPER0_EV_TYPE_cc_stalled_on_blockdep = 10'h021,
    PMEVTYPER0_EV_TYPE_cc_stalled_on_shram_reconfig = 10'h022,
    PMEVTYPER0_EV_TYPE_npu_active = 10'h023,
    PMEVTYPER0_EV_TYPE_mac_active = 10'h030,
    PMEVTYPER0_EV_TYPE_mac_active_8bit = 10'h031,
    PMEVTYPER0_EV_TYPE_mac_active_16bit = 10'h032,
    PMEVTYPER0_EV_TYPE_mac_dpu_active = 10'h033,
    PMEVTYPER0_EV_TYPE_mac_stalled_by_wd_acc = 10'h034,
    PMEVTYPER0_EV_TYPE_mac_stalled_by_wd = 10'h035,
    PMEVTYPER0_EV_TYPE_mac_stalled_by_acc = 10'h036,
    PMEVTYPER0_EV_TYPE_mac_stalled_by_ib = 10'h037,
    PMEVTYPER0_EV_TYPE_mac_active_32bit = 10'h038,
    PMEVTYPER0_EV_TYPE_mac_stalled_by_int_w = 10'h039,
    PMEVTYPER0_EV_TYPE_mac_stalled_by_int_acc = 10'h03a,
    PMEVTYPER0_EV_TYPE_ao_active = 10'h040,
    PMEVTYPER0_EV_TYPE_ao_active_8bit = 10'h041,
    PMEVTYPER0_EV_TYPE_ao_active_16bit = 10'h042,
    PMEVTYPER0_EV_TYPE_ao_stalled_by_ofmp_ob = 10'h043,
    PMEVTYPER0_EV_TYPE_ao_stalled_by_ofmp = 10'h044,
    PMEVTYPER0_EV_TYPE_ao_stalled_by_ob = 10'h045,
    PMEVTYPER0_EV_TYPE_ao_stalled_by_acc_ib = 10'h046,
    PMEVTYPER0_EV_TYPE_ao_stalled_by_acc = 10'h047,
    PMEVTYPER0_EV_TYPE_ao_stalled_by_ib = 10'h048,
    PMEVTYPER0_EV_TYPE_wd_active = 10'h050,
    PMEVTYPER0_EV_TYPE_wd_stalled = 10'h051,
    PMEVTYPER0_EV_TYPE_wd_stalled_by_ws = 10'h052,
    PMEVTYPER0_EV_TYPE_wd_stalled_by_wd_buf = 10'h053,
    PMEVTYPER0_EV_TYPE_wd_parse_active = 10'h054,
    PMEVTYPER0_EV_TYPE_wd_parse_stalled = 10'h055,
    PMEVTYPER0_EV_TYPE_wd_parse_stalled_in = 10'h056,
    PMEVTYPER0_EV_TYPE_wd_parse_stalled_out = 10'h057,
    PMEVTYPER0_EV_TYPE_wd_trans_ws = 10'h058,
    PMEVTYPER0_EV_TYPE_wd_trans_wb = 10'h059,
    PMEVTYPER0_EV_TYPE_wd_trans_dw0 = 10'h05a,
    PMEVTYPER0_EV_TYPE_wd_trans_dw1 = 10'h05b,
    PMEVTYPER0_EV_TYPE_axi0_rd_trans_accepted = 10'h080,
    PMEVTYPER0_EV_TYPE_axi0_rd_trans_completed = 10'h081,
    PMEVTYPER0_EV_TYPE_axi0_rd_data_beat_received = 10'h082,
    PMEVTYPER0_EV_TYPE_axi0_rd_tran_req_stalled = 10'h083,
    PMEVTYPER0_EV_TYPE_axi0_wr_trans_accepted = 10'h084,
    PMEVTYPER0_EV_TYPE_axi0_wr_trans_completed_m = 10'h085,
    PMEVTYPER0_EV_TYPE_axi0_wr_trans_completed_s = 10'h086,
    PMEVTYPER0_EV_TYPE_axi0_wr_data_beat_written = 10'h087,
    PMEVTYPER0_EV_TYPE_axi0_wr_tran_req_stalled = 10'h088,
    PMEVTYPER0_EV_TYPE_axi0_wr_data_beat_stalled = 10'h089,
    PMEVTYPER0_EV_TYPE_axi0_enabled_cycles = 10'h08c,
    PMEVTYPER0_EV_TYPE_axi0_rd_stall_limit = 10'h08e,
    PMEVTYPER0_EV_TYPE_axi0_wr_stall_limit = 10'h08f,
    PMEVTYPER0_EV_TYPE_axi1_rd_trans_accepted = 10'h180,
    PMEVTYPER0_EV_TYPE_axi1_rd_trans_completed = 10'h181,
    PMEVTYPER0_EV_TYPE_axi1_rd_data_beat_received = 10'h182,
    PMEVTYPER0_EV_TYPE_axi1_rd_tran_req_stalled = 10'h183,
    PMEVTYPER0_EV_TYPE_axi1_wr_trans_accepted = 10'h184,
    PMEVTYPER0_EV_TYPE_axi1_wr_trans_completed_m = 10'h185,
    PMEVTYPER0_EV_TYPE_axi1_wr_trans_completed_s = 10'h186,
    PMEVTYPER0_EV_TYPE_axi1_wr_data_beat_written = 10'h187,
    PMEVTYPER0_EV_TYPE_axi1_wr_tran_req_stalled = 10'h188,
    PMEVTYPER0_EV_TYPE_axi1_wr_data_beat_stalled = 10'h189,
    PMEVTYPER0_EV_TYPE_axi1_enabled_cycles = 10'h18c,
    PMEVTYPER0_EV_TYPE_axi1_rd_stall_limit = 10'h18e,
    PMEVTYPER0_EV_TYPE_axi1_wr_stall_limit = 10'h18f,
    PMEVTYPER0_EV_TYPE_axi_latency_any = 10'h0a0,
    PMEVTYPER0_EV_TYPE_axi_latency_32 = 10'h0a1,
    PMEVTYPER0_EV_TYPE_axi_latency_64 = 10'h0a2,
    PMEVTYPER0_EV_TYPE_axi_latency_128 = 10'h0a3,
    PMEVTYPER0_EV_TYPE_axi_latency_256 = 10'h0a4,
    PMEVTYPER0_EV_TYPE_axi_latency_512 = 10'h0a5,
    PMEVTYPER0_EV_TYPE_axi_latency_1024 = 10'h0a6,
    PMEVTYPER0_EV_TYPE_ecc_dma = 10'h0b0,
    PMEVTYPER0_EV_TYPE_ecc_sb0 = 10'h0b1,
    PMEVTYPER0_EV_TYPE_ecc_sb1 = 10'h1b1,
    PMEVTYPER0_EV_TYPE_X = 10'hx
  } pmevtyper0_ev_type_t;

  typedef enum logic [9:0] {
    PMEVTYPER1_EV_TYPE_no_event = 10'h000,
    PMEVTYPER1_EV_TYPE_cycle = 10'h011,
    PMEVTYPER1_EV_TYPE_npu_idle = 10'h020,
    PMEVTYPER1_EV_TYPE_cc_stalled_on_blockdep = 10'h021,
    PMEVTYPER1_EV_TYPE_cc_stalled_on_shram_reconfig = 10'h022,
    PMEVTYPER1_EV_TYPE_npu_active = 10'h023,
    PMEVTYPER1_EV_TYPE_mac_active = 10'h030,
    PMEVTYPER1_EV_TYPE_mac_active_8bit = 10'h031,
    PMEVTYPER1_EV_TYPE_mac_active_16bit = 10'h032,
    PMEVTYPER1_EV_TYPE_mac_dpu_active = 10'h033,
    PMEVTYPER1_EV_TYPE_mac_stalled_by_wd_acc = 10'h034,
    PMEVTYPER1_EV_TYPE_mac_stalled_by_wd = 10'h035,
    PMEVTYPER1_EV_TYPE_mac_stalled_by_acc = 10'h036,
    PMEVTYPER1_EV_TYPE_mac_stalled_by_ib = 10'h037,
    PMEVTYPER1_EV_TYPE_mac_active_32bit = 10'h038,
    PMEVTYPER1_EV_TYPE_mac_stalled_by_int_w = 10'h039,
    PMEVTYPER1_EV_TYPE_mac_stalled_by_int_acc = 10'h03a,
    PMEVTYPER1_EV_TYPE_ao_active = 10'h040,
    PMEVTYPER1_EV_TYPE_ao_active_8bit = 10'h041,
    PMEVTYPER1_EV_TYPE_ao_active_16bit = 10'h042,
    PMEVTYPER1_EV_TYPE_ao_stalled_by_ofmp_ob = 10'h043,
    PMEVTYPER1_EV_TYPE_ao_stalled_by_ofmp = 10'h044,
    PMEVTYPER1_EV_TYPE_ao_stalled_by_ob = 10'h045,
    PMEVTYPER1_EV_TYPE_ao_stalled_by_acc_ib = 10'h046,
    PMEVTYPER1_EV_TYPE_ao_stalled_by_acc = 10'h047,
    PMEVTYPER1_EV_TYPE_ao_stalled_by_ib = 10'h048,
    PMEVTYPER1_EV_TYPE_wd_active = 10'h050,
    PMEVTYPER1_EV_TYPE_wd_stalled = 10'h051,
    PMEVTYPER1_EV_TYPE_wd_stalled_by_ws = 10'h052,
    PMEVTYPER1_EV_TYPE_wd_stalled_by_wd_buf = 10'h053,
    PMEVTYPER1_EV_TYPE_wd_parse_active = 10'h054,
    PMEVTYPER1_EV_TYPE_wd_parse_stalled = 10'h055,
    PMEVTYPER1_EV_TYPE_wd_parse_stalled_in = 10'h056,
    PMEVTYPER1_EV_TYPE_wd_parse_stalled_out = 10'h057,
    PMEVTYPER1_EV_TYPE_wd_trans_ws = 10'h058,
    PMEVTYPER1_EV_TYPE_wd_trans_wb = 10'h059,
    PMEVTYPER1_EV_TYPE_wd_trans_dw0 = 10'h05a,
    PMEVTYPER1_EV_TYPE_wd_trans_dw1 = 10'h05b,
    PMEVTYPER1_EV_TYPE_axi0_rd_trans_accepted = 10'h080,
    PMEVTYPER1_EV_TYPE_axi0_rd_trans_completed = 10'h081,
    PMEVTYPER1_EV_TYPE_axi0_rd_data_beat_received = 10'h082,
    PMEVTYPER1_EV_TYPE_axi0_rd_tran_req_stalled = 10'h083,
    PMEVTYPER1_EV_TYPE_axi0_wr_trans_accepted = 10'h084,
    PMEVTYPER1_EV_TYPE_axi0_wr_trans_completed_m = 10'h085,
    PMEVTYPER1_EV_TYPE_axi0_wr_trans_completed_s = 10'h086,
    PMEVTYPER1_EV_TYPE_axi0_wr_data_beat_written = 10'h087,
    PMEVTYPER1_EV_TYPE_axi0_wr_tran_req_stalled = 10'h088,
    PMEVTYPER1_EV_TYPE_axi0_wr_data_beat_stalled = 10'h089,
    PMEVTYPER1_EV_TYPE_axi0_enabled_cycles = 10'h08c,
    PMEVTYPER1_EV_TYPE_axi0_rd_stall_limit = 10'h08e,
    PMEVTYPER1_EV_TYPE_axi0_wr_stall_limit = 10'h08f,
    PMEVTYPER1_EV_TYPE_axi1_rd_trans_accepted = 10'h180,
    PMEVTYPER1_EV_TYPE_axi1_rd_trans_completed = 10'h181,
    PMEVTYPER1_EV_TYPE_axi1_rd_data_beat_received = 10'h182,
    PMEVTYPER1_EV_TYPE_axi1_rd_tran_req_stalled = 10'h183,
    PMEVTYPER1_EV_TYPE_axi1_wr_trans_accepted = 10'h184,
    PMEVTYPER1_EV_TYPE_axi1_wr_trans_completed_m = 10'h185,
    PMEVTYPER1_EV_TYPE_axi1_wr_trans_completed_s = 10'h186,
    PMEVTYPER1_EV_TYPE_axi1_wr_data_beat_written = 10'h187,
    PMEVTYPER1_EV_TYPE_axi1_wr_tran_req_stalled = 10'h188,
    PMEVTYPER1_EV_TYPE_axi1_wr_data_beat_stalled = 10'h189,
    PMEVTYPER1_EV_TYPE_axi1_enabled_cycles = 10'h18c,
    PMEVTYPER1_EV_TYPE_axi1_rd_stall_limit = 10'h18e,
    PMEVTYPER1_EV_TYPE_axi1_wr_stall_limit = 10'h18f,
    PMEVTYPER1_EV_TYPE_axi_latency_any = 10'h0a0,
    PMEVTYPER1_EV_TYPE_axi_latency_32 = 10'h0a1,
    PMEVTYPER1_EV_TYPE_axi_latency_64 = 10'h0a2,
    PMEVTYPER1_EV_TYPE_axi_latency_128 = 10'h0a3,
    PMEVTYPER1_EV_TYPE_axi_latency_256 = 10'h0a4,
    PMEVTYPER1_EV_TYPE_axi_latency_512 = 10'h0a5,
    PMEVTYPER1_EV_TYPE_axi_latency_1024 = 10'h0a6,
    PMEVTYPER1_EV_TYPE_ecc_dma = 10'h0b0,
    PMEVTYPER1_EV_TYPE_ecc_sb0 = 10'h0b1,
    PMEVTYPER1_EV_TYPE_ecc_sb1 = 10'h1b1,
    PMEVTYPER1_EV_TYPE_X = 10'hx
  } pmevtyper1_ev_type_t;

  typedef enum logic [9:0] {
    PMEVTYPER2_EV_TYPE_no_event = 10'h000,
    PMEVTYPER2_EV_TYPE_cycle = 10'h011,
    PMEVTYPER2_EV_TYPE_npu_idle = 10'h020,
    PMEVTYPER2_EV_TYPE_cc_stalled_on_blockdep = 10'h021,
    PMEVTYPER2_EV_TYPE_cc_stalled_on_shram_reconfig = 10'h022,
    PMEVTYPER2_EV_TYPE_npu_active = 10'h023,
    PMEVTYPER2_EV_TYPE_mac_active = 10'h030,
    PMEVTYPER2_EV_TYPE_mac_active_8bit = 10'h031,
    PMEVTYPER2_EV_TYPE_mac_active_16bit = 10'h032,
    PMEVTYPER2_EV_TYPE_mac_dpu_active = 10'h033,
    PMEVTYPER2_EV_TYPE_mac_stalled_by_wd_acc = 10'h034,
    PMEVTYPER2_EV_TYPE_mac_stalled_by_wd = 10'h035,
    PMEVTYPER2_EV_TYPE_mac_stalled_by_acc = 10'h036,
    PMEVTYPER2_EV_TYPE_mac_stalled_by_ib = 10'h037,
    PMEVTYPER2_EV_TYPE_mac_active_32bit = 10'h038,
    PMEVTYPER2_EV_TYPE_mac_stalled_by_int_w = 10'h039,
    PMEVTYPER2_EV_TYPE_mac_stalled_by_int_acc = 10'h03a,
    PMEVTYPER2_EV_TYPE_ao_active = 10'h040,
    PMEVTYPER2_EV_TYPE_ao_active_8bit = 10'h041,
    PMEVTYPER2_EV_TYPE_ao_active_16bit = 10'h042,
    PMEVTYPER2_EV_TYPE_ao_stalled_by_ofmp_ob = 10'h043,
    PMEVTYPER2_EV_TYPE_ao_stalled_by_ofmp = 10'h044,
    PMEVTYPER2_EV_TYPE_ao_stalled_by_ob = 10'h045,
    PMEVTYPER2_EV_TYPE_ao_stalled_by_acc_ib = 10'h046,
    PMEVTYPER2_EV_TYPE_ao_stalled_by_acc = 10'h047,
    PMEVTYPER2_EV_TYPE_ao_stalled_by_ib = 10'h048,
    PMEVTYPER2_EV_TYPE_wd_active = 10'h050,
    PMEVTYPER2_EV_TYPE_wd_stalled = 10'h051,
    PMEVTYPER2_EV_TYPE_wd_stalled_by_ws = 10'h052,
    PMEVTYPER2_EV_TYPE_wd_stalled_by_wd_buf = 10'h053,
    PMEVTYPER2_EV_TYPE_wd_parse_active = 10'h054,
    PMEVTYPER2_EV_TYPE_wd_parse_stalled = 10'h055,
    PMEVTYPER2_EV_TYPE_wd_parse_stalled_in = 10'h056,
    PMEVTYPER2_EV_TYPE_wd_parse_stalled_out = 10'h057,
    PMEVTYPER2_EV_TYPE_wd_trans_ws = 10'h058,
    PMEVTYPER2_EV_TYPE_wd_trans_wb = 10'h059,
    PMEVTYPER2_EV_TYPE_wd_trans_dw0 = 10'h05a,
    PMEVTYPER2_EV_TYPE_wd_trans_dw1 = 10'h05b,
    PMEVTYPER2_EV_TYPE_axi0_rd_trans_accepted = 10'h080,
    PMEVTYPER2_EV_TYPE_axi0_rd_trans_completed = 10'h081,
    PMEVTYPER2_EV_TYPE_axi0_rd_data_beat_received = 10'h082,
    PMEVTYPER2_EV_TYPE_axi0_rd_tran_req_stalled = 10'h083,
    PMEVTYPER2_EV_TYPE_axi0_wr_trans_accepted = 10'h084,
    PMEVTYPER2_EV_TYPE_axi0_wr_trans_completed_m = 10'h085,
    PMEVTYPER2_EV_TYPE_axi0_wr_trans_completed_s = 10'h086,
    PMEVTYPER2_EV_TYPE_axi0_wr_data_beat_written = 10'h087,
    PMEVTYPER2_EV_TYPE_axi0_wr_tran_req_stalled = 10'h088,
    PMEVTYPER2_EV_TYPE_axi0_wr_data_beat_stalled = 10'h089,
    PMEVTYPER2_EV_TYPE_axi0_enabled_cycles = 10'h08c,
    PMEVTYPER2_EV_TYPE_axi0_rd_stall_limit = 10'h08e,
    PMEVTYPER2_EV_TYPE_axi0_wr_stall_limit = 10'h08f,
    PMEVTYPER2_EV_TYPE_axi1_rd_trans_accepted = 10'h180,
    PMEVTYPER2_EV_TYPE_axi1_rd_trans_completed = 10'h181,
    PMEVTYPER2_EV_TYPE_axi1_rd_data_beat_received = 10'h182,
    PMEVTYPER2_EV_TYPE_axi1_rd_tran_req_stalled = 10'h183,
    PMEVTYPER2_EV_TYPE_axi1_wr_trans_accepted = 10'h184,
    PMEVTYPER2_EV_TYPE_axi1_wr_trans_completed_m = 10'h185,
    PMEVTYPER2_EV_TYPE_axi1_wr_trans_completed_s = 10'h186,
    PMEVTYPER2_EV_TYPE_axi1_wr_data_beat_written = 10'h187,
    PMEVTYPER2_EV_TYPE_axi1_wr_tran_req_stalled = 10'h188,
    PMEVTYPER2_EV_TYPE_axi1_wr_data_beat_stalled = 10'h189,
    PMEVTYPER2_EV_TYPE_axi1_enabled_cycles = 10'h18c,
    PMEVTYPER2_EV_TYPE_axi1_rd_stall_limit = 10'h18e,
    PMEVTYPER2_EV_TYPE_axi1_wr_stall_limit = 10'h18f,
    PMEVTYPER2_EV_TYPE_axi_latency_any = 10'h0a0,
    PMEVTYPER2_EV_TYPE_axi_latency_32 = 10'h0a1,
    PMEVTYPER2_EV_TYPE_axi_latency_64 = 10'h0a2,
    PMEVTYPER2_EV_TYPE_axi_latency_128 = 10'h0a3,
    PMEVTYPER2_EV_TYPE_axi_latency_256 = 10'h0a4,
    PMEVTYPER2_EV_TYPE_axi_latency_512 = 10'h0a5,
    PMEVTYPER2_EV_TYPE_axi_latency_1024 = 10'h0a6,
    PMEVTYPER2_EV_TYPE_ecc_dma = 10'h0b0,
    PMEVTYPER2_EV_TYPE_ecc_sb0 = 10'h0b1,
    PMEVTYPER2_EV_TYPE_ecc_sb1 = 10'h1b1,
    PMEVTYPER2_EV_TYPE_X = 10'hx
  } pmevtyper2_ev_type_t;

  typedef enum logic [9:0] {
    PMEVTYPER3_EV_TYPE_no_event = 10'h000,
    PMEVTYPER3_EV_TYPE_cycle = 10'h011,
    PMEVTYPER3_EV_TYPE_npu_idle = 10'h020,
    PMEVTYPER3_EV_TYPE_cc_stalled_on_blockdep = 10'h021,
    PMEVTYPER3_EV_TYPE_cc_stalled_on_shram_reconfig = 10'h022,
    PMEVTYPER3_EV_TYPE_npu_active = 10'h023,
    PMEVTYPER3_EV_TYPE_mac_active = 10'h030,
    PMEVTYPER3_EV_TYPE_mac_active_8bit = 10'h031,
    PMEVTYPER3_EV_TYPE_mac_active_16bit = 10'h032,
    PMEVTYPER3_EV_TYPE_mac_dpu_active = 10'h033,
    PMEVTYPER3_EV_TYPE_mac_stalled_by_wd_acc = 10'h034,
    PMEVTYPER3_EV_TYPE_mac_stalled_by_wd = 10'h035,
    PMEVTYPER3_EV_TYPE_mac_stalled_by_acc = 10'h036,
    PMEVTYPER3_EV_TYPE_mac_stalled_by_ib = 10'h037,
    PMEVTYPER3_EV_TYPE_mac_active_32bit = 10'h038,
    PMEVTYPER3_EV_TYPE_mac_stalled_by_int_w = 10'h039,
    PMEVTYPER3_EV_TYPE_mac_stalled_by_int_acc = 10'h03a,
    PMEVTYPER3_EV_TYPE_ao_active = 10'h040,
    PMEVTYPER3_EV_TYPE_ao_active_8bit = 10'h041,
    PMEVTYPER3_EV_TYPE_ao_active_16bit = 10'h042,
    PMEVTYPER3_EV_TYPE_ao_stalled_by_ofmp_ob = 10'h043,
    PMEVTYPER3_EV_TYPE_ao_stalled_by_ofmp = 10'h044,
    PMEVTYPER3_EV_TYPE_ao_stalled_by_ob = 10'h045,
    PMEVTYPER3_EV_TYPE_ao_stalled_by_acc_ib = 10'h046,
    PMEVTYPER3_EV_TYPE_ao_stalled_by_acc = 10'h047,
    PMEVTYPER3_EV_TYPE_ao_stalled_by_ib = 10'h048,
    PMEVTYPER3_EV_TYPE_wd_active = 10'h050,
    PMEVTYPER3_EV_TYPE_wd_stalled = 10'h051,
    PMEVTYPER3_EV_TYPE_wd_stalled_by_ws = 10'h052,
    PMEVTYPER3_EV_TYPE_wd_stalled_by_wd_buf = 10'h053,
    PMEVTYPER3_EV_TYPE_wd_parse_active = 10'h054,
    PMEVTYPER3_EV_TYPE_wd_parse_stalled = 10'h055,
    PMEVTYPER3_EV_TYPE_wd_parse_stalled_in = 10'h056,
    PMEVTYPER3_EV_TYPE_wd_parse_stalled_out = 10'h057,
    PMEVTYPER3_EV_TYPE_wd_trans_ws = 10'h058,
    PMEVTYPER3_EV_TYPE_wd_trans_wb = 10'h059,
    PMEVTYPER3_EV_TYPE_wd_trans_dw0 = 10'h05a,
    PMEVTYPER3_EV_TYPE_wd_trans_dw1 = 10'h05b,
    PMEVTYPER3_EV_TYPE_axi0_rd_trans_accepted = 10'h080,
    PMEVTYPER3_EV_TYPE_axi0_rd_trans_completed = 10'h081,
    PMEVTYPER3_EV_TYPE_axi0_rd_data_beat_received = 10'h082,
    PMEVTYPER3_EV_TYPE_axi0_rd_tran_req_stalled = 10'h083,
    PMEVTYPER3_EV_TYPE_axi0_wr_trans_accepted = 10'h084,
    PMEVTYPER3_EV_TYPE_axi0_wr_trans_completed_m = 10'h085,
    PMEVTYPER3_EV_TYPE_axi0_wr_trans_completed_s = 10'h086,
    PMEVTYPER3_EV_TYPE_axi0_wr_data_beat_written = 10'h087,
    PMEVTYPER3_EV_TYPE_axi0_wr_tran_req_stalled = 10'h088,
    PMEVTYPER3_EV_TYPE_axi0_wr_data_beat_stalled = 10'h089,
    PMEVTYPER3_EV_TYPE_axi0_enabled_cycles = 10'h08c,
    PMEVTYPER3_EV_TYPE_axi0_rd_stall_limit = 10'h08e,
    PMEVTYPER3_EV_TYPE_axi0_wr_stall_limit = 10'h08f,
    PMEVTYPER3_EV_TYPE_axi1_rd_trans_accepted = 10'h180,
    PMEVTYPER3_EV_TYPE_axi1_rd_trans_completed = 10'h181,
    PMEVTYPER3_EV_TYPE_axi1_rd_data_beat_received = 10'h182,
    PMEVTYPER3_EV_TYPE_axi1_rd_tran_req_stalled = 10'h183,
    PMEVTYPER3_EV_TYPE_axi1_wr_trans_accepted = 10'h184,
    PMEVTYPER3_EV_TYPE_axi1_wr_trans_completed_m = 10'h185,
    PMEVTYPER3_EV_TYPE_axi1_wr_trans_completed_s = 10'h186,
    PMEVTYPER3_EV_TYPE_axi1_wr_data_beat_written = 10'h187,
    PMEVTYPER3_EV_TYPE_axi1_wr_tran_req_stalled = 10'h188,
    PMEVTYPER3_EV_TYPE_axi1_wr_data_beat_stalled = 10'h189,
    PMEVTYPER3_EV_TYPE_axi1_enabled_cycles = 10'h18c,
    PMEVTYPER3_EV_TYPE_axi1_rd_stall_limit = 10'h18e,
    PMEVTYPER3_EV_TYPE_axi1_wr_stall_limit = 10'h18f,
    PMEVTYPER3_EV_TYPE_axi_latency_any = 10'h0a0,
    PMEVTYPER3_EV_TYPE_axi_latency_32 = 10'h0a1,
    PMEVTYPER3_EV_TYPE_axi_latency_64 = 10'h0a2,
    PMEVTYPER3_EV_TYPE_axi_latency_128 = 10'h0a3,
    PMEVTYPER3_EV_TYPE_axi_latency_256 = 10'h0a4,
    PMEVTYPER3_EV_TYPE_axi_latency_512 = 10'h0a5,
    PMEVTYPER3_EV_TYPE_axi_latency_1024 = 10'h0a6,
    PMEVTYPER3_EV_TYPE_ecc_dma = 10'h0b0,
    PMEVTYPER3_EV_TYPE_ecc_sb0 = 10'h0b1,
    PMEVTYPER3_EV_TYPE_ecc_sb1 = 10'h1b1,
    PMEVTYPER3_EV_TYPE_X = 10'hx
  } pmevtyper3_ev_type_t;




  localparam CMD_DATA_W = 32;

  localparam BASEP_CNT = 8;

  localparam REGION_CNT = 8;

  typedef logic [63:0] basep_t;

  typedef basep_t conf_basep_t [BASEP_CNT-1:0];

  typedef logic [1:0] region_t;

  typedef region_t conf_regioncfg_t [REGION_CNT-1:0];

  typedef logic [63:0] qbase_t;

  typedef struct packed {
    qsize_t    qsize;
    qbase_t    qbase;
    qconfig_t  qconfig;
  } cmd_q_t;

  typedef struct packed {
    logic                  write;
    logic [31:0]           wdata;
    logic                  page;
    logic [APB_ADDR_W-1:0] address;
    logic                  slverr;
    logic                  reset_initiated;
    logic                  state;
    logic                  ready;
  } apb_access_t;

  typedef enum logic [3:0] {
    OP_CONV           = 4'd0,
    OP_DEPTHWISE      = 4'd1,
    OP_POOL_MAX       = 4'd2,
    OP_POOL_AVG       = 4'd3,
    OP_REDUCE_SUM     = 4'd4,
    OP_MUL            = 4'd5,
    OP_ADD            = 4'd6,
    OP_SUB            = 4'd7,
    OP_MIN            = 4'd8,
    OP_MAX            = 4'd9,
    OP_PRELU          = 4'd10,
    OP_ABS            = 4'd11,
    OP_CLZ            = 4'd12,
    OP_SHR            = 4'd13,
    OP_SHL            = 4'd14,
    OP_UNUSED_15      = 4'd15
  } operation_t;

  localparam IFM_PRECISION_W  = 2;
  localparam IFM_SCALE_MODE_W = 2;
  localparam FM_FORMAT_W      = 2;

  typedef enum logic [FM_FORMAT_W-1:0] {
    FM_FORMAT_NHWC     = 2'd0,
    FM_FORMAT_BRICK    = 2'd1,
    FM_FORMAT_UNUSED_2    = 2'd2,
    FM_FORMAT_UNUSED_3    = 2'd3
  } fm_format_t;

  typedef enum logic [IFM_PRECISION_W-1:0] {
    IFM_PRECISION_W8_I8       = 'd0,
    IFM_PRECISION_W8_I16      = 'd1,
    IFM_PRECISION_W8_I32      = 'd2,
    IFM_PRECISION_UNUSED_3    = 'd3
  } ifm_precision_t;

  typedef enum logic [IFM_SCALE_MODE_W-1:0] {
    IFM_SCALE_MODE_16         = 2'd0,
    IFM_SCALE_MODE_OPA        = 2'd1,
    IFM_SCALE_MODE_OPB        = 2'd2
  } ifm_scale_mode_t;

  localparam IFM_ROUNDING_PREC_W     = 2;

  typedef enum logic [IFM_ROUNDING_PREC_W-1:0] {
    IFM_ROUNDING_TFL          = 2'd0,
    IFM_ROUNDING_NATURAL      = 2'd2
  } ifm_rounding_t;


  localparam OFM_PRECISION_W  = 2;

  typedef enum logic [OFM_PRECISION_W-1:0] {
    OFM_PRECISION_U8          = 'd0,
    OFM_PRECISION_U16         = 'd1,
    OFM_PRECISION_U32         = 'd2,
    OFM_PRECISION_UNUSED_3    = 'd3
  } ofm_precision_t;

  localparam OFM_ROUNDING_PREC_W     = 2;

  typedef enum logic [OFM_ROUNDING_PREC_W-1:0] {
    OFM_ROUNDING_TFL = 2'd0,
    OFM_ROUNDING_TO_ZERO = 2'd1,
    OFM_ROUNDING_NATURAL = 2'd2
  } ofm_rounding_t;

  localparam ACTIVATION_W = 5;
  localparam ACTIVATION_FUNC_W = 5;

  typedef enum logic [ACTIVATION_FUNC_W-1:0] {
    ACTIVATION_NONE    = 5'd0,
    ACTIVATION_TANH    = 5'd3,
    ACTIVATION_SIGMOID = 5'd4,
    ACTIVATION_LUT_16 = 5'd16,
    ACTIVATION_LUT_17 = 5'd17,
    ACTIVATION_LUT_18 = 5'd18,
    ACTIVATION_LUT_19 = 5'd19,
    ACTIVATION_LUT_20 = 5'd20,
    ACTIVATION_LUT_21 = 5'd21,
    ACTIVATION_LUT_22 = 5'd22,
    ACTIVATION_LUT_23 = 5'd23
  } activation_t;

  localparam ACTIVATION_CLIP_W = 4;
  typedef enum logic [ACTIVATION_CLIP_W-1:0] {
     CLIP_RANGE_OFM_PRECISION  = 4'd0,
     CLIP_RANGE_FORCE_UINT8    = 4'd2,
     CLIP_RANGE_FORCE_INT8     = 4'd3,
     CLIP_RANGE_FORCE_INT16    = 4'd5
  } activation_clip_t;

  localparam RESAMPLING_W = 2;

  typedef enum logic [RESAMPLING_W-1:0] {
    RESAMPLING_NONE      = 2'd0,
    RESAMPLING_NEAREST   = 2'd1,
    RESAMPLING_TRANSPOSE = 2'd2
  } resampling_t;

  localparam ACC_FORMAT_W = 2;

  typedef enum logic [ACC_FORMAT_W-1:0] {
    ACC_FORMAT_I32      = 2'd0,
    ACC_FORMAT_I40      = 2'd1,
    ACC_FORMAT_F16      = 2'd2,
    ACC_FORMAT_UNUSED_3 = 2'd3
  } acc_format_t;

  localparam WEIGHT_ORDER_W = 1;

  typedef enum logic [WEIGHT_ORDER_W-1:0] {
    WEIGHT_DEPTH  = 1'd0,
    WEIGHT_KERNEL = 1'd1
  } weight_order_t;

localparam KERNEL_DECOMP_W = 1;

  typedef enum logic [KERNEL_DECOMP_W-1:0] {
    KERNEL_DECOMP_8X8 = 1'd0,
    KERNEL_DECOMP_4X4 = 1'd1
  } kernel_decomp_t;


  localparam BATCH_SIZE_W            = 3;
  localparam OFM_WIDTH_W             = 16;
  localparam OFM_HEIGHT_W            = 16;
  localparam OFM_DEPTH_W             = 16;
  localparam IFM_DEPTH_W             = 16;
  localparam KERNEL_WIDTH_W          = 16;
  localparam KERNEL_HEIGHT_W         = 16;
  localparam KERNEL_X_STRIDE_W       = 2;
  localparam KERNEL_Y_STRIDE_W       = 2;
  localparam IFM_TILE_WIDTH_W        = OFM_WIDTH_W;
  localparam IFM_TILE_HEIGHT_W       = OFM_HEIGHT_W;
  localparam OFM_TILE_WIDTH_W        = OFM_WIDTH_W;
  localparam OFM_TILE_HEIGHT_W       = OFM_HEIGHT_W;
  localparam WEIGHT_LENGTH_W         = 32;
  localparam SCALE_LENGTH_W          = 20;
  localparam OFM_SCALE_W             = 32;
  localparam OFM_SHIFT_W             = 6;
  localparam OPA_SCALE_W             = 32;
  localparam OPA_SHIFT_W             = 6;
  localparam OPB_SCALE_W             = 16;
  localparam MAX_OFM_BLOCK_WIDTH     = 64;
  localparam OFM_BLOCK_WIDTH_W       = $clog2(MAX_OFM_BLOCK_WIDTH);
  localparam MAX_OFM_BLOCK_HEIGHT    = 32;
  localparam OFM_BLOCK_HEIGHT_W      = $clog2(MAX_OFM_BLOCK_HEIGHT);
  localparam MAX_OFM_BLOCK_DEPTH     = 128;
  localparam OFM_BLOCK_DEPTH_W       = $clog2(MAX_OFM_BLOCK_DEPTH);
  localparam OFM_BLOCK_WIDTH_UBLK_W  = 6;
  localparam OFM_BLOCK_HEIGHT_UBLK_W = 5;
  localparam OFM_BLOCK_DEPTH_UBLK_W  = 5;
  localparam OFM_STRIDE_X_W          = 32;
  localparam OFM_STRIDE_Y_W          = 32;
  localparam OFM_STRIDE_C_W          = 32;
  localparam IFM_STRIDE_X_W          = 32;
  localparam IFM_STRIDE_Y_W          = 32;
  localparam IFM_STRIDE_C_W          = 32;
  localparam IFM_BASE_ADDR_W         = 32;
  localparam OFM_BASE_ADDR_W         = 32;
  localparam WEIGHT_BASE_ADDR_W      = 32;
  localparam SCALE_BASE_ADDR_W       = 32;
  localparam STRIDE_SKIP_W           = 32;
  localparam M2M_LENGTH_W            = 32;
  localparam IFM_PAD_TOP_W           = 7;
  localparam IFM_PAD_LEFT_W          = 7;
  localparam IFM_PAD_RIGHT_W         = 8;
  localparam IFM_PAD_BOTTOM_W        = 8;
  localparam IFM_ZERO_POINT_W        = 16;
  localparam OFM_ZERO_POINT_W        = 16;
  localparam ACTIVATION_MIN_W        = 16;
  localparam ACTIVATION_MAX_W        = 16;
  localparam REGION_IDX_W            = $clog2(REGION_CNT);
  localparam M2M_DMA_REGION_W        = 9;
  localparam BLOCKDEP_W              = 2;
  localparam IFM2_BROADCAST_W        = 3;
  localparam IFM2_BROADCAST_OPSWAP   = 6;
  localparam IFM2_BROADCAST_SCALAR   = 7;
  localparam IFM2_SCALAR_W           = 16;
  localparam IFM2_ZERO_POINT_W       = 16;
  localparam KERNEL_WAIT_OP_W        = 2;
  localparam STRIDE_MODE_W           = 2;
  localparam STRIDE_SIZE_W           = 16;

  typedef struct packed {
    logic [OFM_WIDTH_W-1:0]             ofm_width_m1;
    logic [OFM_HEIGHT_W-1:0]            ofm_height_m1;
    logic [OFM_DEPTH_W-1:0]             ofm_depth_m1;
    logic [IFM_DEPTH_W-1:0]             ifm_depth_m1;

    logic [KERNEL_WIDTH_W-1:0]          kernel_width_m1;
    logic [KERNEL_HEIGHT_W-1:0]         kernel_height_m1;
    kernel_decomp_t                     kernel_split_size;
    logic                               kernel_x_dilation;
    logic                               kernel_y_dilation;
    logic [KERNEL_X_STRIDE_W-1:0]       kernel_x_stride_m1;
    logic [KERNEL_Y_STRIDE_W-1:0]       kernel_y_stride_m1;
    weight_order_t                      kernel_weight_order;
    operation_t                         operation;

    logic [IFM_BASE_ADDR_W-1:0]         ifm_base0;
    logic [IFM_BASE_ADDR_W-1:0]         ifm_base1;
    logic [IFM_BASE_ADDR_W-1:0]         ifm_base2;
    logic [IFM_BASE_ADDR_W-1:0]         ifm_base3;
    logic [IFM_TILE_WIDTH_W-1:0]        ifm_width0_m1;
    logic [IFM_TILE_HEIGHT_W-1:0]       ifm_height0_m1;
    logic [IFM_TILE_HEIGHT_W-1:0]       ifm_height1_m1;
    logic [OFM_BASE_ADDR_W-1:0]         ofm_base0;
    logic [OFM_BASE_ADDR_W-1:0]         ofm_base1;
    logic [OFM_BASE_ADDR_W-1:0]         ofm_base2;
    logic [OFM_BASE_ADDR_W-1:0]         ofm_base3;
    logic [OFM_TILE_WIDTH_W-1:0]        ofm_width0_m1;
    logic [OFM_TILE_HEIGHT_W-1:0]       ofm_height0_m1;
    logic [OFM_TILE_HEIGHT_W-1:0]       ofm_height1_m1;
    logic [WEIGHT_BASE_ADDR_W-1:0]      weight_base;
    logic [WEIGHT_LENGTH_W-1:0]         weight_length;
    logic [SCALE_BASE_ADDR_W-1:0]       scale_base;
    logic [SCALE_LENGTH_W-1:0]          scale_length;
    logic [OFM_SCALE_W-1:0]             ofm_scale;
    logic [OFM_SHIFT_W-1:0]             ofm_shift;
    logic [OPA_SCALE_W-1:0]             opa_scale;
    logic [OPA_SHIFT_W-1:0]             opa_shift;
    logic [OPB_SCALE_W-1:0]             opb_scale;

    logic [SBLB_SEL_MAX_ADDR_W-1:0]     ifm_ib_end;

    logic [OFM_BLOCK_WIDTH_UBLK_W-1:0]  ofm_block_width_ublk_m1;
    logic [OFM_BLOCK_HEIGHT_UBLK_W-1:0] ofm_block_height_ublk_m1;
    logic [OFM_BLOCK_DEPTH_UBLK_W-1:0]  ofm_block_depth_ublk_m1;

    logic [OFM_STRIDE_X_W-1:0]          ofm_stride_x;
    logic [OFM_STRIDE_Y_W-1:0]          ofm_stride_y;
    logic [OFM_STRIDE_C_W-1:0]          ofm_stride_c;
    logic [IFM_STRIDE_X_W-1:0]          ifm_stride_x;
    logic [IFM_STRIDE_Y_W-1:0]          ifm_stride_y;
    logic [IFM_STRIDE_C_W-1:0]          ifm_stride_c;

    logic [IFM_PAD_TOP_W-1:0]           ifm_pad_top;
    logic [IFM_PAD_LEFT_W-1:0]          ifm_pad_left;
    logic [IFM_PAD_RIGHT_W-1:0]         ifm_pad_right;
    logic [IFM_PAD_BOTTOM_W-1:0]        ifm_pad_bottom;

    ifm_rounding_t                      ifm_rounding_mode;
    ifm_scale_mode_t                    ifm_scale_mode;
    ifm_precision_t                     ifm_precision_bits;
    logic                               ifm_precision_sign;
    fm_format_t                         ifm_format;
    fm_format_t                         ifm2_format;
    ofm_precision_t                     ofm_precision_bits;
    logic                               ofm_precision_sign;
    fm_format_t                         ofm_format;
    logic                               ofm_scale_global;
    ofm_rounding_t                      ofm_rounding_mode;
    logic [IFM_ZERO_POINT_W-1:0]        ifm_zero_point;
    logic [OFM_ZERO_POINT_W-1:0]        ofm_zero_point;

    activation_t                        activation;
    activation_clip_t                   clip_range;

    logic [ACTIVATION_MIN_W-1:0]        activation_min;
    logic [ACTIVATION_MAX_W-1:0]        activation_max;

    resampling_t                        ifm_resampling;
    acc_format_t                        acc_format;

    logic [REGION_IDX_W-1:0]            ifm_region;
    logic [REGION_IDX_W-1:0]            ofm_region;
    logic [REGION_IDX_W-1:0]            weight_region;
    logic [REGION_IDX_W-1:0]            scale_region;

    logic [SBLB_SEL_MAX_ADDR_W-1:0]     ab_start;
    logic [BLOCKDEP_W-1:0]              blockdep;

    logic [IFM2_BROADCAST_W-1:0]        ifm2_broadcast;
    logic                               ifm2_bc_scalar;
    logic                               ifm2_bc_opswap;
    logic [IFM2_SCALAR_W-1:0]           ifm2_scalar;
    logic [IFM2_ZERO_POINT_W-1:0]       ifm2_zero_point;
    logic [SBLB_SEL_MAX_ADDR_W-1:0]     ifm2_ib_start;
    logic [IFM_TILE_WIDTH_W-1:0]        ifm2_width0_m1;
    logic [IFM_TILE_HEIGHT_W-1:0]       ifm2_height0_m1;
    logic [IFM_TILE_HEIGHT_W-1:0]       ifm2_height1_m1;
    logic [IFM_BASE_ADDR_W-1:0]         ifm2_base0;
    logic [IFM_BASE_ADDR_W-1:0]         ifm2_base1;
    logic [IFM_BASE_ADDR_W-1:0]         ifm2_base2;
    logic [IFM_BASE_ADDR_W-1:0]         ifm2_base3;
    logic [IFM_STRIDE_X_W-1:0]          ifm2_stride_x;
    logic [IFM_STRIDE_Y_W-1:0]          ifm2_stride_y;
    logic [IFM_STRIDE_C_W-1:0]          ifm2_stride_c;
    logic [REGION_IDX_W-1:0]            ifm2_region;
  } stripe_config_t;



  typedef enum logic [1:0] {
    KERNEL_SEQ_FIRST          = 2'd0,
    KERNEL_SEQ_MIDDLE         = 2'd1,
    KERNEL_SEQ_LAST           = 2'd2,
    KERNEL_SEQ_FIRST_AND_LAST = 2'd3
  } kernel_seq_t;

  typedef enum logic [1:0] {
    BLOCK_SEQ_FIRST          = 2'd0,
    BLOCK_SEQ_MIDDLE         = 2'd1,
    BLOCK_SEQ_LAST           = 2'd2,
    BLOCK_SEQ_FIRST_AND_LAST = 2'd3
  } block_seq_t;

  localparam BLK_KERNEL_WIDTH_W      = 3;
  localparam BLK_KERNEL_HEIGHT_W     = 3;
  localparam MAX_IFM_BLOCK_WIDTH     = 197;
  localparam IFM_BLOCK_WIDTH_W       = $clog2(MAX_IFM_BLOCK_WIDTH + 1);
  localparam MAX_IFM_BLOCK_HEIGHT    = 101;
  localparam IFM_BLOCK_HEIGHT_W      = $clog2(MAX_IFM_BLOCK_HEIGHT + 1);
  localparam MAX_IFM_BLOCK_DEPTH     = MAX_OFM_BLOCK_DEPTH;
  localparam IFM_BLOCK_DEPTH_W       = $clog2(MAX_IFM_BLOCK_DEPTH);
  localparam IFM_CONV_BLOCK_DEPTH_W  = 5;
  localparam OFM_X_ELEM_W            = 16;
  localparam OFM_Y_ELEM_W            = 16;
  localparam OFM_Z_ELEM_W            = 16;
  localparam OFM_X_W                 = OFM_X_ELEM_W-0;
  localparam OFM_Y_W                 = OFM_Y_ELEM_W-0;
  localparam OFM_Z_W                 = OFM_Z_ELEM_W-2;
  localparam IFM_X_W                 = 16;
  localparam IFM_Y_W                 = 16;
  localparam IFM_Z_W                 = 16;

  typedef struct packed {
    logic [BLK_KERNEL_WIDTH_W-1:0]    kernel_width_m1;
    logic [BLK_KERNEL_HEIGHT_W-1:0]   kernel_height_m1;
    logic [OFM_BLOCK_WIDTH_W-1:0]     ofm_block_width_m1;
    logic [OFM_BLOCK_HEIGHT_W-1:0]    ofm_block_height_m1;
    logic [OFM_BLOCK_DEPTH_W-1:0]     ofm_block_depth_m1;
    logic [IFM_BLOCK_WIDTH_W-1:0]     ifm_block_width;
    logic [IFM_BLOCK_HEIGHT_W-1:0]    ifm_block_height;
    logic [IFM_BLOCK_DEPTH_W-1:0]     ifm_block_depth_m1;

    logic                             ifm_upscale_odd_x;
    logic                             ifm_upscale_odd_y;
    logic                             ifm_upscale_sub_x;
    logic                             ifm_upscale_sub_y;

    block_seq_t                       block_sequence;
    logic                             mac_acc_clr_enable;

    logic [OFM_X_W-1:0]               ofm_x_ublk;
    logic [OFM_Y_W-1:0]               ofm_y_ublk;
    logic [OFM_Z_W-1:0]               ofm_z_ublk;
    logic [IFM_X_W-1:0]               ifm_x;
    logic [IFM_Y_W-1:0]               ifm_y;

    logic [IFM_Z_W-1:0]               ifm_z;

    logic [IFM_PAD_TOP_W-1:0]         pad_top;
    logic [IFM_PAD_LEFT_W-1:0]        pad_left;

    logic                             output_enable;
    logic                             ib_sel;
    logic                             ib_release;
    logic                             ib_mac_release;
    logic                             ifm2_sel;
  } block_config_t;

  typedef enum logic [1:0]
  {
    BEATS_64_BYTES   = 2'd0,
    BEATS_128_BYTES  = 2'd1,
    BEATS_256_BYTES  = 2'd2,
    BEATS_RESERVED_0 = 2'd3
  } axi_max_beats_t;

  typedef struct packed {
    axi_max_beats_t max_beats;
    logic [3:0]     memtype;
    logic [7:0]     max_outst_rd;
    logic [7:0]     max_outst_wr;
  } axi_config_elem_t;

  typedef axi_config_elem_t[MEMTYPE_CNT_NUM-1:0] axi_config_t;



  typedef struct packed
  {
    logic rd_tran_acc;
    logic rd_tran_compl;
    logic rd_data_beat_received;
    logic rd_tran_req_stalled;
    logic wr_tran_acc;
    logic wr_tran_compl_m;
    logic wr_tran_compl_s;
    logic wr_data_beat_written;
    logic wr_tran_req_stalled;
    logic wr_data_beat_stalled;
    logic axi_enabled_cycles;
    logic rd_stalled_limit;
    logic wr_stalled_limit;
  } axi_perf_event_t;

  typedef struct packed
  {
    logic sel_id_outst;
    axi_perf_event_t axi0_perf_event;
    axi_perf_event_t axi1_perf_event;
  } dma_perf_event_t;


  localparam PMCAXI_CH_W = 4;

  typedef struct packed
  {
    logic[PMCAXI_CH_W-1:0] pmcaxi_ch;
    region_t               pmcaxi_region;
    logic                  pmcaxi_ch_bw_en;
    logic                  pmu_events_en;
  } axi_pmu_cfg_t;

  typedef logic dma_ecc_event_t;
  typedef logic sb_ecc_event_t;


  typedef struct packed {
    logic       active;
    logic       stalled;
    logic       stalled_by_ws;
    logic       stalled_by_wd_buf;
    logic       parse_active;
    logic       parse_stall;
    logic       parse_stall_in;
    logic       parse_stall_out;
    logic       trans_ws;
    logic       trans_wb;
    logic       trans_dw0;
    logic       trans_dw1;
  } wd_perf_event_t;



  typedef struct packed {
    logic       active;
    logic       active_8b;
    logic       active_16b;
    logic       dpu_active;
    logic       stalled_by_w_or_acc;
    logic       stalled_by_w;
    logic       stalled_by_acc;
    logic       stalled_by_ib;
    logic       active_32b;
    logic       stalled_by_int_w;
    logic       stalled_by_int_acc;
  } mac_perf_event_t;



  typedef struct packed {
    logic       active;
    logic       active_8b;
    logic       active_16b;
    logic       stalled_by_ofmp_or_ob;
    logic       stalled_by_ofmp;
    logic       stalled_by_ob;
    logic       stalled_by_acc_or_ib;
    logic       stalled_by_acc;
    logic       stalled_by_ib;
  } ao_perf_event_t;


  typedef struct packed {
    logic       cc_block_disp_stalled_by_block_dep;
    logic       cc_stripe_disp_stalled_by_shram_reconf;
  } cc_perf_event_t;


  typedef enum logic [15:0] {
    APBSB_START = 16'h0400,
    APBSB_STOP = 16'h07FC,
    APBSB_X = 16'hxxxx
  } apbsb_addr_t;

  typedef enum logic [1:0] {
    S_SBDBG_IDLE        = 2'b00,
    S_SBDBG_READ        = 2'b01,
    S_SBDBG_WAIT        = 2'b10,
    S_SBDBG_WAIT_PCLKEN = 2'b11
  } apb_sb_state_t;



  typedef struct packed
  {
    logic               blk_cmd_valid;
    logic               blk_cmd_ready;
    logic               cmd_ofm_valid;
    logic               cmd_sbr_valid;
    logic               cmd_scl_valid;
    logic               cmd_ctl_valid;
    logic               cmd_act_valid;
    logic               cmd_sbw_valid;
  } ao_ctrl_status_t;

  typedef struct packed
  {
    ao_perf_event_t     events;
    ao_ctrl_status_t    ctrl;
  } ao_dbg_status_t;



  typedef struct packed
  {
    logic        block_cfg_valid;
  } mac_ctrl_status_t;

  typedef struct packed
  {
    logic        wait_for_acc1_ready;
    logic        wait_for_acc0_ready;
    logic        acc_buf_sel;
    logic        wait_for_dw1_ready;
    logic        wait_for_dw0_ready;
    logic        dw_sel;
    logic        stall_stripe;
    logic        wait_for_weights;
    logic        wait_for_acc_buf;
    logic        wait_for_ib;
    logic        trav_en;
  } mac_ai_status_t;

  typedef struct packed
  {
    logic        acc1_valid;
    logic        acc0_valid;
    logic        acc_buf_sel;
  } mac_adder_array_status_t;

  typedef struct packed
  {
    mac_perf_event_t          events;
    mac_adder_array_status_t  adder_array;
    mac_ai_status_t           ai;
    mac_ctrl_status_t         ctrl;
  } mac_dbg_status_t;



  typedef struct packed
  {
    logic [1:0]                   state;
    logic [1:0]                   idle;
    logic [WEIGHT_LENGTH_W-1:0]   ws_remain;
    logic [SB_DATA_W-1:0]         ws_last;
    logic [SB_DATA_W-1:0]         ws_checksum;
  } wd_ctrl_status_t;

  typedef struct packed
  {
    logic                         decode_fault;
    logic [1:0]                   state;
    logic                         idle;
  } wd_core_status_t;

  typedef struct packed
  {
    logic [2:0]                   index;
    logic                         valid;
    logic                         idle;
  } wd_wbuf_status_t;

  typedef struct packed
  {
    wd_perf_event_t               events;
    wd_ctrl_status_t              ctrl;
    wd_core_status_t              core;
    wd_wbuf_status_t [1:0]        wbuf;
  } wd_dbg_status_t;



  typedef enum logic [AXI_ID_CH_W:0]
  {
    FAULT_CMD = (AXI_ID_CH_W + 1)'(0),
    FAULT_IFM = (AXI_ID_CH_W + 1)'(1),
    FAULT_WGT = (AXI_ID_CH_W + 1)'(2),
    FAULT_BAS = (AXI_ID_CH_W + 1)'(3),
    FAULT_M2M_RD = (AXI_ID_CH_W + 1)'(4),
    FAULT_OFM = (AXI_ID_CH_W + 1)'(8),
    FAULT_M2M_WR = (AXI_ID_CH_W + 1)'(9)
  } fault_ch_t;

  typedef struct packed
  {
    logic       bus_fault;
    logic       faulting_interface;
    fault_ch_t  faulting_channel;
  } dma_bus_status_t;


  typedef struct packed
  {
    logic [AXI_ADDR_W-1:0]    ifm_src;
    logic [SB_MAX_ADDR_W-1:0] ifm_dst;
    logic [SB_MAX_ADDR_W-1:0] ofm_src;
    logic [AXI_ADDR_W-1:0]    ofm_dst;
    logic [AXI_ADDR_W-1:0]    cmd_src;
    qsize_t                   cmd_size;
    logic [AXI_ADDR_W-1:0]    m2m_src;
    logic [AXI_ADDR_W-1:0]    m2m_dst;
    logic [AXI_ADDR_W-1:0]    weight_src;
    logic [AXI_ADDR_W-1:0]    scale_src;
  } dma_ch_status_t;


endpackage: ethosu55_cc_reg_pkg
