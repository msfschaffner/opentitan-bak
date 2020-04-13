// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description: csrng core module
//

module csrng_core #(
  parameter int unsigned NSwApps = 4,
  parameter int unsigned NHwApps = 4
) (
  input        clk_i,
  input        rst_ni,

  input  csrng_reg_pkg::csrng_reg2hw_t reg2hw,
  output csrng_reg_pkg::csrng_hw2reg_t hw2reg,

  // Efuse Interface
  input [NHwApps-1:0] efuse_sw_app_enable_i,

  // Entropy Interface
  output       entropy_src_rdy_o,
  input        entropy_src_vld_i,
  input [31:0] entropy_src_bits_i,

  // Application Interfaces
  // id0 - instantiation interface
  input        id0_instantiation_req_i,
  output       id0_instantiation_ack_o,
  output [1:0] id0_instantiation_status_o,
  input [31:0] id0_application_seed_i,
  input        id0_application_seed_valid_i,
  output       id0_application_seed_ready_o,
  input        id0_application_seed_clear_i,
  output       id0_application_seed_empty_o,
  output       id0_application_seed_full_o,
  input        id0_full_deterministic_mode_i,
  // id0 - reseed interface
  input        id0_reseed_req_i,
  output       id0_reseed_ack_o,
  output [1:0] id0_reseed_status_o,
  // id0 - generate interface
  input        id0_generate_req_i,
  output       id0_generate_ack_o,
  output [1:0] id0_generate_status_o,
  input [15:0] id0_generate_count_i,
  output [127:0] id0_rnd_out_o,
  output       id0_rnd_out_valid_o,
  input        id0_rnd_out_ready_i,
  input        id0_rnd_out_clear_i,
  input        id0_prediction_resistance_i,
  // id0 - update interface
  input        id0_update_req_i,
  output       id0_update_ack_o,
  output [1:0] id0_update_status_o,
  input [127:0] id0_additional_data_in_i,
  input        id0_additional_data_valid_i,
  output       id0_additional_data_ready_o,
  input        id0_additional_data_clear_i,
  output       id0_additional_data_empty_o,
  // id0 - un-instantiation interface
  input        id0_uninstantiation_req_i,
  output       id0_uninstantiation_ack_o,
  output [1:0] id0_uninstantiation_status_o,

  // id1 - instantiation interface
  input        id1_instantiation_req_i,
  output       id1_instantiation_ack_o,
  output [1:0] id1_instantiation_status_o,
  input [31:0] id1_application_seed_i,
  input        id1_application_seed_valid_i,
  output       id1_application_seed_ready_o,
  input        id1_application_seed_clear_i,
  output       id1_application_seed_empty_o,
  output       id1_application_seed_full_o,
  input        id1_full_deterministic_mode_i,
  // id1 - reseed interface
  input        id1_reseed_req_i,
  output       id1_reseed_ack_o,
  output [1:0] id1_reseed_status_o,
  // id1 - generate interface
  input        id1_generate_req_i,
  output       id1_generate_ack_o,
  output [1:0] id1_generate_status_o,
  input [15:0] id1_generate_count_i,
  output [127:0] id1_rnd_out_o,
  output       id1_rnd_out_valid_o,
  input        id1_rnd_out_ready_i,
  input        id1_rnd_out_clear_i,
  input        id1_prediction_resistance_i,
  // id1 - update interface
  input        id1_update_req_i,
  output       id1_update_ack_o,
  output [1:0] id1_update_status_o,
  input [127:0] id1_additional_data_in_i,
  input        id1_additional_data_valid_i,
  output       id1_additional_data_ready_o,
  input        id1_additional_data_clear_i,
  output       id1_additional_data_empty_o,
  // id1 - un-instantiation interface
  input        id1_uninstantiation_req_i,
  output       id1_uninstantiation_ack_o,
  output [1:0] id1_uninstantiation_status_o,

  // id2 - instantiation interface
  input        id2_instantiation_req_i,
  output       id2_instantiation_ack_o,
  output [1:0] id2_instantiation_status_o,
  input [31:0] id2_application_seed_i,
  input        id2_application_seed_valid_i,
  output       id2_application_seed_ready_o,
  input        id2_application_seed_clear_i,
  output       id2_application_seed_empty_o,
  output       id2_application_seed_full_o,
  input        id2_full_deterministic_mode_i,
  // id2 - reseed interface
  input        id2_reseed_req_i,
  output       id2_reseed_ack_o,
  output [1:0] id2_reseed_status_o,
  // id2 - generate interface
  input        id2_generate_req_i,
  output       id2_generate_ack_o,
  output [1:0] id2_generate_status_o,
  input [15:0] id2_generate_count_i,
  output [127:0] id2_rnd_out_o,
  output       id2_rnd_out_valid_o,
  input        id2_rnd_out_ready_i,
  input        id2_rnd_out_clear_i,
  input        id2_prediction_resistance_i,
  // id2 - update interface
  input        id2_update_req_i,
  output       id2_update_ack_o,
  output [1:0] id2_update_status_o,
  input [127:0] id2_additional_data_in_i,
  input        id2_additional_data_valid_i,
  output       id2_additional_data_ready_o,
  input        id2_additional_data_clear_i,
  output       id2_additional_data_empty_o,
  // id2 - un-instantiation interface
  input        id2_uninstantiation_req_i,
  output       id2_uninstantiation_ack_o,
  output [1:0] id2_uninstantiation_status_o,

  // id3 - instantiation interface
  input        id3_instantiation_req_i,
  output       id3_instantiation_ack_o,
  output [1:0] id3_instantiation_status_o,
  input [31:0] id3_application_seed_i,
  input        id3_application_seed_valid_i,
  output       id3_application_seed_ready_o,
  input        id3_application_seed_clear_i,
  output       id3_application_seed_empty_o,
  output       id3_application_seed_full_o,
  input        id3_full_deterministic_mode_i,
  // id3 - reseed interface
  input        id3_reseed_req_i,
  output       id3_reseed_ack_o,
  output [1:0] id3_reseed_status_o,
  // id3 - generate interface
  input        id3_generate_req_i,
  output       id3_generate_ack_o,
  output [1:0] id3_generate_status_o,
  input [15:0] id3_generate_count_i,
  output [127:0] id3_rnd_out_o,
  output       id3_rnd_out_valid_o,
  input        id3_rnd_out_ready_i,
  input        id3_rnd_out_clear_i,
  input        id3_prediction_resistance_i,
  // id3 - update interface
  input        id3_update_req_i,
  output       id3_update_ack_o,
  output [1:0] id3_update_status_o,
  input [127:0] id3_additional_data_in_i,
  input        id3_additional_data_valid_i,
  output       id3_additional_data_ready_o,
  input        id3_additional_data_clear_i,
  output       id3_additional_data_empty_o,
  // id3 - un-instantiation interface
  input        id3_uninstantiation_req_i,
  output       id3_uninstantiation_ack_o,
  output [1:0] id3_uninstantiation_status_o,

  output logic           cs_ins_req_done_o,
  output logic           cs_res_req_done_o,
  output logic           cs_gen_req_done_o,
  output logic           cs_upd_req_done_o,
  output logic           cs_uni_req_done_o,
  output logic           cs_fifo_err_o
);

  import csrng_reg_pkg::*;

  localparam int unsigned EntrFifoDepth = 16;
  localparam int unsigned CmdFifoDepth = 2;
  localparam int unsigned SeedFifoDepth = 12;
