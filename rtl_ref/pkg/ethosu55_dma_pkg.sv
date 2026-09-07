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

package ethosu55_dma_pkg;
  import ethosu55_pkg::*;
  import ethosu55_cc_reg_pkg::*;
  import ethosu55_cc_tsu_pkg::*;

  localparam CORE_0  = 0;
  localparam BRICK_0 = 0;
  localparam CORE_1  = 1;
  localparam BRICK_1 = 1;

  localparam GROUP_CHANNELS = 16;
  localparam GROUP_CHANNELS_W = $clog2(GROUP_CHANNELS);

  typedef enum logic [3:0]
  {
    MT_DEVICE_NON_BUFFERABLE                 = 4'b0000,
    MT_DEVICE_BUFFERABLE                     = 4'b0001,
    MT_NORMAL_NON_CACHEABLE_NON_BUFFERABLE   = 4'b0010,
    MT_NORMAL_NON_CACHEABLE_BUFFERABLE       = 4'b0011,
    MT_WRITE_THROUGH_NO_ALLOCATE             = 4'b0100,
    MT_WRITE_THROUGH_READ_ALLOCATE           = 4'b0101,
    MT_WRITE_THROUGH_WRITE_ALLOCATE          = 4'b0110,
    MT_WRITE_THROUGHREAD_AND_WRITE_ALLOCATE  = 4'b0111,
    MT_WRITE_BACK_NO_ALLOCATE                = 4'b1000,
    MT_WRITE_BACK_READ_ALLOCATE              = 4'b1001,
    MT_WRITE_BACK_WRITE_ALLOCATE             = 4'b1010,
    MT_WRITE_BACK_READ_AND_WRITE_ALLOCATE    = 4'b1011,
    MT_RESERVED0                             = 4'b1100,
    MT_RESERVED1                             = 4'b1101,
    MT_RESERVED2                             = 4'b1110,
    MT_RESERVED3                             = 4'b1111
  } memtype_t;

  typedef enum logic [3:0]
  {
    AXIR_DEVICE_NON_BUFFERABLE                 = 4'b0000,
    AXIR_DEVICE_BUFFERABLE                     = 4'b0001,
    AXIR_NORMAL_NON_CACHEABLE_NON_BUFFERABLE   = 4'b0010,
    AXIR_NORMAL_NON_CACHEABLE_BUFFERABLE       = 4'b0011,
    AXIR_WRITE_THROUGH_NO_ALLOCATE             = 4'b1010,
    AXIR_WRITE_THROUGH_READ_ALLOCATE           = 4'b1110,
    AXIR_WRITE_BACK_NO_ALLOCATE                = 4'b1011,
    AXIR_WRITE_BACK_READ_ALLOCATE              = 4'b1111,
    AXIR_X                                     = 4'bXXXX
  } axi_arcache_t;

  typedef enum logic [3:0]
  {
    AXIW_DEVICE_NON_BUFFERABLE                 = 4'b0000,
    AXIW_DEVICE_BUFFERABLE                     = 4'b0001,
    AXIW_NORMAL_NON_CACHEABLE_NON_BUFFERABLE   = 4'b0010,
    AXIW_NORMAL_NON_CACHEABLE_BUFFERABLE       = 4'b0011,
    AXIW_WRITE_THROUGH_NO_ALLOCATE             = 4'b0110,
    AXIW_WRITE_THROUGH_WRITE_ALLOCATE          = 4'b1110,
    AXIW_WRITE_BACK_NO_ALLOCATE                = 4'b0111,
    AXIW_WRITE_BACK_WRITE_ALLOCATE             = 4'b1111,
    AXIW_X                                     = 4'bXXXX
  } axi_awcache_t;

  localparam NUM_WRITE_MASTER = 2;
  localparam NUM_WRITE_MASTER_LOG = 1;

  typedef logic [NUM_WRITE_MASTER_LOG-1:0] write_master_t;

  localparam AXI_WR_ID_LSB = 5;

  typedef enum logic [NUM_WRITE_MASTER_LOG - 1: 0]
  {
    AXI_WR_OFM_CH = 0,
    AXI_WR_M2M_CH = 1
  } axi_wr_ch_t;


  localparam SB_RAM_LATENCY = 3;
  typedef enum logic
  {
    SBW_IFM = 1'h0,
    SBW_M2M = 1'h1,
    SBW_X   = 1'hx
  } sbw_clients_t;
  localparam NUM_SBW_CLIENTS = 2;


  typedef struct packed
  {
    logic [AXI_WID_W-1:0]      id;
    logic [AXI_ADDR_W-1:0]     addr;
    logic [AXI_LEN_W-1:0]      len;
    logic [2:0]                size;
    logic [1:0]                burst;
    logic [3:0]                cache;
    logic [2:0]                prot;
  } axi_aw_t;

  typedef struct packed
  {
    logic [AXI_RID_W-1:0]      id;
    logic [AXI_ADDR_W-1:0]     addr;
    logic [AXI_LEN_W-1:0]      len;
    logic [2:0]                size;
    logic [1:0]                burst;
    logic [3:0]                cache;
    logic [2:0]                prot;
  } axi_ar_t;

  typedef struct packed
  {
    logic [AXI_DATA_W-1:0]       data;
    logic [AXI_DATA_W_BYTES-1:0] strb;
    logic                        last;
  } axi_w_t;

  typedef struct packed
  {
    logic [AXI_WID_W-1:0]  id;
    logic [1:0]            resp;
  } axi_b_t;

  typedef struct packed
  {
    logic [AXI_RID_W-1:0]  id;
    logic [AXI_DATA_W-1:0] data;
    logic [1:0]            resp;
    logic                  last;
  } axi_r_t;

  typedef logic [MAX_OUTST_RD_LOG:0] max_outs_rd_t;
  typedef logic [MAX_OUTST_WR_LOG:0] max_outs_wr_t;
  typedef logic [MAX_OUTST_WR_LOG - 1:0] wr_id_t;

  typedef logic [MAX_OUTST_WR_LOG-1:0]    ofm_blk_idx_t;

  typedef struct packed
  {
    logic [IFM_BLOCK_WIDTH_W-1:0]     x;
    logic [IFM_BLOCK_HEIGHT_W-1:0]    y;
    logic [IFM_BLOCK_DEPTH_W-1:0]     z;
  } ifm_coord_t;

  typedef struct packed
  {
    logic [OFM_BLOCK_WIDTH_W-1:0]     x;
    logic [OFM_BLOCK_HEIGHT_W-1:0]    y;
    logic [OFM_BLOCK_DEPTH_W-1:0]     z;
  } ofm_coord_t;

  localparam IFM_COORD_W = $bits(ifm_coord_t);
  localparam OFM_COORD_W = $bits(ofm_coord_t);

  typedef union packed
  {
    ifm_coord_t             coord;
    logic [IFM_COORD_W-1:0] idx;
  } ifm_param_t;

  typedef struct packed
  {
    ofm_blk_idx_t blk_idx;
  } ofm_param_t;

  typedef struct packed
  {
    logic [AXI_ADDR_W-1:0]           addr;
    logic [AXI_LEN_W-1:0]            len;
    region_t                         region;
  } read_req_t;

  typedef struct packed
  {
    logic [MAX_OUTST_RD_LOG-1:0] id;
    logic [AXI_DATA_W-1:0]       data;
    logic                        last;
    logic [MAX_BEATS_LG-1:0]     beat_offset;
  } read_resp_t;

  typedef struct packed
  {
    logic [AXI_ADDR_W-1:0]           addr;
    logic [AXI_LEN_W-1:0]            len;
    region_t                         region;
    ofm_param_t                      param;
  } write_req_t;

  localparam READ_REQ_T_W  = $bits(read_req_t);
  localparam WRITE_REQ_T_W = $bits(write_req_t);

  localparam RD_REQ_PAD  = $bits(write_req_t) - $bits(read_req_t);
  typedef struct packed
  {
    logic [RD_REQ_PAD-1:0]       pad;
    read_req_t                   req;
  } read_req_pad_t;

  typedef union packed
  {
    read_req_pad_t     r;
    write_req_t        w;
  } rd_wr_req_t;

  typedef struct packed
  {
    logic [AXI_DATA_W-1:0]       data;
    logic [AXI_DATA_W_BYTES-1:0] strb;
    logic                        last;
    region_t                     region;
  } write_data_t;

  typedef struct packed
  {
    ofm_param_t                  param;
  } write_resp_t;

  typedef logic [3:0] axi_axcache_t;

  typedef struct packed
  {
    logic [AXI_WID_W-1:0]      id;
    logic [AXI_ADDR_W-1:0]     addr;
    logic [AXI_LEN_W-1:0]      len;
    region_t                   region;
    axi_axcache_t              cache;
    prot_t                     prot;
  } axi_partial_t;

  typedef struct packed
  {
    logic [AXI_DATA_W-1:0]       data;
    logic [AXI_DATA_W_BYTES-1:0] strb;
    logic                        last;
    write_master_t               channel;
  } axi_w_wch_t;

  localparam AXI_REG_SIGNAL_W = $bits(axi_partial_t);

  typedef struct packed
  {
    logic [NUM_WRITE_MASTER_LOG-1:0]      channel;
    logic [MEMTYPE_CNT_AXI_LOG-1:0]       memtype;
    ofm_param_t                           param;
  } ofm_outst_t;


  typedef enum logic [2:0]
  {
    CMD_STOPPED       = 3'h0,
    CMD_ADDR_INIT     = 3'h1,
    CMD_ISSUE_REQ     = 3'h2,
    CMD_WAIT_ACK      = 3'h3,
    CMD_ADDR_UPDATE   = 3'h4,
    CMD_REQ_PENDING   = 3'h5,
    CMD_LAST_PENDING  = 3'h6,
    CMD_REQ_DONE      = 3'h7,
    CMD_X             = 3'hx
  } cmd_ch_status_t;


  localparam IFM_JOB_FIFO_DEPTH = NUM_BLOCK_BANKS;
  localparam OFM_JOB_FIFO_DEPTH = NUM_BLOCK_BANKS;

  typedef struct packed
  {
    logic [IFM_X_W-1:0]     x;
    logic [IFM_Y_W-1:0]     y;
    logic [IFM_Z_W-1:0]     z;
  } ifm_real_offs_t;

  typedef struct packed
  {
    logic [OFM_X_ELEM_W-1:0]     x;
    logic [OFM_Y_ELEM_W-1:0]     y;
    logic [OFM_Z_ELEM_W-1:0]     z;
  } ofm_real_offs_t;


  typedef struct packed
  {
    stripe_config_t str_cfg;
    block_config_t  blk_cfg;
  } sb_cfg_data_t;

  typedef struct packed
  {
    stripe_config_t str_cfg;
    block_config_t  blk_cfg;
  } ext_cfg_data_t;

  typedef struct packed
  {
    logic [AXI_DATA_W-1:0]       data;
    logic [AXI_DATA_W_BYTES-1:0] strb;
  } ext_data_t;

  localparam IFM_CHUNK_LEN_W = IFM_BLOCK_WIDTH_W + (IFM_BLOCK_DEPTH_W+1) + $bits(ifm_precision_t);
  typedef logic [IFM_CHUNK_LEN_W - 1:0] ifm_chunk_len_t;

  localparam OFM_CHUNK_LEN_W = (OFM_BLOCK_WIDTH_W+1) + $clog2(GROUP_CHANNELS) + $bits(ofm_precision_t);
  typedef logic [OFM_CHUNK_LEN_W - 1 :0] ofm_chunk_len_t;


  typedef logic [IFM_CHUNK_LEN_W + 1 - 1:0] ifm_chunk_len_p1_t;
  typedef logic [OFM_CHUNK_LEN_W + 1 - 1:0] ofm_chunk_len_p1_t;


  typedef logic [AXI_ADDR_W-1:0]          axi_addr_t;

  typedef struct packed
  {
    ifm_chunk_len_t    len;
    axi_addr_t         addr;
    ofm_blk_idx_t      blk_idx;
    logic              last;
    region_t           region;
  } ifm_chunk_t;

  typedef struct packed
  {
    ofm_chunk_len_t    len;
    axi_addr_t         addr;
    ofm_blk_idx_t      blk_idx;
    logic              last;
    region_t           region;
  } ofm_chunk_t;

  typedef logic [AXI_DATA_W_BYTES_LG-1:0] axi_word_offset_t;
  typedef logic [GROUP_CHANNELS_W-1:0]    ofm_block_depth_t;

  typedef struct packed
  {
    logic                nhwc;
    axi_word_offset_t    offset;
    ofm_block_depth_t    depth_m1;
    ofm_chunk_len_t      len;
    ofm_precision_t      prec;
  } ofm_pack_t;

  typedef logic [AXI_DATA_W_BYTES_LG+1:0] pack_bytes_avail_t;

  typedef struct packed
  {
    logic [MAX_BEATS_LG-1:0]    beats;
    region_t                    region;
  } data_to_send_t;


  localparam RB_MAX_IDS_CH = 26;

  typedef logic [AXI_DATA_W-1:0] rb_data_t;

  localparam RB_SLOT_SZ_BYTES = 64;
  localparam RB_SLOT_SZ_WORDS = RB_SLOT_SZ_BYTES*8/$bits(rb_data_t);
  localparam RB_SLOT_SZ_WORDS_LG2 = $clog2(RB_SLOT_SZ_WORDS);

  typedef logic [$clog2(RB_MAX_IDS_CH*RB_SLOT_SZ_WORDS):0] rb_addr_extended_t;
  typedef logic [$clog2(RB_MAX_IDS_CH*RB_SLOT_SZ_WORDS) - 1:0] rb_addr_t;

  typedef logic [AXI_RID_W-1:0] rb_id_t;
  typedef logic [AXI_RID_W  :0] rb_free_id_cnt_t;

  typedef struct packed
  {
    rb_free_id_cnt_t  free_id_cnt;
    rb_id_t           id;
  } rb_ch_status_t;

  localparam MAX_RB_SLOTS_PER_BURST = AXI_MAX_BURST_BYTES/RB_SLOT_SZ_BYTES;

  typedef logic [$clog2(MAX_RB_SLOTS_PER_BURST)-1:0] rb_alloc_cnt_m1_t;
  typedef logic [$clog2(MAX_RB_SLOTS_PER_BURST):0] rb_alloc_cnt_t;

  typedef logic [$clog2(RB_SLOT_SZ_WORDS*RB_MAX_IDS_CH+1):0] rb_ch_avail_t;

  typedef logic [$clog2(RB_MAX_IDS_CH) - 1:0] rctl_id_t;

  localparam RB_DATA_CNT_W = $clog2(AXI_MAX_BURST_BYTES/AXI_DATA_W_BYTES);
  typedef logic [RB_DATA_CNT_W - 1:0] rb_data_cnt_t;

  typedef struct packed
  {
    logic filled;
    rb_data_cnt_t data_cnt;
  } rb_rctl_status_t;

  localparam RB_0_DEPTH = 4*RB_SLOT_SZ_WORDS;
  localparam RB_0_ADDR_W = $clog2(RB_0_DEPTH);
  localparam RB_1_DEPTH = 26*RB_SLOT_SZ_WORDS;
  localparam RB_1_ADDR_W = $clog2(RB_1_DEPTH);

  localparam RB_MAX_ADDR_W = RB_1_ADDR_W;

  typedef enum logic [1:0]
  {
    WGT_STREAMER = 0,
    BAS_STREAMER = 1,
    CMD_STREAMER = 2,
    M2M_STREAMER = 3
  } stream_type_t;


  typedef logic [AXI_ADDR_W-AXI_DATA_W_BYTES_LG-1:0] addr_words_t;

  typedef logic [AXI_DATA_W_BYTES_LG-1:0] m2m_byte_align_t;
  typedef logic [AXI_DATA_W_BYTES_LG:0]   axi_word_bytes_t;

  typedef struct packed
  {
    logic [AXI_DATA_W-1:0]       data;
    logic [AXI_DATA_W_BYTES-1:0] strb;
  } m2m_out_data_t;

  typedef logic [AXI_DATA_W_BYTES_LG:0] align_avail_t;


  typedef logic [AXI_LEN_W - 1:0] axi_len_t;

  typedef logic [AXI_ADDR_W-AXI_DATA_W_BYTES_LG-1:0] len_words_t;

  function automatic axi_max_beats_t get_max_beats
  (
    input stream_type_t stream_type,
    input region_t      region,
    input axi_config_t  axi_cfg
  );
  begin
    case(stream_type)
      WGT_STREAMER : begin
        get_max_beats = axi_max_beats_t'(axi_cfg[region].max_beats);
      end

      BAS_STREAMER,
      CMD_STREAMER,
      M2M_STREAMER : begin
        get_max_beats = BEATS_64_BYTES;
      end

      default: begin
        get_max_beats = axi_max_beats_t'('x);
      end
    endcase
  end
  endfunction


  function automatic logic is_it_nhwc
  (
    input [31:0] base,
    input [31:0] stride_x,
    input logic  element_size
  );
  begin
    is_it_nhwc = (element_size == '0 ? (base[3:0] != 4'd0) : (base[4:0] != 5'd0)) || (element_size == '0 ? (stride_x != 32'd16) : (stride_x != 32'd32));
  end
  endfunction

  localparam MAX_IFM_BYTES_PER_SAMPLE = 4;

  typedef logic [IFM_BLOCK_DEPTH_W + IFM_BLOCK_WIDTH_W + IFM_BLOCK_HEIGHT_W :0] ifm_unpack_len_t;
  typedef logic [IFM_BLOCK_DEPTH_W + $clog2(MAX_IFM_BYTES_PER_SAMPLE):0] ifm_block_depth_bytes_t;

  typedef struct packed
  {
    logic                     nhwc;
    axi_word_offset_t         offset;
    ifm_block_depth_bytes_t   depth_bytes;
    ifm_unpack_len_t          len;
  } ifm_unpack_t;

  function automatic axi_arcache_t decode_memtype_read
  (
   input memtype_t memtype
  );
  begin
    case (memtype)
      MT_DEVICE_NON_BUFFERABLE                : decode_memtype_read = AXIR_DEVICE_NON_BUFFERABLE;
      MT_DEVICE_BUFFERABLE                    : decode_memtype_read = AXIR_DEVICE_BUFFERABLE;
      MT_NORMAL_NON_CACHEABLE_NON_BUFFERABLE  : decode_memtype_read = AXIR_NORMAL_NON_CACHEABLE_NON_BUFFERABLE;
      MT_NORMAL_NON_CACHEABLE_BUFFERABLE      : decode_memtype_read = AXIR_NORMAL_NON_CACHEABLE_BUFFERABLE;
      MT_WRITE_THROUGH_NO_ALLOCATE            : decode_memtype_read = AXIR_WRITE_THROUGH_NO_ALLOCATE;
      MT_WRITE_THROUGH_READ_ALLOCATE          : decode_memtype_read = AXIR_WRITE_THROUGH_READ_ALLOCATE;
      MT_WRITE_THROUGH_WRITE_ALLOCATE         : decode_memtype_read = AXIR_WRITE_THROUGH_NO_ALLOCATE;
      MT_WRITE_THROUGHREAD_AND_WRITE_ALLOCATE : decode_memtype_read = AXIR_WRITE_THROUGH_READ_ALLOCATE;
      MT_WRITE_BACK_NO_ALLOCATE               : decode_memtype_read = AXIR_WRITE_BACK_NO_ALLOCATE;
      MT_WRITE_BACK_READ_ALLOCATE             : decode_memtype_read = AXIR_WRITE_BACK_READ_ALLOCATE;
      MT_WRITE_BACK_WRITE_ALLOCATE            : decode_memtype_read = AXIR_WRITE_BACK_NO_ALLOCATE;
      MT_WRITE_BACK_READ_AND_WRITE_ALLOCATE   : decode_memtype_read = AXIR_WRITE_BACK_READ_ALLOCATE;
      MT_RESERVED0                            : decode_memtype_read = AXIR_WRITE_BACK_READ_ALLOCATE;
      MT_RESERVED1                            : decode_memtype_read = AXIR_WRITE_BACK_READ_ALLOCATE;
      MT_RESERVED2                            : decode_memtype_read = AXIR_WRITE_BACK_READ_ALLOCATE;
      MT_RESERVED3                            : decode_memtype_read = AXIR_WRITE_BACK_READ_ALLOCATE;
      default : decode_memtype_read = axi_arcache_t'('x);
    endcase
  end
  endfunction

  function automatic axi_awcache_t decode_memtype_write
  (
   input memtype_t memtype
  );
  begin
    case (memtype)
      MT_DEVICE_NON_BUFFERABLE                : decode_memtype_write = AXIW_DEVICE_NON_BUFFERABLE;
      MT_DEVICE_BUFFERABLE                    : decode_memtype_write = AXIW_DEVICE_BUFFERABLE;
      MT_NORMAL_NON_CACHEABLE_NON_BUFFERABLE  : decode_memtype_write = AXIW_NORMAL_NON_CACHEABLE_NON_BUFFERABLE;
      MT_NORMAL_NON_CACHEABLE_BUFFERABLE      : decode_memtype_write = AXIW_NORMAL_NON_CACHEABLE_BUFFERABLE;
      MT_WRITE_THROUGH_NO_ALLOCATE            : decode_memtype_write = AXIW_WRITE_THROUGH_NO_ALLOCATE;
      MT_WRITE_THROUGH_READ_ALLOCATE          : decode_memtype_write = AXIW_WRITE_THROUGH_NO_ALLOCATE;
      MT_WRITE_THROUGH_WRITE_ALLOCATE         : decode_memtype_write = AXIW_WRITE_THROUGH_WRITE_ALLOCATE;
      MT_WRITE_THROUGHREAD_AND_WRITE_ALLOCATE : decode_memtype_write = AXIW_WRITE_THROUGH_WRITE_ALLOCATE;
      MT_WRITE_BACK_NO_ALLOCATE               : decode_memtype_write = AXIW_WRITE_BACK_NO_ALLOCATE;
      MT_WRITE_BACK_READ_ALLOCATE             : decode_memtype_write = AXIW_WRITE_BACK_NO_ALLOCATE;
      MT_WRITE_BACK_WRITE_ALLOCATE            : decode_memtype_write = AXIW_WRITE_BACK_WRITE_ALLOCATE;
      MT_WRITE_BACK_READ_AND_WRITE_ALLOCATE   : decode_memtype_write = AXIW_WRITE_BACK_WRITE_ALLOCATE;
      MT_RESERVED0                            : decode_memtype_write = AXIW_WRITE_BACK_WRITE_ALLOCATE;
      MT_RESERVED1                            : decode_memtype_write = AXIW_WRITE_BACK_WRITE_ALLOCATE;
      MT_RESERVED2                            : decode_memtype_write = AXIW_WRITE_BACK_WRITE_ALLOCATE;
      MT_RESERVED3                            : decode_memtype_write = AXIW_WRITE_BACK_WRITE_ALLOCATE;
      default : decode_memtype_write = axi_awcache_t'('x);
    endcase
  end
  endfunction

  localparam WORDS_PER_GROUP_W  = $clog2(8) + 1;
  localparam WORDS_PER_GROUP_M1_W  = $clog2(8);

  typedef logic[WORDS_PER_GROUP_W-1:0]    words_per_group_t;
  typedef logic[WORDS_PER_GROUP_M1_W-1:0] words_per_group_m1_t;

  function automatic words_per_group_t words_per_group
  (
   input ofm_precision_t prec
  );
  begin
    words_per_group = (prec == OFM_PRECISION_U32) ? words_per_group_t'(8) : (prec == OFM_PRECISION_U16) ? words_per_group_t'(4) : words_per_group_t'(2);
  end
  endfunction

  localparam IFM2_BRCAST_CH_C = 2;

  function automatic logic wr_id_matching
  (
    input [AXI_WID_W-1:0]      id,
    input [PMCAXI_CH_W-1:0]    channel
  );
    logic                      tmp;
    tmp = '0;
    if (channel[PMCAXI_CH_W-1]) begin
      if (channel[PMCAXI_CH_W-2:0] == (PMCAXI_CH_W-1)'(id>>AXI_WR_ID_LSB)) begin
        tmp = '1;
      end
    end
    return tmp;
  endfunction


endpackage : ethosu55_dma_pkg
