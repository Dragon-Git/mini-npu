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

package ethosu55_cc_cmd_parser_pkg;

  typedef enum logic [2:0] {
                            CMD_Q_IDLE      = 3'h0,
                            CMD_Q_STOPPED   = 3'h1,
                            CMD_Q_FLUSH     = 3'h2,
                            CMD_Q_INIT      = 3'h3,
                            CMD_Q_RUNNING   = 3'h4,
                            CMD_Q_EXEC_STOP = 3'h5,
                            CMD_Q_UNUSED1   = 3'h6,
                            CMD_Q_UNUSED2   = 3'h7,
                            CMD_Q_X         = 3'hX
                            } cmd_q_state_t;

  typedef enum logic [2:0] {
                            CMD_IDLE                         = 3'h0,
                            CMD_HDR                          = 3'h1,
                            CMD_PAYL0                        = 3'h2,
                            CMD_WAIT_FOR_M2M_COMPLETE        = 3'h3,
                            CMD_WAIT_FOR_KERNEL_OPS_COMPLETE = 3'h4,
                            CMD_UNUSED_1                     = 3'h5,
                            CMD_UNUSED_2                     = 3'h6,
                            CMD_UNUSED_3                     = 3'h7,
                            CMD_X                            = 3'hX
                            } cmd_state_t;

  typedef enum logic [1:0] {
                            EXEC_IDLE       = 2'h0,
                            EXEC_STOP       = 2'h1,
                            EXEC_IRQ        = 2'h2,
                            EXEC_OPER       = 2'h3,
                            EXEC_X          = 2'hx
                            } exec_state_t;



  localparam CMD_CODE_ID_SIZE     = 10;
  localparam CMD_CODE_TYPE_SIZE   = 6;
  localparam CMD_PARAM_SIZE       = 16;

  typedef logic [CMD_CODE_ID_SIZE-1:0] cmd_code_id_t;

  typedef enum logic [CMD_CODE_TYPE_SIZE-1:0] {
                                               CMD0_TYPE     = 6'b00_0000,
                                               CMD1_32_TYPE  = 6'b01_0000,
                                               CMD1_64_TYPE  = 6'b10_0000
                                               } cmd_code_type_t;
  localparam CMD_ADDRATTR_REL = 13;
  localparam CMD_ADDRATTR_BP_IDX = 0;
  localparam CMD_ADDRATTR_BP_IDX_SZ = 3;
  localparam CMD_ADDRATTR_MEM_TYPE = 14;
  localparam CMD_ADDRATTR_MEM_TYPE_SZ = 2;

  typedef logic [CMD_PARAM_SIZE-1:0] cmd_param_t;

  typedef struct packed {
    cmd_param_t      param;
    cmd_code_type_t  code_type;
    cmd_code_id_t    code_id;
  } cmd_hdr_t;

  localparam CMD_CODE_W = 10;

  typedef struct packed {
    cmd_param_t             param;
    logic [1:0][31:0]       payload;
    logic [CMD_CODE_W-1:0]  cmd_code;
  } cmd_set_data_t;

  localparam CMD0_CODE_SET_BIT = 8;

  typedef enum logic [9:0] {
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_op_stop = 10'h000,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_op_irq = 10'h001,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_op_conv = 10'h002,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_op_depthwise = 10'h003,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_op_pool = 10'h005,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_op_elementwise = 10'h006,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_op_dma_start = 10'h010,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_op_dma_wait = 10'h011,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_op_kernel_wait = 10'h012,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_op_pmu_mask = 10'h013,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm_pad_top = 10'h100,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm_pad_left = 10'h101,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm_pad_right = 10'h102,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm_pad_bottom = 10'h103,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm_depth_m1 = 10'h104,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm_precision = 10'h105,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm_upscale = 10'h107,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm_zero_point = 10'h109,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm_width0_m1 = 10'h10a,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm_height0_m1 = 10'h10b,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm_height1_m1 = 10'h10c,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm_ib_end = 10'h10d,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm_region = 10'h10f,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ofm_width_m1 = 10'h111,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ofm_height_m1 = 10'h112,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ofm_depth_m1 = 10'h113,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ofm_precision = 10'h114,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ofm_blk_width_m1 = 10'h115,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ofm_blk_height_m1 = 10'h116,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ofm_blk_depth_m1 = 10'h117,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ofm_zero_point = 10'h118,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ofm_width0_m1 = 10'h11a,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ofm_height0_m1 = 10'h11b,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ofm_height1_m1 = 10'h11c,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ofm_region = 10'h11f,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_kernel_width_m1 = 10'h120,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_kernel_height_m1 = 10'h121,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_kernel_stride = 10'h122,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_parallel_mode = 10'h123,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_acc_format = 10'h124,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_activation = 10'h125,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_activation_min = 10'h126,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_activation_max = 10'h127,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_weight_region = 10'h128,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_scale_region = 10'h129,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ab_start = 10'h12d,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_blockdep = 10'h12f,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_dma0_src_region = 10'h130,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_dma0_dst_region = 10'h131,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_dma0_size0 = 10'h132,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_dma0_size1 = 10'h133,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm2_broadcast = 10'h180,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm2_scalar = 10'h181,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm2_precision = 10'h185,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm2_zero_point = 10'h189,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm2_width0_m1 = 10'h18a,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm2_height0_m1 = 10'h18b,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm2_height1_m1 = 10'h18c,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm2_ib_start = 10'h18d,
    COMMAND_NO_PAYLOAD_CMD_CODE_npu_set_ifm2_region = 10'h18f,
    COMMAND_NO_PAYLOAD_CMD_CODE_X = 10'hx
  } command_no_payload_cmd_code_t;

  typedef enum logic [9:0] {
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ifm_base0 = 10'h000,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ifm_base1 = 10'h001,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ifm_base2 = 10'h002,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ifm_base3 = 10'h003,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ifm_stride_x = 10'h004,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ifm_stride_y = 10'h005,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ifm_stride_c = 10'h006,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ofm_base0 = 10'h010,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ofm_base1 = 10'h011,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ofm_base2 = 10'h012,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ofm_base3 = 10'h013,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ofm_stride_x = 10'h014,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ofm_stride_y = 10'h015,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ofm_stride_c = 10'h016,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_weight_base = 10'h020,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_weight_length = 10'h021,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_scale_base = 10'h022,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_scale_length = 10'h023,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ofm_scale = 10'h024,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_opa_scale = 10'h025,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_opb_scale = 10'h026,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_dma0_src = 10'h030,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_dma0_dst = 10'h031,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_dma0_len = 10'h032,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_dma0_skip0 = 10'h033,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_dma0_skip1 = 10'h034,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ifm2_base0 = 10'h080,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ifm2_base1 = 10'h081,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ifm2_base2 = 10'h082,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ifm2_base3 = 10'h083,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ifm2_stride_x = 10'h084,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ifm2_stride_y = 10'h085,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_ifm2_stride_c = 10'h086,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_weight1_base = 10'h090,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_weight1_length = 10'h091,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_scale1_base = 10'h092,
    COMMAND_WITH_PAYLOAD_CMD_CODE_npu_set_scale1_length = 10'h093,
    COMMAND_WITH_PAYLOAD_CMD_CODE_X = 10'hx
  } command_with_payload_cmd_code_t;



endpackage: ethosu55_cc_cmd_parser_pkg