//  localparam int unsigned RndOutFifoDepth = 8;
  // BRONZE: Gate generator below
  // BRONZE:  base fifo 8 +
  // BRONZE:  ctr_drbg functions (16x3) x 5 functions +
  // BRONZE:  encroption block (16x6) +
  // BRONZE:  derivation function (16x6) +
  // BRONZE:  drbg state save (16x4)
  localparam int unsigned RndOutFifoDepth = 8 + 16*3*5 + 16*6*2 + 16*4;
  localparam int unsigned AddDataFifoDepth = 8;

  // signals
  // ins_req signals
  logic [3:0] cs_hw_ins_req;
  logic [3:0] arb_ins_req;
  logic [3:0] arb_ins_req_gnt;
  logic       arb_fsm_ins_req;
  logic       fsm_arb_ins_req_rdy;
  logic       fsm_ins_req_ack;
  logic [1:0] arb_ins_req_id;
  logic [1:0] capt_ins_req_id;
  logic [NHwApps-1:0] hw_ins_req_ack;
  logic [NSwApps-1:0] sw_ins_req_ack;
  // ins_req seed signals
  logic       fsm_seed_fifo_pop;
  logic       arb_det_mode;
  logic       capt_det_mode;
  logic       active_seed_fifo_not_empty;
  logic [3:0] cs_hw_ins_det_mode;
  logic [3:0] cs_hw_ins_seed_valid;
  logic [3:0] cs_hw_ins_seed_clear;
  logic [31:0] cs_hw_ins_seed [4];
  // res_req signals
  logic [3:0] cs_hw_res_req;
  logic [3:0] arb_res_req;
  logic [3:0] arb_res_req_gnt;
  logic       arb_fsm_res_req;
  logic       fsm_arb_res_req_rdy;
  logic       fsm_res_req_ack;
  logic [1:0] arb_res_req_id;
  logic [1:0] capt_res_req_id;
  logic [3:0] hw_res_req_ack;
  logic [3:0] sw_res_req_ack;
  // gen_req signals
  logic [3:0] cs_hw_gen_req;
  logic [3:0] arb_gen_req;
  logic [3:0] arb_gen_req_gnt;
  logic       arb_fsm_gen_req;
  logic       fsm_arb_gen_req_rdy;
  logic       fsm_gen_req_ack;
  logic [1:0] arb_gen_req_id;
  logic [1:0] capt_gen_req_id;
  logic [3:0] hw_gen_req_ack;
  logic [3:0] sw_gen_req_ack;
  // gen_req rnd_out signals
  logic       fsm_rnd_out_fifo_push;
  logic       arb_pre_res;
  logic [15:0] arb_req_cnt;
  logic       capt_pre_res;
  logic [15:0] capt_req_cnt;
  logic       active_rnd_out_fifo_not_full;
  logic [3:0] cs_hw_pre_res;
  logic [3:0] cs_hw_rnd_out_rdy;
  logic [3:0] cs_hw_rnd_out_clear;
  // gen_req cnt signals
  logic [15:0] cs_hw_gen_req_cnt [4];
 // upd_req signals
  logic [3:0] cs_hw_upd_req;
  logic [3:0] arb_upd_req;
  logic [3:0] arb_upd_req_gnt;
  logic       arb_fsm_upd_req;
  logic       fsm_arb_upd_req_rdy;
  logic       fsm_upd_req_ack;
  logic [1:0] arb_upd_req_id;
  logic [1:0] capt_upd_req_id;
  logic [3:0] hw_upd_req_ack;
  logic [3:0] sw_upd_req_ack;
  // upd_req add data signals
  logic       fsm_add_data_fifo_pop;
  logic       active_add_data_fifo_not_empty;
  logic [3:0] cs_hw_add_data_valid;
  logic [3:0] cs_hw_add_data_clear;
  logic [127:0] cs_hw_add_data_in [4];
  // uni_req signals
  logic [3:0] cs_hw_uni_req;
  logic [3:0] arb_uni_req;
  logic [3:0] arb_uni_req_gnt;
  logic       arb_fsm_uni_req;
  logic       fsm_arb_uni_req_rdy;
  logic       fsm_uni_req_ack;
  logic [1:0] arb_uni_req_id;
  logic [1:0] capt_uni_req_id;
  logic [3:0] hw_uni_req_ack;
  logic [3:0] sw_uni_req_ack;

  // entropy fifo
  logic [31:0] sfifo_entr_rdata;
  logic [4:0]  sfifo_entr_depth; //TOD: use a parameter for size
  logic        sfifo_entr_push;
  logic [31:0] sfifo_entr_wdata;
  logic        sfifo_entr_pop;
  logic        sfifo_entr_err;
  logic        sfifo_entr_not_full;
  logic        sfifo_entr_not_empty;
  // ins_req fifo
  logic [2:0] sfifo_ins_req_rdata [4];
  logic [1:0] sfifo_ins_req_depth [4];
  logic [3:0] sfifo_ins_req_push;
  logic [2:0] sfifo_ins_req_wdata [4];
  logic [3:0] sfifo_ins_req_pop;
  logic [3:0] sfifo_ins_req_err;
  logic [3:0] sfifo_ins_req_not_full;
  logic [3:0] sfifo_ins_req_not_empty;
  // ins_seed fifo
  logic [31:0] sfifo_ins_seed_rdata [4];
  logic [3:0] sfifo_ins_seed_depth [4];
  logic [3:0] sfifo_ins_seed_push;
  logic [3:0] sfifo_ins_seed_clear;
  logic [31:0] sfifo_ins_seed_wdata [4];
  logic [3:0] sfifo_ins_seed_pop;
  logic [3:0] sfifo_ins_seed_err;
  logic [3:0] sfifo_ins_seed_not_full;
  logic [3:0] sfifo_ins_seed_not_empty;
  // res_req fifo
  logic [1:0] sfifo_res_req_rdata [4];
  logic [1:0] sfifo_res_req_depth [4];
  logic [3:0] sfifo_res_req_push;
  logic [1:0] sfifo_res_req_wdata [4];
  logic [3:0] sfifo_res_req_pop;
  logic [3:0] sfifo_res_req_err;
  logic [3:0] sfifo_res_req_not_full;
  logic [3:0] sfifo_res_req_not_empty;
  // gen_req fifo
  logic [(16+3)-1:0] sfifo_gen_req_rdata [4];
  logic [1:0] sfifo_gen_req_depth [4];
  logic [3:0] sfifo_gen_req_push;
  logic [(16+3)-1:0] sfifo_gen_req_wdata [4];
  logic [3:0] sfifo_gen_req_pop;
  logic [3:0] sfifo_gen_req_err;
  logic [3:0] sfifo_gen_req_not_full;
  logic [3:0] sfifo_gen_req_not_empty;
  // gen_req rnd_out fifo
  logic [127:0] sfifo_rnd_out_rdata [4];
