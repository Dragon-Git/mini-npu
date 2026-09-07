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

package ethosu55_pkg;

  localparam APB_ADDR_W = 12;

  localparam MAX_OUTSTANDING_READ  = 32;
  localparam MAX_OUTST_RD_LOG      = $clog2(MAX_OUTSTANDING_READ);

  function automatic int MAX_OUTSTANDING_WRITE
  (
    input integer axi_idx
  );
    case (axi_idx)
      0 : return 16;
      1 : return 32;
    endcase
  endfunction

  localparam MAX_OUTST_WR_LOG      = $clog2(16);
  localparam MEMTYPE_CNT_AXI       = 2;
  localparam MEMTYPE_CNT_AXI_LOG   = $clog2(MEMTYPE_CNT_AXI);
  localparam MEMTYPE_CNT_NUM       = 2*MEMTYPE_CNT_AXI;
  localparam MEMTYPE_CNT_NUM_LOG   = $clog2(MEMTYPE_CNT_NUM);

  localparam AXI_ID_CH_W = 3;
  localparam AXI_RID_W = 6;
  localparam AXI_WID_W = AXI_RID_W;
  localparam AXI_MAX_BURST_BYTES = 128;
  localparam NUM_M2M = 1;

  localparam AXI_LEN_W = 8;


  localparam NUM_MULT_PER_DPU = 8;

  localparam SB_BANK_DEPTH         = 256;
  localparam SB_LOGICAL_BANK_DEPTH = 'd128;

  localparam SB_BANK_WIDTH         = 64;
  localparam SB_BANK_WIDTH_BYTES   = (SB_BANK_WIDTH/8);

  localparam MAX_NUM_SB_BANKS = 24;
  localparam MAX_NUM_SB_ACC_PORTS = 5;

  localparam NUM_CORES_MAX           = 2;
  localparam NUM_CORES_MAX_W         = $clog2(NUM_CORES_MAX) + 1;
  localparam NUM_MACS_PER_CORE_MAX_W = $clog2(256) + 1;
  localparam CFG_VECTOR_W            = NUM_CORES_MAX_W + NUM_MACS_PER_CORE_MAX_W;

  typedef logic [CFG_VECTOR_W-1:0] npu_config_t;

  function automatic npu_config_t BUILD_CFG(input int num_cores, input int num_mac_units_per_core);
    BUILD_CFG = npu_config_t'({
                               NUM_CORES_MAX_W'(num_cores),
                               NUM_MACS_PER_CORE_MAX_W'(num_mac_units_per_core)
                               });
  endfunction

  function automatic int NUM_MACS_PER_CORE(input npu_config_t cfg);
    NUM_MACS_PER_CORE = int'(cfg[0 +: NUM_MACS_PER_CORE_MAX_W]);
  endfunction

  function automatic int NUM_CORES(input npu_config_t cfg);
    NUM_CORES = int'(cfg[NUM_MACS_PER_CORE_MAX_W +: NUM_CORES_MAX_W]);
  endfunction

  function automatic int NUM_DPUS(input npu_config_t cfg);
    case(NUM_MACS_PER_CORE(cfg))
      32'd32 : begin
        NUM_DPUS = 4;
      end
      32'd64 : begin
        NUM_DPUS = 8;
      end
      32'd128: begin
        NUM_DPUS = 16;
      end
      32'd256: begin
        NUM_DPUS = 32;
      end
    endcase
  endfunction


  localparam AXI_DATA_W     = 64;
  localparam AXI_ADDR_W     = 32;
  localparam AXI_SIZE_FULL  = 3'b011;
  localparam NUM_AXI_IFS    = 2;
  localparam NUM_AXI_WR_IFS = 1;



  localparam AXI_DATA_W_BYTES    = AXI_DATA_W / 8;
  localparam AXI_DATA_W_BYTES_LG = $clog2(AXI_DATA_W_BYTES);

  localparam MAX_BEATS_LG        = $clog2(128/AXI_DATA_W_BYTES);


  typedef enum logic [AXI_ID_CH_W - 1: 0]
  {
    AXI_RD_CMD_CH = 0,
    AXI_RD_IFM_CH = 1,
    AXI_RD_WGT_CH = 2,
    AXI_RD_BAS_CH = 3,
    AXI_RD_M2M_CH = 4,
    AXI_RD_WGT1_CH = 5,
    AXI_RD_BAS1_CH = 6
  } axi_rd_ch_t;

  function automatic int AXI_NUM_RD_CH(input npu_config_t cfg);
    return 3 + 2*NUM_CORES(cfg);
  endfunction


  localparam RB_CMD_IDS = 4;
  localparam RB_IFM_IDS = 26;
  localparam RB_WGT_IDS = 26;
  localparam RB_BAS_IDS = 4;
  localparam RB_M2M_IDS = 4;

  function automatic int AXI_RD_CH_NUM_ID
  (
    input npu_config_t cfg,
    input integer ch
  );
    axi_rd_ch_t i_case;
    i_case = axi_rd_ch_t'(ch);
    case(i_case)
      AXI_RD_CMD_CH  : return RB_CMD_IDS;
      AXI_RD_IFM_CH  : return RB_IFM_IDS;
      AXI_RD_WGT_CH  : return RB_WGT_IDS;
      AXI_RD_BAS_CH  : return RB_BAS_IDS;
      AXI_RD_M2M_CH  : return RB_M2M_IDS;
    endcase
  endfunction

  function automatic [AXI_ID_CH_W-1:0] AXI_RD_CH_FROM_ID
  (
    input npu_config_t cfg,
    input [AXI_RID_W-1:0] id
  );
    int                   sum;
    int                   tmp;

  begin
    sum = 0;
    for (integer ch=0; ch<AXI_NUM_RD_CH(cfg); ch++) begin
      sum = sum + AXI_RD_CH_NUM_ID(cfg, ch);
      if (sum > id) begin
        return ch[AXI_ID_CH_W-1:0];
      end
    end
    tmp = AXI_NUM_RD_CH(cfg)-1;
    return tmp[AXI_ID_CH_W-1:0];
  end
  endfunction

  localparam AXI_NUM_RD_FLOW = 3 + 2;
  localparam FLOW_DIST_CORE1 = 3;

  function automatic [AXI_ID_CH_W-1:0] AXI_RD_FLOW_FROM_ID
  (
    input npu_config_t cfg,
    input [AXI_RID_W-1:0] id
  );
    int                   sum;
    integer               ch;

  begin
    sum = 0;
    ch = 0;
    for (ch=0; ch<AXI_NUM_RD_CH(cfg); ch++) begin
      sum = sum + AXI_RD_CH_NUM_ID(cfg, ch);
      if (sum > id) begin
        break;
      end
    end
    if (ch > AXI_NUM_RD_FLOW-1) begin
      ch = ch - FLOW_DIST_CORE1;
    end
    return ch[AXI_ID_CH_W-1:0];
  end
  endfunction

  function automatic logic AXI_RD_CORE_FROM_ID
  (
    input npu_config_t cfg,
    input [AXI_RID_W-1:0] id
  );
    logic tmp;
  begin
    tmp = '0;
    if (id > AXI_RD_CH_NUM_ID(cfg, integer'({{32-$bits(axi_rd_ch_t){'0}}, AXI_RD_M2M_CH}))) begin
      tmp = '1;
    end
    return tmp;
  end
  endfunction



  function automatic int AXI_RD_CH_START_ID(input npu_config_t cfg, input integer ch);
  int sum;
  begin
    sum = 0;
    for (integer i=0; i<AXI_NUM_RD_CH(cfg); i++) begin
      if (i<ch) begin
        sum = sum + AXI_RD_CH_NUM_ID(cfg, i);
      end
    end
    return sum;
  end
  endfunction


  function automatic int AXI_RID_CNT(input npu_config_t cfg);
  int sum;
  begin
    sum = 0;
    for (integer i=0; i<AXI_NUM_RD_CH(cfg); i++) begin
      sum = sum + AXI_RD_CH_NUM_ID(cfg, i);
    end
    return sum;
  end
  endfunction

  function automatic int clogb2(input int depth);
    int result;
    result = 0;
    for (integer i = 0; 2 ** i < depth; i = i + 1) begin
      result = i + 1;
    end
    clogb2 = result;
  endfunction


  function automatic int NUM_SB_BANKS(input npu_config_t cfg);
    case(NUM_MACS_PER_CORE(cfg))
      32'd32 : begin
        NUM_SB_BANKS = 8;
      end
      32'd64 : begin
        NUM_SB_BANKS = 8;
      end
      32'd128: begin
        NUM_SB_BANKS = 12;
      end
      32'd256: begin
        NUM_SB_BANKS = 24;
      end
    endcase
  endfunction

  function automatic int NUM_SBR_AO(input npu_config_t cfg);
    case(NUM_MACS_PER_CORE(cfg))
      32'd32 : begin
        NUM_SBR_AO = 1;
      end
      32'd64 : begin
        NUM_SBR_AO = 2;
      end
      32'd128: begin
        NUM_SBR_AO = 3;
      end
      32'd256: begin
        NUM_SBR_AO = 5;
      end
    endcase
  endfunction

  function automatic int NUM_SB_IB_PORTS(input npu_config_t cfg);
    case(NUM_MACS_PER_CORE(cfg))
      32'd32 : begin
        NUM_SB_IB_PORTS = 1;
      end
      32'd64 : begin
        NUM_SB_IB_PORTS = 1;
      end
      32'd128: begin
        NUM_SB_IB_PORTS = 2;
      end
      32'd256: begin
        NUM_SB_IB_PORTS = 4;
      end
    endcase
  endfunction

  function automatic int NUM_SB_ACC_PORTS(input npu_config_t cfg);
    case(NUM_MACS_PER_CORE(cfg))
      32'd32 : begin
        NUM_SB_ACC_PORTS = 1;
      end
      32'd64 : begin
        NUM_SB_ACC_PORTS = 2;
      end
      32'd128: begin
        NUM_SB_ACC_PORTS = 3;
      end
      32'd256: begin
        NUM_SB_ACC_PORTS = 5;
      end
    endcase
  endfunction


  function automatic int UBLK_HEIGHT(input npu_config_t cfg);
    case(NUM_MACS_PER_CORE(cfg))
      32'd32 : begin
        UBLK_HEIGHT = 1;
      end
      32'd64 : begin
        UBLK_HEIGHT = 1;
      end
      32'd128: begin
        UBLK_HEIGHT = 1;
      end
      32'd256: begin
        UBLK_HEIGHT = 2;
      end
    endcase
  endfunction

  function automatic int UBLK_WIDTH(input npu_config_t cfg);
    case(NUM_MACS_PER_CORE(cfg))
      32'd32 : begin
        UBLK_WIDTH = 1;
      end
      32'd64 : begin
        UBLK_WIDTH = 1;
      end
      32'd128: begin
        UBLK_WIDTH = 2;
      end
      32'd256: begin
        UBLK_WIDTH = 2;
      end
    endcase
  endfunction

  function automatic int UBLK_DEPTH(input npu_config_t cfg);
    case(NUM_MACS_PER_CORE(cfg))
      32'd32 : begin
        UBLK_DEPTH = 4;
      end
      32'd64 : begin
        UBLK_DEPTH = 8;
      end
      32'd128: begin
        UBLK_DEPTH = 8;
      end
      32'd256: begin
        UBLK_DEPTH = 8;
      end
    endcase
  endfunction

  function automatic int UBLK_WIDTH_LG2(input npu_config_t cfg);
    UBLK_WIDTH_LG2 = clogb2(UBLK_WIDTH(cfg));
  endfunction

  function automatic int UBLK_HEIGHT_LG2(input npu_config_t cfg);
    UBLK_HEIGHT_LG2 = clogb2(UBLK_HEIGHT(cfg));
  endfunction

  function automatic int UBLK_DEPTH_LG2(input npu_config_t cfg);
    UBLK_DEPTH_LG2 = clogb2(UBLK_DEPTH(cfg));
  endfunction

  localparam UBLK_MIN_WIDTH_LG2  = $clog2(1);
  localparam UBLK_MIN_HEIGHT_LG2 = $clog2(1);
  localparam UBLK_MIN_DEPTH_LG2  = $clog2(4);


  function automatic int NUM_SB_LOGICAL_BANKS(input npu_config_t cfg);
    NUM_SB_LOGICAL_BANKS = NUM_SB_BANKS(cfg) * 2;
  endfunction

  function automatic int SBB_SEL_ADDR_W(input npu_config_t cfg);
    SBB_SEL_ADDR_W = clogb2(NUM_SB_BANKS(cfg));
  endfunction

  function automatic int SB_ADDR_W(input npu_config_t cfg);
    SB_ADDR_W = clogb2(NUM_SB_BANKS(cfg) * SB_BANK_DEPTH);
  endfunction

  function automatic int SBLB_SEL_ADDR_W(input npu_config_t cfg);
     SBLB_SEL_ADDR_W = clogb2(NUM_SB_LOGICAL_BANKS(cfg));
  endfunction

  localparam SBLB_SEL_MAX_ADDR_W = $clog2(MAX_NUM_SB_BANKS * 2);
  localparam SB_MAX_ADDR_W       = $clog2(MAX_NUM_SB_BANKS * SB_BANK_DEPTH);


  localparam SBB_ADDR_W       = $clog2(SB_BANK_DEPTH);
  localparam SBLB_ADDR_W      = $clog2(SB_LOGICAL_BANK_DEPTH);

  localparam SB_DATA_W        = SB_BANK_WIDTH;
  localparam SB_DATA_W_BYTES = SB_DATA_W/8;
  localparam SB_BANK_WIDTH_BYTES_LG2 = $clog2(SB_BANK_WIDTH_BYTES);

  function automatic int SHRAM_SIZE(input npu_config_t cfg);
    SHRAM_SIZE = (NUM_CORES(cfg) * NUM_SB_BANKS(cfg) * SB_BANK_DEPTH * SB_BANK_WIDTH) / (1024 * 8);
  endfunction

  localparam SB_OB_LOGICAL_BANK_OFFSET = 0;
  localparam SB_OB_BASE_ADDR = SB_LOGICAL_BANK_DEPTH * SB_OB_LOGICAL_BANK_OFFSET;
  localparam SB_OB_LENGTH = SB_LOGICAL_BANK_DEPTH;
  localparam SB_OB_LENGTH_W = $clog2(SB_OB_LENGTH+1);

  localparam SB_IB_LOGICAL_BANK_OFFSET = 2;
  localparam SB_IB_BASE_ADDR = SB_LOGICAL_BANK_DEPTH * SB_IB_LOGICAL_BANK_OFFSET;

  function automatic int LOG2_NUM_8X8_MACS_PER_CC(input npu_config_t cfg);
    LOG2_NUM_8X8_MACS_PER_CC = clogb2(NUM_CORES(cfg) * NUM_DPUS(cfg) * NUM_MULT_PER_DPU);
  endfunction

  localparam OFMP_DATA_W      = 64;


  function automatic int NUM_SB_RD_PORTS(input npu_config_t cfg);
    NUM_SB_RD_PORTS = NUM_SB_IB_PORTS(cfg) + NUM_SB_ACC_PORTS(cfg) + NUM_SBR_AO(cfg) + 1 +  1;
  endfunction

  function automatic int NUM_SB_WR_PORTS(input npu_config_t cfg);
    NUM_SB_WR_PORTS = NUM_SB_ACC_PORTS(cfg) + 1 + 1;
  endfunction


  localparam SB_RD_MAC_IB_OFFSET  = 0;

  function automatic int SB_RD_MAC_ACC_OFFSET(input npu_config_t cfg);
    SB_RD_MAC_ACC_OFFSET = NUM_SB_IB_PORTS(cfg);
  endfunction

  function automatic int SB_RD_AO_OFFSET(input npu_config_t cfg);
    SB_RD_AO_OFFSET = SB_RD_MAC_ACC_OFFSET(cfg) + NUM_SB_ACC_PORTS(cfg);
  endfunction

  function automatic int SB_RD_AO_LUT_OFFSET(input npu_config_t cfg);
    SB_RD_AO_LUT_OFFSET = SB_RD_AO_OFFSET(cfg) + NUM_SBR_AO(cfg);
  endfunction

  function automatic int SB_RD_DMA_OFFSET(input npu_config_t cfg);
    SB_RD_DMA_OFFSET = SB_RD_AO_LUT_OFFSET(cfg) + 1;
  endfunction

  function automatic int SB_RD_WD_OFFSET(input npu_config_t cfg);
    SB_RD_WD_OFFSET = SB_RD_DMA_OFFSET(cfg) + 1;
  endfunction

  localparam SB_WR_MAC_OFFSET = 0;
  function automatic int SB_WR_AO_OFFSET(input npu_config_t cfg);
    SB_WR_AO_OFFSET = NUM_SB_ACC_PORTS(cfg);
  endfunction

  function automatic int SB_WR_DMA_OFFSET(input npu_config_t cfg);
    SB_WR_DMA_OFFSET = SB_WR_AO_OFFSET(cfg) + 1;
  endfunction

  function automatic int SB_RD_ID_W(input npu_config_t cfg);
    SB_RD_ID_W = clogb2(NUM_SB_RD_PORTS(cfg));
  endfunction

  function automatic int SB_WR_ID_W(input npu_config_t cfg);
    SB_WR_ID_W = clogb2(NUM_SB_WR_PORTS(cfg));
  endfunction

  function automatic int SB_BANK_ID_W(input npu_config_t cfg);
    SB_BANK_ID_W = clogb2(NUM_SB_BANKS(cfg));
  endfunction

  localparam NUM_SB_BANKS_32 = NUM_SB_BANKS(BUILD_CFG(1, 32));
  localparam NUM_SB_BANKS_64 = NUM_SB_BANKS(BUILD_CFG(1, 64));
  localparam NUM_SB_BANKS_128 = NUM_SB_BANKS(BUILD_CFG(1, 128));
  localparam NUM_SB_BANKS_256 = NUM_SB_BANKS(BUILD_CFG(1, 256));

  function automatic logic [MAX_NUM_SB_BANKS-1:0] SB_VALID_MAC_IB_PORTS(input npu_config_t cfg);
    SB_VALID_MAC_IB_PORTS = '1;
    SB_VALID_MAC_IB_PORTS[0] = 1'b0;
    case(NUM_MACS_PER_CORE(cfg))
      32'd32 : begin
        SB_VALID_MAC_IB_PORTS[NUM_SB_BANKS_32-1:NUM_SB_BANKS_32-2] = '0;
      end
      32'd64 : begin
        SB_VALID_MAC_IB_PORTS[NUM_SB_BANKS_64-1:NUM_SB_BANKS_64-2] = '0;
      end
      32'd128: begin
        SB_VALID_MAC_IB_PORTS[NUM_SB_BANKS_128-1:NUM_SB_BANKS_128-2-1] = '0;
      end
      32'd256: begin
        SB_VALID_MAC_IB_PORTS[NUM_SB_BANKS_256-1:NUM_SB_BANKS_256-4-3] = '0;
      end
    endcase
  endfunction


  function automatic logic [MAX_NUM_SB_ACC_PORTS*MAX_NUM_SB_BANKS-1:0] SB_VALID_MAC_ACC_PORTS(input npu_config_t cfg);

    logic [MAX_NUM_SB_ACC_PORTS-1:0][MAX_NUM_SB_BANKS-1:0] v_masks;

    v_masks[0] = '1;
    v_masks[1] = '1;
    v_masks[2] = '1;
    v_masks[3] = '1;
    v_masks[4] = '1;
    case(NUM_MACS_PER_CORE(cfg))
      32'd32 : begin
        v_masks[0][7:0] = 8'b11111100;
      end
      32'd64 : begin
        v_masks[0][7:0] = 8'b11111100;
        v_masks[1][7:0] = 8'b11111000;
      end
      32'd128: begin
        v_masks[0][11:0] = 12'b011111111000;
        v_masks[1][11:0] = 12'b011111100000;
        v_masks[2][11:0] = 12'b011111100000;
      end
      32'd256: begin
        v_masks[0][23:0] = 24'b000110011111100110000000;
        v_masks[1][23:0] = 24'b011001111110011000000000;
        v_masks[2][23:0] = 24'b000111100001100000000000;
        v_masks[3][23:0] = 24'b011110000110000000000000;
        v_masks[4][23:0] = 24'b011000000000000000000000;
      end
    endcase
    SB_VALID_MAC_ACC_PORTS = v_masks;

  endfunction

  function automatic logic [MAX_NUM_SB_ACC_PORTS*MAX_NUM_SB_BANKS-1:0] SB_VALID_AO_RD_PORTS(input npu_config_t cfg);

    logic [MAX_NUM_SB_ACC_PORTS-1:0][MAX_NUM_SB_BANKS-1:0] v_masks;

    v_masks = SB_VALID_MAC_ACC_PORTS(cfg);

    case(NUM_MACS_PER_CORE(cfg))
      32'd32 : begin
        v_masks[0][7:0] = v_masks[0][7:0] | 8'b11111110;
      end
      32'd64 : begin
        v_masks[0][7:0] = v_masks[0][7:0] | 8'b11111110;
      end
      32'd128: begin
        v_masks[0][11:0] = v_masks[0][11:0] | 12'b011111111110;
      end
      32'd256: begin
        v_masks[0][23:0] = v_masks[0][23:0] | 24'b000111111111111111111110;
      end
    endcase
    SB_VALID_AO_RD_PORTS = v_masks;

  endfunction

  localparam SB_VALID_AO_WR_PORTS = {{(MAX_NUM_SB_BANKS-1){1'b0}}, 1'b1};

  function automatic logic [MAX_NUM_SB_BANKS-1:0] SB_VALID_AO_LUT_RD_PORT(input npu_config_t cfg);
    SB_VALID_AO_LUT_RD_PORT = '0;
    case(NUM_MACS_PER_CORE(cfg))
      32'd32 : begin
        SB_VALID_AO_LUT_RD_PORT[NUM_SB_BANKS_32-1] = 1'b1;
      end
      32'd64 : begin
        SB_VALID_AO_LUT_RD_PORT[NUM_SB_BANKS_64-1] = 1'b1;
      end
      32'd128: begin
        SB_VALID_AO_LUT_RD_PORT[NUM_SB_BANKS_128-1] = 1'b1;
      end
      32'd256: begin
        SB_VALID_AO_LUT_RD_PORT[NUM_SB_BANKS_256-1] = 1'b1;
      end
    endcase
  endfunction



  function automatic int NUM_SCALE_UNIT(input npu_config_t cfg);
    NUM_SCALE_UNIT =
                    NUM_MACS_PER_CORE(cfg) == 32'd 32 ? 1 :
                    NUM_MACS_PER_CORE(cfg) == 32'd 64 ? 2 :
                    NUM_MACS_PER_CORE(cfg) == 32'd128 ? 4 :
                    NUM_MACS_PER_CORE(cfg) == 32'd256 ? 8 :
                    8;
  endfunction

  function automatic int NUM_OUTPUT_ELEM(input npu_config_t cfg);
    NUM_OUTPUT_ELEM =
                     NUM_MACS_PER_CORE(cfg) == 32'd 32 ? 1 :
                     NUM_MACS_PER_CORE(cfg) == 32'd 64 ? 1 :
                     NUM_MACS_PER_CORE(cfg) == 32'd128 ? 2 :
                     NUM_MACS_PER_CORE(cfg) == 32'd256 ? 4 :
                     4;
  endfunction


  function automatic int NUM_DPU_SETS(input npu_config_t cfg);
    NUM_DPU_SETS = UBLK_WIDTH(cfg) * UBLK_HEIGHT(cfg);
  endfunction

  function automatic int NUM_DPUS_PER_SET(input npu_config_t cfg);
    NUM_DPUS_PER_SET = UBLK_DEPTH(cfg);
  endfunction

  localparam NUM_ACC_SETS     = 4;

  function automatic int NUM_MAC_ADDERS(input npu_config_t cfg);
    NUM_MAC_ADDERS = NUM_DPUS(cfg)/NUM_ACC_SETS;
  endfunction

  function automatic int NUM_SB_IB_PORTS_W(input npu_config_t cfg);
    NUM_SB_IB_PORTS_W = clogb2(NUM_SB_IB_PORTS(cfg));
  endfunction

endpackage: ethosu55_pkg