// BRONZE PATCH: resize depth
//  logic [3:0] sfifo_rnd_out_depth [4];
  logic [8:0] sfifo_rnd_out_depth [4];
  logic [3:0] sfifo_rnd_out_push;
  logic [3:0] sfifo_rnd_out_clear;
  logic [127:0] sfifo_rnd_out_wdata [4];
  logic [3:0] sfifo_rnd_out_pop;
  logic [3:0] sfifo_rnd_out_err;
  logic [3:0] sfifo_rnd_out_not_full;
  logic [3:0] sfifo_rnd_out_not_empty;
  // upd_req fifo
  logic [1:0] sfifo_upd_req_rdata [4];
  logic [1:0] sfifo_upd_req_depth [4];
  logic [3:0] sfifo_upd_req_push;
  logic [1:0] sfifo_upd_req_wdata [4];
  logic [3:0] sfifo_upd_req_pop;
  logic [3:0] sfifo_upd_req_err;
  logic [3:0] sfifo_upd_req_not_full;
  logic [3:0] sfifo_upd_req_not_empty;
  // add_data fifo
  logic [127:0] sfifo_add_data_rdata [4];
  logic [3:0] sfifo_add_data_depth [4];
  logic [3:0] sfifo_add_data_push;
  logic [3:0] sfifo_add_data_clear;
  logic [127:0] sfifo_add_data_wdata [4];
  logic [3:0] sfifo_add_data_pop;
  logic [3:0] sfifo_add_data_err;
  logic [3:0] sfifo_add_data_not_full;
  logic [3:0] sfifo_add_data_not_empty;
  // uni_req fifo
  logic [1:0] sfifo_uni_req_rdata [4];
  logic [1:0] sfifo_uni_req_depth [4];
  logic [3:0] sfifo_uni_req_push;
  logic [1:0] sfifo_uni_req_wdata [4];
  logic [3:0] sfifo_uni_req_pop;
  logic [3:0] sfifo_uni_req_err;
  logic [3:0] sfifo_uni_req_not_full;
  logic [3:0] sfifo_uni_req_not_empty;

  // general signals
  logic       cs_enable;
  logic [3:0] fifo_sel;
  logic       bronze_and_unfinished;

  // interrupt signals
  logic       event_cs_ins_req_done;
  logic       event_cs_res_req_done;
  logic       event_cs_gen_req_done;
  logic       event_cs_upd_req_done;
  logic       event_cs_uni_req_done;
  logic       event_cs_fifo_err;
  
  // flops
  logic [NHwApps-1:0] efuse_sw_app_en_q, efuse_sw_app_en_d;
  logic [2:0]         arb_ins_req_rdata_q, arb_ins_req_rdata_d;
  logic [1:0]         arb_res_req_rdata_q, arb_res_req_rdata_d;
  logic [(16+3)-1:0]  arb_gen_req_rdata_q, arb_gen_req_rdata_d;
  logic [1:0]         arb_upd_req_rdata_q, arb_upd_req_rdata_d;
  logic [1:0]         arb_uni_req_rdata_q, arb_uni_req_rdata_d;

  always_ff @(posedge clk_i or negedge rst_ni)
    if (!rst_ni) begin
      efuse_sw_app_en_q   <= '0;
      arb_ins_req_rdata_q <= '0;
      arb_res_req_rdata_q <= '0;
      arb_gen_req_rdata_q <= '0;
      arb_upd_req_rdata_q <= '0;
      arb_uni_req_rdata_q <= '0;
    end else begin
      efuse_sw_app_en_q   <= efuse_sw_app_en_d;
      arb_ins_req_rdata_q <= arb_ins_req_rdata_d;
      arb_res_req_rdata_q <= arb_res_req_rdata_d;
      arb_gen_req_rdata_q <= arb_gen_req_rdata_d;
      arb_upd_req_rdata_q <= arb_upd_req_rdata_d;
      arb_uni_req_rdata_q <= arb_uni_req_rdata_d;
    end

  assign efuse_sw_app_en_d = efuse_sw_app_enable_i;

  //------------------------------------------
  // instantiation request interface
  //------------------------------------------
  assign      cs_hw_ins_req[0] = id0_instantiation_req_i;
  assign      cs_hw_ins_req[1] = id1_instantiation_req_i;
  assign      cs_hw_ins_req[2] = id2_instantiation_req_i;
  assign      cs_hw_ins_req[3] = id3_instantiation_req_i;

  assign      id0_instantiation_ack_o = hw_ins_req_ack[0];
  assign      id1_instantiation_ack_o = hw_ins_req_ack[1];
  assign      id2_instantiation_ack_o = hw_ins_req_ack[2];
  assign      id3_instantiation_ack_o = hw_ins_req_ack[3];

  assign      hw2reg.cs_app_ins_ack[0].de = sw_ins_req_ack[0];
  assign      hw2reg.cs_app_ins_ack[1].de = sw_ins_req_ack[1];
  assign      hw2reg.cs_app_ins_ack[2].de = sw_ins_req_ack[2];
  assign      hw2reg.cs_app_ins_ack[3].de = sw_ins_req_ack[3];

  assign      hw2reg.cs_app_ins_ack[0].d = 1'b1;
  assign      hw2reg.cs_app_ins_ack[1].d = 1'b1;
  assign      hw2reg.cs_app_ins_ack[2].d = 1'b1;
  assign      hw2reg.cs_app_ins_ack[3].d = 1'b1;

  assign      id0_instantiation_status_o = hw_ins_req_ack[0] ? 2'h1 : 2'h0; // TODO: add real status
  assign      id1_instantiation_status_o = hw_ins_req_ack[1] ? 2'h1 : 2'h0; // TODO: add real status
  assign      id2_instantiation_status_o = hw_ins_req_ack[2] ? 2'h1 : 2'h0; // TODO: add real status
  assign      id3_instantiation_status_o = hw_ins_req_ack[3] ? 2'h1 : 2'h0; // TODO: add real status

  assign      hw2reg.cs_app_ins_sts[0].de = sw_ins_req_ack[0];
  assign      hw2reg.cs_app_ins_sts[1].de = sw_ins_req_ack[1];
  assign      hw2reg.cs_app_ins_sts[2].de = sw_ins_req_ack[2];
  assign      hw2reg.cs_app_ins_sts[3].de = sw_ins_req_ack[3];

  assign      hw2reg.cs_app_ins_sts[0].d = 1'b1;  // TODO: add real status
  assign      hw2reg.cs_app_ins_sts[1].d = 1'b1; // TODO: add real status
  assign      hw2reg.cs_app_ins_sts[2].d = 1'b1; // TODO: add real status
  assign      hw2reg.cs_app_ins_sts[3].d = 1'b1; // TODO: add real status

  assign      cs_hw_ins_det_mode[0] = id0_full_deterministic_mode_i;
  assign      cs_hw_ins_det_mode[1] = id1_full_deterministic_mode_i;
  assign      cs_hw_ins_det_mode[2] = id2_full_deterministic_mode_i;
  assign      cs_hw_ins_det_mode[3] = id3_full_deterministic_mode_i;

  assign      cs_hw_ins_seed_valid[0] = id0_application_seed_valid_i;
  assign      cs_hw_ins_seed_valid[1] = id1_application_seed_valid_i;
  assign      cs_hw_ins_seed_valid[2] = id2_application_seed_valid_i;
  assign      cs_hw_ins_seed_valid[3] = id3_application_seed_valid_i;

  assign      cs_hw_ins_seed_clear[0] = id0_application_seed_clear_i;
  assign      cs_hw_ins_seed_clear[1] = id1_application_seed_clear_i;
  assign      cs_hw_ins_seed_clear[2] = id2_application_seed_clear_i;
  assign      cs_hw_ins_seed_clear[3] = id3_application_seed_clear_i;

  assign      cs_hw_ins_seed[0] = id0_application_seed_i;
  assign      cs_hw_ins_seed[1] = id1_application_seed_i;
  assign      cs_hw_ins_seed[2] = id2_application_seed_i;
  assign      cs_hw_ins_seed[3] = id3_application_seed_i;

  assign      id0_application_seed_ready_o = ~efuse_sw_app_en_q[0] & sfifo_ins_seed_not_full[0];
  assign      id1_application_seed_ready_o = ~efuse_sw_app_en_q[1] & sfifo_ins_seed_not_full[1];
  assign      id2_application_seed_ready_o = ~efuse_sw_app_en_q[2] & sfifo_ins_seed_not_full[2];
  assign      id3_application_seed_ready_o = ~efuse_sw_app_en_q[3] & sfifo_ins_seed_not_full[3];

  assign      id0_application_seed_full_o = ~efuse_sw_app_en_q[0] & ~sfifo_ins_seed_not_full[0];
  assign      id1_application_seed_full_o = ~efuse_sw_app_en_q[1] & ~sfifo_ins_seed_not_full[1];
  assign      id2_application_seed_full_o = ~efuse_sw_app_en_q[2] & ~sfifo_ins_seed_not_full[2];
  assign      id3_application_seed_full_o = ~efuse_sw_app_en_q[3] & ~sfifo_ins_seed_not_full[3];

  assign      id0_application_seed_empty_o = ~efuse_sw_app_en_q[0] &
              sfifo_ins_seed_not_empty[0];
  assign      id1_application_seed_empty_o = ~efuse_sw_app_en_q[1] &
              sfifo_ins_seed_not_empty[1];
  assign      id2_application_seed_empty_o = ~efuse_sw_app_en_q[2] &
              sfifo_ins_seed_not_empty[2];
  assign      id3_application_seed_empty_o = ~efuse_sw_app_en_q[3] &
              sfifo_ins_seed_not_empty[3];

  assign      hw2reg.cs_app_seed_fifo_sts[0].d = {2{efuse_sw_app_en_q[0]}} &
              {sfifo_ins_seed_not_full[0],sfifo_ins_seed_not_empty[0]};
  assign      hw2reg.cs_app_seed_fifo_sts[1].d = {2{efuse_sw_app_en_q[1]}} &
              {sfifo_ins_seed_not_full[1],sfifo_ins_seed_not_empty[1]};
  assign      hw2reg.cs_app_seed_fifo_sts[2].d = {2{efuse_sw_app_en_q[2]}} &
              {sfifo_ins_seed_not_full[2],sfifo_ins_seed_not_empty[2]};
  assign      hw2reg.cs_app_seed_fifo_sts[3].d = {2{efuse_sw_app_en_q[3]}} &
              {sfifo_ins_seed_not_full[3],sfifo_ins_seed_not_empty[3]};

  //------------------------------------------
  // reseed request interface
  //------------------------------------------
  assign      cs_hw_res_req[0] = id0_reseed_req_i;
  assign      cs_hw_res_req[1] = id1_reseed_req_i;
  assign      cs_hw_res_req[2] = id2_reseed_req_i;
  assign      cs_hw_res_req[3] = id3_reseed_req_i;

  assign      id0_reseed_ack_o = hw_res_req_ack[0];
  assign      id1_reseed_ack_o = hw_res_req_ack[1];
  assign      id2_reseed_ack_o = hw_res_req_ack[2];
  assign      id3_reseed_ack_o = hw_res_req_ack[3];

  assign      hw2reg.cs_app_res_ack[0].de = sw_res_req_ack[0];
  assign      hw2reg.cs_app_res_ack[1].de = sw_res_req_ack[1];
  assign      hw2reg.cs_app_res_ack[2].de = sw_res_req_ack[2];
  assign      hw2reg.cs_app_res_ack[3].de = sw_res_req_ack[3];

  assign      hw2reg.cs_app_res_ack[0].d = 1'b1;
  assign      hw2reg.cs_app_res_ack[1].d = 1'b1;
  assign      hw2reg.cs_app_res_ack[2].d = 1'b1;
  assign      hw2reg.cs_app_res_ack[3].d = 1'b1;

  assign      id0_reseed_status_o = hw_res_req_ack[0] ? 2'h1 : 2'h0; // TODO: add real status
  assign      id1_reseed_status_o = hw_res_req_ack[1] ? 2'h1 : 2'h0; // TODO: add real status
  assign      id2_reseed_status_o = hw_res_req_ack[2] ? 2'h1 : 2'h0; // TODO: add real status
  assign      id3_reseed_status_o = hw_res_req_ack[3] ? 2'h1 : 2'h0; // TODO: add real status

  assign      hw2reg.cs_app_res_sts[0].de = sw_res_req_ack[0];
  assign      hw2reg.cs_app_res_sts[1].de = sw_res_req_ack[1];
  assign      hw2reg.cs_app_res_sts[2].de = sw_res_req_ack[2];
  assign      hw2reg.cs_app_res_sts[3].de = sw_res_req_ack[3];

  assign      hw2reg.cs_app_res_sts[0].d = 1'b1;  // TODO: add real status
  assign      hw2reg.cs_app_res_sts[1].d = 1'b1; // TODO: add real status
  assign      hw2reg.cs_app_res_sts[2].d = 1'b1; // TODO: add real status
  assign      hw2reg.cs_app_res_sts[3].d = 1'b1; // TODO: add real status

  //------------------------------------------
  // generate request interface
  //------------------------------------------
  assign      cs_hw_gen_req[0] = id0_generate_req_i;
  assign      cs_hw_gen_req[1] = id1_generate_req_i;
  assign      cs_hw_gen_req[2] = id2_generate_req_i;
  assign      cs_hw_gen_req[3] = id3_generate_req_i;

  assign      id0_generate_ack_o = hw_gen_req_ack[0];
  assign      id1_generate_ack_o = hw_gen_req_ack[1];
  assign      id2_generate_ack_o = hw_gen_req_ack[2];
  assign      id3_generate_ack_o = hw_gen_req_ack[3];

  assign      hw2reg.cs_app_gen_ack[0].de = sw_gen_req_ack[0];
  assign      hw2reg.cs_app_gen_ack[1].de = sw_gen_req_ack[1];
  assign      hw2reg.cs_app_gen_ack[2].de = sw_gen_req_ack[2];
  assign      hw2reg.cs_app_gen_ack[3].de = sw_gen_req_ack[3];

  assign      hw2reg.cs_app_gen_ack[0].d = 1'b1;
  assign      hw2reg.cs_app_gen_ack[1].d = 1'b1;
  assign      hw2reg.cs_app_gen_ack[2].d = 1'b1;
  assign      hw2reg.cs_app_gen_ack[3].d = 1'b1;

  assign      id0_generate_status_o = hw_gen_req_ack[0] ? 2'h1 : 2'h0; // TODO: add real status
  assign      id1_generate_status_o = hw_gen_req_ack[1] ? 2'h1 : 2'h0; // TODO: add real status
  assign      id2_generate_status_o = hw_gen_req_ack[2] ? 2'h1 : 2'h0; // TODO: add real status
  assign      id3_generate_status_o = hw_gen_req_ack[3] ? 2'h1 : 2'h0; // TODO: add real status

  assign      hw2reg.cs_app_gen_sts[0].de = sw_gen_req_ack[0];
  assign      hw2reg.cs_app_gen_sts[1].de = sw_gen_req_ack[1];
  assign      hw2reg.cs_app_gen_sts[2].de = sw_gen_req_ack[2];
  assign      hw2reg.cs_app_gen_sts[3].de = sw_gen_req_ack[3];

  assign      hw2reg.cs_app_gen_sts[0].d = 1'b1;  // TODO: add real status
  assign      hw2reg.cs_app_gen_sts[1].d = 1'b1; // TODO: add real status
  assign      hw2reg.cs_app_gen_sts[2].d = 1'b1; // TODO: add real status
  assign      hw2reg.cs_app_gen_sts[3].d = 1'b1; // TODO: add real status

  assign      cs_hw_gen_req_cnt[0] = id0_generate_count_i;
  assign      cs_hw_gen_req_cnt[1] = id1_generate_count_i;
  assign      cs_hw_gen_req_cnt[2] = id2_generate_count_i;
  assign      cs_hw_gen_req_cnt[3] = id3_generate_count_i;

  assign      id0_rnd_out_o = {128{~efuse_sw_app_en_q[0]}} & sfifo_rnd_out_rdata[0];
  assign      id1_rnd_out_o = {128{~efuse_sw_app_en_q[1]}} & sfifo_rnd_out_rdata[1];
  assign      id2_rnd_out_o = {128{~efuse_sw_app_en_q[2]}} & sfifo_rnd_out_rdata[2];
  assign      id3_rnd_out_o = {128{~efuse_sw_app_en_q[3]}} & sfifo_rnd_out_rdata[3];

  assign      id0_rnd_out_valid_o = ~efuse_sw_app_en_q[0] & sfifo_rnd_out_not_empty[0];
  assign      id1_rnd_out_valid_o = ~efuse_sw_app_en_q[1] & sfifo_rnd_out_not_empty[1];
  assign      id2_rnd_out_valid_o = ~efuse_sw_app_en_q[2] & sfifo_rnd_out_not_empty[2];
  assign      id3_rnd_out_valid_o = ~efuse_sw_app_en_q[3] & sfifo_rnd_out_not_empty[3];

  assign      hw2reg.cs_app_gen_rnd_out_vld[0].d = efuse_sw_app_en_q[0] &
              sfifo_ins_seed_not_empty[0];
  assign      hw2reg.cs_app_gen_rnd_out_vld[1].d = efuse_sw_app_en_q[1] &
              sfifo_ins_seed_not_empty[1];
  assign      hw2reg.cs_app_gen_rnd_out_vld[2].d = efuse_sw_app_en_q[2] &
              sfifo_ins_seed_not_empty[2];
  assign      hw2reg.cs_app_gen_rnd_out_vld[3].d = efuse_sw_app_en_q[3] &
              sfifo_ins_seed_not_empty[3];

  assign      cs_hw_rnd_out_rdy[0] = id0_rnd_out_ready_i;
  assign      cs_hw_rnd_out_rdy[1] = id1_rnd_out_ready_i;
  assign      cs_hw_rnd_out_rdy[2] = id2_rnd_out_ready_i;
  assign      cs_hw_rnd_out_rdy[3] = id3_rnd_out_ready_i;

  assign      cs_hw_rnd_out_clear[0] = id0_rnd_out_clear_i;
  assign      cs_hw_rnd_out_clear[1] = id1_rnd_out_clear_i;
  assign      cs_hw_rnd_out_clear[2] = id2_rnd_out_clear_i;
  assign      cs_hw_rnd_out_clear[3] = id3_rnd_out_clear_i;

  assign      cs_hw_pre_res[0] = id0_prediction_resistance_i;
  assign      cs_hw_pre_res[1] = id1_prediction_resistance_i;
  assign      cs_hw_pre_res[2] = id2_prediction_resistance_i;
  assign      cs_hw_pre_res[3] = id3_prediction_resistance_i;


  //------------------------------------------
  // update request interface
  //------------------------------------------
  assign      cs_hw_upd_req[0] = id0_update_req_i;
  assign      cs_hw_upd_req[1] = id1_update_req_i;
  assign      cs_hw_upd_req[2] = id2_update_req_i;
  assign      cs_hw_upd_req[3] = id3_update_req_i;

  assign      id0_update_ack_o = hw_upd_req_ack[0];
  assign      id1_update_ack_o = hw_upd_req_ack[1];
  assign      id2_update_ack_o = hw_upd_req_ack[2];
  assign      id3_update_ack_o = hw_upd_req_ack[3];

  assign      hw2reg.cs_app_upd_ack[0].de = sw_upd_req_ack[0];
  assign      hw2reg.cs_app_upd_ack[1].de = sw_upd_req_ack[1];
  assign      hw2reg.cs_app_upd_ack[2].de = sw_upd_req_ack[2];
  assign      hw2reg.cs_app_upd_ack[3].de = sw_upd_req_ack[3];

  assign      hw2reg.cs_app_upd_ack[0].d = 1'b1;
  assign      hw2reg.cs_app_upd_ack[1].d = 1'b1;
  assign      hw2reg.cs_app_upd_ack[2].d = 1'b1;
  assign      hw2reg.cs_app_upd_ack[3].d = 1'b1;

  assign      id0_update_status_o = hw_upd_req_ack[0] ? 2'h1 : 2'h0; // TODO: add real status
  assign      id1_update_status_o = hw_upd_req_ack[1] ? 2'h1 : 2'h0; // TODO: add real status
  assign      id2_update_status_o = hw_upd_req_ack[2] ? 2'h1 : 2'h0; // TODO: add real status
  assign      id3_update_status_o = hw_upd_req_ack[3] ? 2'h1 : 2'h0; // TODO: add real status

  assign      hw2reg.cs_app_upd_sts[0].de = sw_upd_req_ack[0];
  assign      hw2reg.cs_app_upd_sts[1].de = sw_upd_req_ack[1];
  assign      hw2reg.cs_app_upd_sts[2].de = sw_upd_req_ack[2];
  assign      hw2reg.cs_app_upd_sts[3].de = sw_upd_req_ack[3];

  assign      hw2reg.cs_app_upd_sts[0].d = 1'b1;  // TODO: add real status
  assign      hw2reg.cs_app_upd_sts[1].d = 1'b1; // TODO: add real status
  assign      hw2reg.cs_app_upd_sts[2].d = 1'b1; // TODO: add real status
  assign      hw2reg.cs_app_upd_sts[3].d = 1'b1; // TODO: add real status

  assign      cs_hw_add_data_valid[0] = id0_additional_data_valid_i;
  assign      cs_hw_add_data_valid[1] = id1_additional_data_valid_i;
  assign      cs_hw_add_data_valid[2] = id2_additional_data_valid_i;
  assign      cs_hw_add_data_valid[3] = id3_additional_data_valid_i;

  assign      cs_hw_add_data_clear[0] = id0_additional_data_clear_i;
  assign      cs_hw_add_data_clear[1] = id1_additional_data_clear_i;
  assign      cs_hw_add_data_clear[2] = id2_additional_data_clear_i;
  assign      cs_hw_add_data_clear[3] = id3_additional_data_clear_i;

  assign      cs_hw_add_data_in[0] = id0_additional_data_in_i;
  assign      cs_hw_add_data_in[1] = id1_additional_data_in_i;
  assign      cs_hw_add_data_in[2] = id2_additional_data_in_i;
  assign      cs_hw_add_data_in[3] = id3_additional_data_in_i;

  assign      id0_additional_data_ready_o = ~efuse_sw_app_en_q[0] & sfifo_add_data_not_full[0];
  assign      id1_additional_data_ready_o = ~efuse_sw_app_en_q[1] & sfifo_add_data_not_full[1];
  assign      id2_additional_data_ready_o = ~efuse_sw_app_en_q[2] & sfifo_add_data_not_full[2];
  assign      id3_additional_data_ready_o = ~efuse_sw_app_en_q[3] & sfifo_add_data_not_full[3];

  assign      id0_additional_data_empty_o = ~efuse_sw_app_en_q[0] & sfifo_add_data_not_empty[0];
  assign      id1_additional_data_empty_o = ~efuse_sw_app_en_q[1] & sfifo_add_data_not_empty[1];
  assign      id2_additional_data_empty_o = ~efuse_sw_app_en_q[2] & sfifo_add_data_not_empty[2];
  assign      id3_additional_data_empty_o = ~efuse_sw_app_en_q[3] & sfifo_add_data_not_empty[3];

  assign      hw2reg.cs_add_data_fifo_sts[0].d = {2{efuse_sw_app_en_q[0]}} &
              {sfifo_add_data_not_full[0],sfifo_add_data_not_empty[0]};
  assign      hw2reg.cs_add_data_fifo_sts[1].d = {2{efuse_sw_app_en_q[1]}} &
              {sfifo_add_data_not_full[1],sfifo_add_data_not_empty[1]};
  assign      hw2reg.cs_add_data_fifo_sts[2].d = {2{efuse_sw_app_en_q[2]}} &
              {sfifo_add_data_not_full[2],sfifo_add_data_not_empty[2]};
  assign      hw2reg.cs_add_data_fifo_sts[3].d = {2{efuse_sw_app_en_q[3]}} &
              {sfifo_add_data_not_full[3],sfifo_add_data_not_empty[3]};

  //------------------------------------------
  // uninstantiation request interface
  //------------------------------------------
  assign      cs_hw_uni_req[0] = id0_uninstantiation_req_i;
  assign      cs_hw_uni_req[1] = id1_uninstantiation_req_i;
  assign      cs_hw_uni_req[2] = id2_uninstantiation_req_i;
  assign      cs_hw_uni_req[3] = id3_uninstantiation_req_i;

  assign      id0_uninstantiation_ack_o = hw_uni_req_ack[0];
  assign      id1_uninstantiation_ack_o = hw_uni_req_ack[1];
  assign      id2_uninstantiation_ack_o = hw_uni_req_ack[2];
  assign      id3_uninstantiation_ack_o = hw_uni_req_ack[3];

  assign      hw2reg.cs_app_uni_ack[0].de = sw_uni_req_ack[0];
  assign      hw2reg.cs_app_uni_ack[1].de = sw_uni_req_ack[1];
  assign      hw2reg.cs_app_uni_ack[2].de = sw_uni_req_ack[2];
  assign      hw2reg.cs_app_uni_ack[3].de = sw_uni_req_ack[3];

  assign      hw2reg.cs_app_uni_ack[0].d = 1'b1;
  assign      hw2reg.cs_app_uni_ack[1].d = 1'b1;
  assign      hw2reg.cs_app_uni_ack[2].d = 1'b1;
  assign      hw2reg.cs_app_uni_ack[3].d = 1'b1;

  // TODO: add real status below
  assign      id0_uninstantiation_status_o = hw_uni_req_ack[0] ? 2'h1 : 2'h0;
  assign      id1_uninstantiation_status_o = hw_uni_req_ack[1] ? 2'h1 : 2'h0;
  assign      id2_uninstantiation_status_o = hw_uni_req_ack[2] ? 2'h1 : 2'h0;
  assign      id3_uninstantiation_status_o = hw_uni_req_ack[3] ? 2'h1 : 2'h0;

  assign      hw2reg.cs_app_uni_sts[0].de = sw_uni_req_ack[0];
  assign      hw2reg.cs_app_uni_sts[1].de = sw_uni_req_ack[1];
  assign      hw2reg.cs_app_uni_sts[2].de = sw_uni_req_ack[2];
  assign      hw2reg.cs_app_uni_sts[3].de = sw_uni_req_ack[3];

  assign      hw2reg.cs_app_uni_sts[0].d = 1'b1; // TODO: add real status
  assign      hw2reg.cs_app_uni_sts[1].d = 1'b1; // TODO: add real status
  assign      hw2reg.cs_app_uni_sts[2].d = 1'b1; // TODO: add real status
  assign      hw2reg.cs_app_uni_sts[3].d = 1'b1; // TODO: add real status


  //--------------------------------------------
  // tlul register settings
  //--------------------------------------------

  // master module enable
  assign cs_enable = reg2hw.cs_ctrl.cs_enable.q;

  // master module enable
  assign fifo_sel = reg2hw.cs_ctrl.fifo_depth_sts_sel.q;

  // set the interrupt event when enabled
  assign event_cs_ins_req_done = fsm_ins_req_ack;
  assign event_cs_res_req_done = fsm_res_req_ack;
  assign event_cs_gen_req_done = fsm_gen_req_ack;
  assign event_cs_upd_req_done = fsm_upd_req_ack;
  assign event_cs_uni_req_done = fsm_uni_req_ack;

  // set the interrupt sources
  assign event_cs_fifo_err =
         sfifo_entr_err |
         (|sfifo_ins_seed_err) |
         (|sfifo_add_data_err) |
         (|sfifo_rnd_out_err) |
         (|sfifo_ins_req_err) |
         (|sfifo_res_req_err) |
         (|sfifo_gen_req_err) |
         (|sfifo_upd_req_err) |
         (|sfifo_uni_req_err);

  //--------------------------------------------
  // instantiate interrupt hardware primitives
  //--------------------------------------------

  prim_intr_hw #(.Width(1)) intr_hw_cs_ins_req_done (
    .event_intr_i           (event_cs_ins_req_done),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.cs_ins_req_done.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.cs_ins_req_done.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.cs_ins_req_done.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.cs_ins_req_done.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.cs_ins_req_done.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.cs_ins_req_done.d),
    .intr_o                 (cs_ins_req_done_o)
  );

  prim_intr_hw #(.Width(1)) intr_hw_cs_res_req_done (
    .event_intr_i           (event_cs_res_req_done),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.cs_res_req_done.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.cs_res_req_done.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.cs_res_req_done.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.cs_res_req_done.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.cs_res_req_done.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.cs_res_req_done.d),
    .intr_o                 (cs_res_req_done_o)
  );

  prim_intr_hw #(.Width(1)) intr_hw_cs_gen_req_done (
    .event_intr_i           (event_cs_gen_req_done),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.cs_gen_req_done.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.cs_gen_req_done.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.cs_gen_req_done.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.cs_gen_req_done.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.cs_gen_req_done.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.cs_gen_req_done.d),
    .intr_o                 (cs_gen_req_done_o)
  );

  prim_intr_hw #(.Width(1)) intr_hw_cs_upd_req_done (
    .event_intr_i           (event_cs_upd_req_done),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.cs_upd_req_done.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.cs_upd_req_done.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.cs_upd_req_done.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.cs_upd_req_done.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.cs_upd_req_done.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.cs_upd_req_done.d),
    .intr_o                 (cs_upd_req_done_o)
  );

  prim_intr_hw #(.Width(1)) intr_hw_cs_uni_req_done (
    .event_intr_i           (event_cs_uni_req_done),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.cs_uni_req_done.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.cs_uni_req_done.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.cs_uni_req_done.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.cs_uni_req_done.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.cs_uni_req_done.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.cs_uni_req_done.d),
    .intr_o                 (cs_uni_req_done_o)
  );

  prim_intr_hw #(.Width(1)) intr_hw_cs_fifo_err (
    .event_intr_i           (event_cs_fifo_err),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.cs_fifo_err.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.cs_fifo_err.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.cs_fifo_err.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.cs_fifo_err.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.cs_fifo_err.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.cs_fifo_err.d),
    .intr_o                 (cs_fifo_err_o)
  );

  //--------------------------------------------
  // entropy fifo
  //--------------------------------------------


      prim_fifo_sync # (.Width(32),.Pass(0),.Depth(EntrFifoDepth))
        u_prim_fifo_sync_entr
          (
           .clk_i          (clk_i),
           .rst_ni         (rst_ni),
           .clr_i          (~cs_enable),
           .wvalid         (sfifo_entr_push),
           .wready         (sfifo_entr_not_full),
           .wdata          (sfifo_entr_wdata),
           .rvalid         (sfifo_entr_not_empty),
           .rready         (sfifo_entr_pop),
           .rdata          (sfifo_entr_rdata),
           .depth          (sfifo_entr_depth)
           );

  assign entropy_src_rdy_o = cs_enable & sfifo_entr_not_full;

  assign sfifo_entr_wdata = entropy_src_bits_i;

  // TODO: log elsewhere? see logic below
  assign sfifo_entr_push = cs_enable & entropy_src_vld_i;
  assign sfifo_entr_pop = 1'b0; // TODO: Temp Bronze
//  assign sfifo_entr_pop = cs_enable & xxxx); // TODO: Temp Bronze pop?

  // fifo err
  assign sfifo_entr_err =
         (sfifo_entr_push & ~sfifo_entr_not_full) |
         (sfifo_entr_pop & ~sfifo_entr_not_empty);


  //--------------------------------------------
  // instantiation request command fifos
  //--------------------------------------------

  genvar ir;
  generate
    for (ir = 0; ir < NHwApps; ir = ir+1) begin : gen_ins_req

      prim_fifo_sync # (.Width(3),.Pass(0),.Depth(CmdFifoDepth))
        u_prim_fifo_sync_ins_req
          (
           .clk_i          (clk_i),
           .rst_ni         (rst_ni),
           .clr_i          (~cs_enable),
           .wvalid         (sfifo_ins_req_push[ir]),
           .wready         (sfifo_ins_req_not_full[ir]),
           .wdata          (sfifo_ins_req_wdata[ir]),
           .rvalid         (sfifo_ins_req_not_empty[ir]),
           .rready         (sfifo_ins_req_pop[ir]),
           .rdata          (sfifo_ins_req_rdata[ir]),
           .depth          (sfifo_ins_req_depth[ir])
           );

      // fifo controls
      assign sfifo_ins_req_push[ir] = cs_enable &
             (efuse_sw_app_en_q[ir] ? reg2hw.cs_app_ins_req[ir].qe : cs_hw_ins_req[ir]);

      assign sfifo_ins_req_wdata[ir] = {cs_hw_ins_det_mode[ir],2'(ir)};

      assign arb_ins_req[ir] = cs_enable & sfifo_ins_req_not_empty[ir];
      assign sfifo_ins_req_pop[ir] = cs_enable & arb_ins_req_gnt[ir];

      // fifo err
      assign sfifo_ins_req_err[ir] =
             (sfifo_ins_req_push[ir] & ~sfifo_ins_req_not_full[ir]) |
             (sfifo_ins_req_pop[ir] & ~sfifo_ins_req_not_empty[ir]);


      prim_fifo_sync # (.Width(32),.Pass(0),.Depth(SeedFifoDepth))
        u_prim_fifo_sync_ins_seed
          (
           .clk_i          (clk_i),
           .rst_ni         (rst_ni),
           .clr_i          (sfifo_ins_seed_clear[ir]),
           .wvalid         (sfifo_ins_seed_push[ir]),
           .wready         (sfifo_ins_seed_not_full[ir]),
           .wdata          (sfifo_ins_seed_wdata[ir]),
           .rvalid         (sfifo_ins_seed_not_empty[ir]),
           .rready         (sfifo_ins_seed_pop[ir]),
           .rdata          (sfifo_ins_seed_rdata[ir]),
           .depth          (sfifo_ins_seed_depth[ir])
           );

      // fifo controls
      assign sfifo_ins_seed_push[ir] = cs_enable &
             (efuse_sw_app_en_q[ir] ? reg2hw.cs_app_ins_seed[ir].qe : cs_hw_ins_seed_valid[ir]);

      assign sfifo_ins_seed_wdata[ir] = efuse_sw_app_en_q[ir] ? reg2hw.cs_app_ins_seed[ir].q :
                                                                cs_hw_ins_seed[ir];

      assign sfifo_ins_seed_clear[ir] = cs_enable &
             (efuse_sw_app_en_q[ir] ? reg2hw.cs_app_seed_clr[ir].qe : cs_hw_ins_seed_clear[ir]);

      assign sfifo_ins_seed_pop[ir] = cs_enable &
             (capt_ins_req_id == ir) & fsm_seed_fifo_pop;

      // fifo err
      assign sfifo_ins_seed_err[ir] =
             (sfifo_ins_seed_push[ir] & ~sfifo_ins_seed_not_full[ir]) |
             (sfifo_ins_seed_pop[ir] & ~sfifo_ins_seed_not_empty[ir]);

      // hw i/f ack and status
      assign hw_ins_req_ack[ir] = ~efuse_sw_app_en_q[ir] &
             (capt_ins_req_id == ir) & fsm_ins_req_ack;

      // sw i/f ack and status
      assign sw_ins_req_ack[ir] = efuse_sw_app_en_q[ir] &
             (capt_ins_req_id == ir) & fsm_ins_req_ack;

    end
  endgenerate

  prim_arbiter_ppc #(
                     .N(NHwApps),  // Number of request ports
                     .DW(3))       // Data width
    u_prim_arbiter_ppc_ins_req
      (
       .clk_i(clk_i),
       .rst_ni(rst_ni),
       .req_i(arb_ins_req), // 4 requests
       .data_i(sfifo_ins_req_rdata), // 3 data bits
       .gnt_o(arb_ins_req_gnt), // 1 gnt
       .idx_o(), // 2 bit idx
       .valid_o(arb_fsm_ins_req), // 1 req
       .data_o({arb_det_mode,arb_ins_req_id}), // info with req
       .ready_i(fsm_arb_ins_req_rdy) // 1 fsm rdy
       );

  // capture arb info for later processing
  assign     arb_ins_req_rdata_d = fsm_arb_ins_req_rdy ? {arb_det_mode,arb_ins_req_id} :
                                                          arb_ins_req_rdata_q;
  assign     capt_ins_req_id = arb_ins_req_rdata_q[1:0];
  assign     capt_det_mode = arb_ins_req_rdata_q[2];
  assign     active_seed_fifo_not_empty =
             (sfifo_ins_seed_not_empty[0] & (capt_ins_req_id == 2'h0)) |
             (sfifo_ins_seed_not_empty[1] & (capt_ins_req_id == 2'h1)) |
             (sfifo_ins_seed_not_empty[2] & (capt_ins_req_id == 2'h2)) |
             (sfifo_ins_seed_not_empty[3] & (capt_ins_req_id == 2'h3));

  // sm to process all instantiation requests
  csrng_ins_req_sm
    u_csrng_ins_req_sm
      (
       .clk_i(clk_i),
       .rst_ni(rst_ni),
       .ins_req_i(arb_fsm_ins_req),
       .ins_req_rdy_o(fsm_arb_ins_req_rdy),
       .seed_fifo_not_empty_i(active_seed_fifo_not_empty),
       .seed_fifo_pop_o(fsm_seed_fifo_pop),
       .ent_fifo_wait_i(1'b0),
       .ins_req_ack_o(fsm_ins_req_ack)
       );


  //--------------------------------------------
  // reseed request command fifos
  //--------------------------------------------

  genvar rr;
  generate
    for (rr = 0; rr < NHwApps; rr = rr+1) begin : gen_res_req

      prim_fifo_sync # (.Width(2),.Pass(0),.Depth(CmdFifoDepth))
        u_prim_fifo_sync_res_req
          (
           .clk_i          (clk_i),
           .rst_ni         (rst_ni),
           .clr_i          (~cs_enable),
           .wvalid         (sfifo_res_req_push[rr]),
           .wready         (sfifo_res_req_not_full[rr]),
           .wdata          (sfifo_res_req_wdata[rr]),
           .rvalid         (sfifo_res_req_not_empty[rr]),
           .rready         (sfifo_res_req_pop[rr]),
           .rdata          (sfifo_res_req_rdata[rr]),
           .depth          (sfifo_res_req_depth[rr])
           );

      // fifo controls
      assign sfifo_res_req_push[rr] = cs_enable &
             (efuse_sw_app_en_q[rr] ? reg2hw.cs_app_res_req[rr].qe : cs_hw_res_req[rr]);

      assign sfifo_res_req_wdata[rr] = rr;

      assign arb_res_req[rr] = cs_enable & sfifo_res_req_not_empty[rr];
      assign sfifo_res_req_pop[rr] = cs_enable & arb_res_req_gnt[rr];

      // fifo err
      assign sfifo_res_req_err[rr] =
             (sfifo_res_req_push[rr] & ~sfifo_res_req_not_full[rr]) |
             (sfifo_res_req_pop[rr] & ~sfifo_res_req_not_empty[rr]);

      // hw i/f ack and status
      assign hw_res_req_ack[rr] = ~efuse_sw_app_en_q[rr] &
             (capt_res_req_id == rr) & fsm_res_req_ack;

      // sw i/f ack and status
      assign sw_res_req_ack[rr] = efuse_sw_app_en_q[rr] &
             (capt_res_req_id == rr) & fsm_res_req_ack;

    end
  endgenerate

  prim_arbiter_ppc #(
                     .N(NHwApps),  // Number of request ports
                     .DW(2))       // Data width
    u_prim_arbiter_ppc_res_req
      (
       .clk_i(clk_i),
       .rst_ni(rst_ni),
       .req_i(arb_res_req), // 4 requests
       .data_i(sfifo_res_req_rdata), // 2 data bits
       .gnt_o(arb_res_req_gnt), // 1 gnt
       .idx_o(), // 2 bit idx
       .valid_o(arb_fsm_res_req), // 1 req
       .data_o(arb_res_req_id), // info with req
       .ready_i(fsm_arb_res_req_rdy) // 1 fsm rdy
       );

  // capture arb info for later processing
  assign     arb_res_req_rdata_d = fsm_arb_res_req_rdy ? arb_res_req_id : arb_res_req_rdata_q; 
  assign     capt_res_req_id = arb_res_req_rdata_q[1:0];

  // sm to process all reseed requests
  csrng_res_req_sm
    u_csrng_res_req_sm
      (
       .clk_i(clk_i),
       .rst_ni(rst_ni),
       .res_req_i(arb_fsm_res_req),
       .res_req_rdy_o(fsm_arb_res_req_rdy),
       .res_req_start_o(),
       .res_req_done_i(1'b1), // TODO: stub
       .res_req_ack_o(fsm_res_req_ack)
       );


  //--------------------------------------------
  // generate request command fifos
  //--------------------------------------------

  genvar gr;
  generate
    for (gr = 0; gr < NHwApps; gr = gr+1) begin : gen_gen_req

      prim_fifo_sync # (.Width(16+3),.Pass(0),.Depth(CmdFifoDepth))
        u_prim_fifo_sync_gen_req
          (
           .clk_i          (clk_i),
           .rst_ni         (rst_ni),
           .clr_i          (~cs_enable),
           .wvalid         (sfifo_gen_req_push[gr]),
           .wready         (sfifo_gen_req_not_full[gr]),
           .wdata          (sfifo_gen_req_wdata[gr]),
           .rvalid         (sfifo_gen_req_not_empty[gr]),
           .rready         (sfifo_gen_req_pop[gr]),
           .rdata          (sfifo_gen_req_rdata[gr]),
           .depth          (sfifo_gen_req_depth[gr])
           );

      // fifo controls
      assign sfifo_gen_req_push[gr] = cs_enable &
             (efuse_sw_app_en_q[gr] ? reg2hw.cs_app_gen_req[gr].qe : cs_hw_gen_req[gr]);

      assign sfifo_gen_req_wdata[gr] = {cs_hw_gen_req_cnt[gr],cs_hw_pre_res[gr],2'(gr)};

      assign arb_gen_req[gr] = cs_enable & sfifo_gen_req_not_empty[gr];
      assign sfifo_gen_req_pop[gr] = cs_enable & arb_gen_req_gnt[gr];

      // fifo err
      assign sfifo_gen_req_err[gr] =
             (sfifo_gen_req_push[gr] & ~sfifo_gen_req_not_full[gr]) |
             (sfifo_gen_req_pop[gr] & ~sfifo_gen_req_not_empty[gr]);


      prim_fifo_sync # (.Width(128),.Pass(0),.Depth(RndOutFifoDepth))
        u_prim_fifo_sync_gen_rnd_out
          (
           .clk_i          (clk_i),
           .rst_ni         (rst_ni),
           .clr_i          (sfifo_rnd_out_clear[gr]),
           .wvalid         (sfifo_rnd_out_push[gr]),
           .wready         (sfifo_rnd_out_not_full[gr]),
           .wdata          (sfifo_rnd_out_wdata[gr]),
           .rvalid         (sfifo_rnd_out_not_empty[gr]),
           .rready         (sfifo_rnd_out_pop[gr]),
           .rdata          (sfifo_rnd_out_rdata[gr]),
           .depth          (sfifo_rnd_out_depth[gr])
           );

      // fifo controls
      assign sfifo_rnd_out_push[gr] = cs_enable &
             (capt_gen_req_id == gr) & fsm_rnd_out_fifo_push;

      assign sfifo_rnd_out_wdata[gr] = {4{sfifo_entr_rdata}}; // TODO: BRONZE PATCH

      assign hw2reg.cs_rnd_out_bits[gr].d = {32{efuse_sw_app_en_q[gr]}} &
             sfifo_rnd_out_rdata[gr][31:0]; // TODO: BRONZE PATCH, need sequencer

      assign sfifo_rnd_out_clear[gr] = cs_enable &
             (efuse_sw_app_en_q[gr] ? reg2hw.cs_app_rnd_out_clr[gr].qe : cs_hw_rnd_out_clear[gr]);

      assign sfifo_rnd_out_pop[gr] = cs_enable &
             (efuse_sw_app_en_q[gr] ? reg2hw.cs_rnd_out_bits[gr].re : cs_hw_rnd_out_rdy[gr]);

      // fifo err
      assign sfifo_rnd_out_err[gr] =
             (sfifo_rnd_out_push[gr] & ~sfifo_rnd_out_not_full[gr]) |
             (sfifo_rnd_out_pop[gr] & ~sfifo_rnd_out_not_empty[gr]);

      // hw i/f ack and status
      assign hw_gen_req_ack[gr] = ~efuse_sw_app_en_q[gr] &
             (capt_gen_req_id == gr) & fsm_gen_req_ack;

      // sw i/f ack and status
      assign sw_gen_req_ack[gr] = efuse_sw_app_en_q[gr] &
             (capt_gen_req_id == gr) & fsm_gen_req_ack;

    end
  endgenerate

  prim_arbiter_ppc #(
                     .N(NHwApps),  // Number of request ports
                     .DW(16+3))       // Data width
    u_prim_arbiter_ppc_gen_req
      (
       .clk_i(clk_i),
       .rst_ni(rst_ni),
       .req_i(arb_gen_req), // 4 requests
       .data_i(sfifo_gen_req_rdata), // 16+3 data bits
       .gnt_o(arb_gen_req_gnt), // 1 gnt
       .idx_o(), // 2 bit idx
       .valid_o(arb_fsm_gen_req), // 1 req
       .data_o({arb_req_cnt,arb_pre_res,arb_gen_req_id}), // info with req
       .ready_i(fsm_arb_gen_req_rdy) // 1 fsm rdy
       );

  // capture arb info for later processing
  assign     arb_gen_req_rdata_d = fsm_arb_gen_req_rdy ? {arb_req_cnt,arb_pre_res,arb_gen_req_id} :
                                                         arb_gen_req_rdata_q;
  assign     capt_gen_req_id = arb_gen_req_rdata_q[1:0];
  assign     capt_pre_res = arb_gen_req_rdata_q[2];
  assign     capt_req_cnt = arb_gen_req_rdata_q[(16+3)-1:3];
  assign     active_rnd_out_fifo_not_full =
             (sfifo_rnd_out_not_full[0] & (capt_gen_req_id == 2'h0)) |
             (sfifo_rnd_out_not_full[1] & (capt_gen_req_id == 2'h1)) |
             (sfifo_rnd_out_not_full[2] & (capt_gen_req_id == 2'h2)) |
             (sfifo_rnd_out_not_full[3] & (capt_gen_req_id == 2'h3));

  // sm to process all generate requests
  csrng_gen_req_sm
    u_csrng_gen_req_sm
      (
       .clk_i(clk_i),
       .rst_ni(rst_ni),
       .gen_req_i(arb_fsm_gen_req),
       .gen_req_rdy_o(fsm_arb_gen_req_rdy),
       .rnd_out_fifo_not_full_i(active_rnd_out_fifo_not_full),
       .rnd_out_fifo_push_o(fsm_rnd_out_fifo_push),
       .gen_req_ack_o(fsm_gen_req_ack)
       );


  //--------------------------------------------
  // update request command fifos
  //--------------------------------------------

  genvar ur;
  generate
    for (ur = 0; ur < NHwApps; ur = ur+1) begin : gen_upd_req

      prim_fifo_sync # (.Width(2),.Pass(0),.Depth(CmdFifoDepth))
        u_prim_fifo_sync_upd_req
          (
           .clk_i          (clk_i),
           .rst_ni         (rst_ni),
           .clr_i          (~cs_enable),
           .wvalid         (sfifo_upd_req_push[ur]),
           .wready         (sfifo_upd_req_not_full[ur]),
           .wdata          (sfifo_upd_req_wdata[ur]),
           .rvalid         (sfifo_upd_req_not_empty[ur]),
           .rready         (sfifo_upd_req_pop[ur]),
           .rdata          (sfifo_upd_req_rdata[ur]),
           .depth          (sfifo_upd_req_depth[ur])
           );

      // fifo controls
      assign sfifo_upd_req_push[ur] = cs_enable &
             (efuse_sw_app_en_q[ur] ? reg2hw.cs_app_upd_req[ur].qe : cs_hw_upd_req[ur]);

      assign sfifo_upd_req_wdata[ur] = ur;

      assign arb_upd_req[ur] = cs_enable & sfifo_upd_req_not_empty[ur];
      assign sfifo_upd_req_pop[ur] = cs_enable & arb_upd_req_gnt[ur];

      // fifo err
      assign sfifo_upd_req_err[ur] =
             (sfifo_upd_req_push[ur] & ~sfifo_upd_req_not_full[ur]) |
             (sfifo_upd_req_pop[ur] & ~sfifo_upd_req_not_empty[ur]);


      prim_fifo_sync # (.Width(128),.Pass(0),.Depth(AddDataFifoDepth))
        u_prim_fifo_sync_add_data
          (
           .clk_i          (clk_i),
           .rst_ni         (rst_ni),
           .clr_i          (sfifo_add_data_clear[ur]),
           .wvalid         (sfifo_add_data_push[ur]),
           .wready         (sfifo_add_data_not_full[ur]),
           .wdata          (sfifo_add_data_wdata[ur]),
           .rvalid         (sfifo_add_data_not_empty[ur]),
           .rready         (sfifo_add_data_pop[ur]),
           .rdata          (sfifo_add_data_rdata[ur]),
           .depth          (sfifo_add_data_depth[ur])
           );

      // fifo controls
      assign sfifo_add_data_push[ur] = cs_enable &
             (efuse_sw_app_en_q[ur] ? reg2hw.cs_add_data_in[ur].qe : cs_hw_add_data_valid[ur]);

      assign sfifo_add_data_wdata[ur] = efuse_sw_app_en_q[ur] ?
             {96'b0,reg2hw.cs_add_data_in[ur].q} : cs_hw_add_data_in[ur]; // TODO: fix width

      assign sfifo_add_data_clear[ur] = cs_enable &
             (efuse_sw_app_en_q[ur] ? reg2hw.cs_add_data_clr[ur].qe : cs_hw_add_data_clear[ur]);

      assign sfifo_add_data_pop[ur] = cs_enable &
             (capt_upd_req_id == ur) & fsm_add_data_fifo_pop;

      // fifo err
      assign sfifo_add_data_err[ur] =
             (sfifo_add_data_push[ur] & ~sfifo_add_data_not_full[ur]) |
             (sfifo_add_data_pop[ur] & ~sfifo_add_data_not_empty[ur]);

      // hw i/f ack and status
      assign hw_upd_req_ack[ur] = ~efuse_sw_app_en_q[ur] &
             (capt_upd_req_id == ur) & fsm_upd_req_ack;

      // sw i/f ack and status
      assign sw_upd_req_ack[ur] = efuse_sw_app_en_q[ur] &
             (capt_upd_req_id == ur) & fsm_upd_req_ack;

    end
  endgenerate

  prim_arbiter_ppc #(
                     .N(NHwApps),  // Number of request ports
                     .DW(2))       // Data width
    u_prim_arbiter_ppc_upd_req
      (
       .clk_i(clk_i),
       .rst_ni(rst_ni),
       .req_i(arb_upd_req), // 4 requests
       .data_i(sfifo_upd_req_rdata), // 2 data bits
       .gnt_o(arb_upd_req_gnt), // 1 gnt
       .idx_o(), // 2 bit idx
       .valid_o(arb_fsm_upd_req), // 1 req
       .data_o(arb_upd_req_id), // info with req
       .ready_i(fsm_arb_upd_req_rdy) // 1 fsm rdy
       );

  // capture arb info for later processing
  assign     arb_upd_req_rdata_d = fsm_arb_upd_req_rdy ? arb_upd_req_id : arb_upd_req_rdata_q; 
  assign     capt_upd_req_id = arb_upd_req_rdata_q;
  assign     active_add_data_fifo_not_empty =
             (sfifo_add_data_not_empty[0] & (capt_upd_req_id == 2'h0)) |
             (sfifo_add_data_not_empty[1] & (capt_upd_req_id == 2'h1)) |
             (sfifo_add_data_not_empty[2] & (capt_upd_req_id == 2'h2)) |
             (sfifo_add_data_not_empty[3] & (capt_upd_req_id == 2'h3));

  // sm to process all update requests
  csrng_upd_req_sm
    u_csrng_upd_req_sm
      (
       .clk_i(clk_i),
       .rst_ni(rst_ni),
       .upd_req_i(arb_fsm_upd_req),
       .upd_req_rdy_o(fsm_arb_upd_req_rdy),
       .add_data_fifo_not_empty_i(active_add_data_fifo_not_empty),
       .add_data_fifo_pop_o(fsm_add_data_fifo_pop),
       .ent_fifo_wait_i(1'b0),
       .upd_req_ack_o(fsm_upd_req_ack)
       );

  //--------------------------------------------
  // uninstantiation request command fifos
  //--------------------------------------------

  genvar ui;
  generate
    for (ui = 0; ui < NHwApps; ui = ui+1) begin : gen_uni_req

      prim_fifo_sync # (.Width(2),.Pass(0),.Depth(CmdFifoDepth))
        u_prim_fifo_sync_uni_req
          (
           .clk_i          (clk_i),
           .rst_ni         (rst_ni),
           .clr_i          (~cs_enable),
           .wvalid         (sfifo_uni_req_push[ui]),
           .wready         (sfifo_uni_req_not_full[ui]),
           .wdata          (sfifo_uni_req_wdata[ui]),
           .rvalid         (sfifo_uni_req_not_empty[ui]),
           .rready         (sfifo_uni_req_pop[ui]),
           .rdata          (sfifo_uni_req_rdata[ui]),
           .depth          (sfifo_uni_req_depth[ui])
           );

      // fifo controls
      assign sfifo_uni_req_push[ui] = cs_enable &
             (efuse_sw_app_en_q[ui] ? reg2hw.cs_app_uni_req[ui].qe : cs_hw_uni_req[ui]);

      assign sfifo_uni_req_wdata[ui] = ui;

      assign arb_uni_req[ui] = cs_enable & sfifo_uni_req_not_empty[ui];
      assign sfifo_uni_req_pop[ui] = cs_enable & arb_uni_req_gnt[ui];

      // fifo err
      assign sfifo_uni_req_err[ui] =
             (sfifo_uni_req_push[ui] & ~sfifo_uni_req_not_full[ui]) |
             (sfifo_uni_req_pop[ui] & ~sfifo_uni_req_not_empty[ui]);

      // hw i/f ack and status
      assign hw_uni_req_ack[ui] = ~efuse_sw_app_en_q[ui] &
             (capt_uni_req_id == ui) & fsm_uni_req_ack;

      // sw i/f ack and status
      assign sw_uni_req_ack[ui] = efuse_sw_app_en_q[ui] &
             (capt_uni_req_id == ui) & fsm_uni_req_ack;

    end
  endgenerate

  prim_arbiter_ppc #(
                     .N(NHwApps),  // Number of request ports
                     .DW(2))       // Data width
    u_prim_arbiter_ppc_uni_req
      (
       .clk_i(clk_i),
       .rst_ni(rst_ni),
       .req_i(arb_uni_req), // 4 requests
       .data_i(sfifo_uni_req_rdata), // 2 data bits
       .gnt_o(arb_uni_req_gnt), // 1 gnt
       .idx_o(), // 2 bit idx
       .valid_o(arb_fsm_uni_req), // 1 req
       .data_o(arb_uni_req_id), // info with req
       .ready_i(fsm_arb_uni_req_rdy) // 1 fsm rdy
       );

  // capture arb info for later processing
  assign     arb_uni_req_rdata_d = fsm_arb_uni_req_rdy ? arb_uni_req_id : arb_uni_req_rdata_q; 
  assign     capt_uni_req_id = arb_uni_req_rdata_q[1:0];

  // sm to process all uninstantiation requests
  csrng_uni_req_sm
    u_csrng_uni_req_sm
      (
       .clk_i(clk_i),
       .rst_ni(rst_ni),
       .uni_req_i(arb_fsm_uni_req),
       .uni_req_rdy_o(fsm_arb_uni_req_rdy),
       .uni_req_start_o(),
       .uni_req_done_i(1'b1), // TODO: stub
       .uni_req_ack_o(fsm_uni_req_ack)
       );


  //--------------------------------------------
  // report csrng request summary
  //--------------------------------------------

  assign     hw2reg.cs_sum_sts.fifo_depth_sts.de = cs_enable;
  assign     hw2reg.cs_sum_sts.fifo_depth_sts.d  =
             (fifo_sel == 4'h0) ? {
                                   sfifo_gen_req_depth[3],
                                   sfifo_gen_req_depth[2],
                                   sfifo_gen_req_depth[1],
                                   sfifo_gen_req_depth[0],
                                   sfifo_res_req_depth[3],
                                   sfifo_res_req_depth[2],
                                   sfifo_res_req_depth[1],
                                   sfifo_res_req_depth[0],
                                   sfifo_ins_req_depth[3],
                                   sfifo_ins_req_depth[2],
                                   sfifo_ins_req_depth[1],
                                   sfifo_ins_req_depth[0]} :
             (fifo_sel == 4'h1) ? {3'b0,
                                   sfifo_entr_depth,
                                   sfifo_uni_req_depth[3],
                                   sfifo_uni_req_depth[2],
                                   sfifo_uni_req_depth[1],
                                   sfifo_uni_req_depth[0],
                                   sfifo_upd_req_depth[3],
                                   sfifo_upd_req_depth[2],
                                   sfifo_upd_req_depth[1],
                                   sfifo_upd_req_depth[0]} :
             (fifo_sel == 4'h2) ? {8'b0,
                                   sfifo_ins_seed_depth[3],
                                   sfifo_ins_seed_depth[2],
                                   sfifo_ins_seed_depth[1],
                                   sfifo_ins_seed_depth[0]} :
             (fifo_sel == 4'h3) ? {8'b0,
                                   sfifo_add_data_depth[3],
                                   sfifo_add_data_depth[2],
                                   sfifo_add_data_depth[1],
                                   sfifo_add_data_depth[0]} :
//             (fifo_sel == 4'h4) ? {8'b0,
//                                   sfifo_rnd_out_depth[3],
//                                   sfifo_rnd_out_depth[2],
//                                   sfifo_rnd_out_depth[1],
//                                   sfifo_rnd_out_depth[0]} :
             // BRONZE PATCH: indexing
             (fifo_sel == 4'h4) ? {6'b0,
                                   sfifo_rnd_out_depth[1],
                                   sfifo_rnd_out_depth[0]} :
             (fifo_sel == 4'h5) ? {6'b0,
                                   sfifo_rnd_out_depth[2],
                                   sfifo_rnd_out_depth[3]} :
             24'b0;
  
  
  assign     hw2reg.cs_sum_sts.diag.de = ~cs_enable;
  assign     hw2reg.cs_sum_sts.diag.d  =
             reg2hw.cs_add_data_clr[0].q |
             reg2hw.cs_add_data_clr[1].q |
             reg2hw.cs_add_data_clr[2].q |
             reg2hw.cs_add_data_clr[3].q |
             reg2hw.cs_app_seed_clr[0].q |
             reg2hw.cs_app_seed_clr[1].q |
             reg2hw.cs_app_seed_clr[2].q |
             reg2hw.cs_app_seed_clr[3].q |
             reg2hw.cs_app_rnd_out_clr[0].q |
             reg2hw.cs_app_rnd_out_clr[1].q |
             reg2hw.cs_app_rnd_out_clr[2].q |
             reg2hw.cs_app_rnd_out_clr[3].q |
             reg2hw.cs_app_ins_req[0].q |
             reg2hw.cs_app_ins_req[1].q |
             reg2hw.cs_app_ins_req[2].q |
             reg2hw.cs_app_ins_req[3].q |
             reg2hw.cs_app_res_req[0].q |
             reg2hw.cs_app_res_req[1].q |
             reg2hw.cs_app_res_req[2].q |
             reg2hw.cs_app_res_req[3].q |
             reg2hw.cs_app_gen_req[0].q |
             reg2hw.cs_app_gen_req[1].q |
             reg2hw.cs_app_gen_req[2].q |
             reg2hw.cs_app_gen_req[3].q |
             reg2hw.cs_app_upd_req[0].q |
             reg2hw.cs_app_upd_req[1].q |
             reg2hw.cs_app_upd_req[2].q |
             reg2hw.cs_app_upd_req[3].q |
             reg2hw.cs_app_uni_req[0].q |
             reg2hw.cs_app_uni_req[1].q |
             reg2hw.cs_app_uni_req[2].q |
             reg2hw.cs_app_uni_req[3].q |
             reg2hw.cs_regen |
             (|reg2hw.cs_rnd_out_bits[0]) |
             (|reg2hw.cs_rnd_out_bits[1]) |
             (|reg2hw.cs_rnd_out_bits[2]) |
             (|reg2hw.cs_rnd_out_bits[3]) |
             bronze_and_unfinished;


  assign     bronze_and_unfinished =  // TODO: eventually use these
             sfifo_entr_not_empty |
             (|sfifo_ins_seed_rdata[0]) |
             (|sfifo_ins_seed_rdata[1]) |
             (|sfifo_ins_seed_rdata[2]) |
             (|sfifo_ins_seed_rdata[3]) |
             (|sfifo_add_data_rdata[0]) |
             (|sfifo_add_data_rdata[1]) |
             (|sfifo_add_data_rdata[2]) |
             (|sfifo_add_data_rdata[3]) |
             capt_det_mode |
             capt_pre_res |
             (|capt_req_cnt) |
             reg2hw.cs_det_mode[0].q |
             reg2hw.cs_det_mode[1].q |
             reg2hw.cs_det_mode[2].q |
             reg2hw.cs_det_mode[3].q |
             reg2hw.cs_app_pre_res[0].q |
             reg2hw.cs_app_pre_res[1].q |
             reg2hw.cs_app_pre_res[2].q |
             reg2hw.cs_app_pre_res[3].q;

endmodule
