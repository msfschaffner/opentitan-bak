// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description: csrng top level wrapper file

module csrng #(
  parameter int unsigned NSwApps = 4,
  parameter int unsigned NHwApps = 4
) (
  input         clk_i,
  input         rst_ni,

  // Tilelink Bus Interface
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,

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

  // Interrupts

  output logic    cs_ins_req_done_o,
  output logic    cs_res_req_done_o,
  output logic    cs_gen_req_done_o,
  output logic    cs_upd_req_done_o,
  output logic    cs_uni_req_done_o,
  output logic    cs_fifo_err_o
);

  import csrng_reg_pkg::*;

  csrng_reg2hw_t reg2hw;
  csrng_hw2reg_t hw2reg;

  csrng_reg_top u_csrng_reg_top (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o,
    .reg2hw,
    .hw2reg,

    .devmode_i(1'b1)
  );

  csrng_core
    #(.NSwApps(NSwApps),
      .NHwApps(NHwApps))
      u_csrng_core
        (
         .clk_i,
         .rst_ni,
         .reg2hw,
         .hw2reg,

         .efuse_sw_app_enable_i,
         // Entropy Interface
         .entropy_src_rdy_o,
         .entropy_src_vld_i,
         .entropy_src_bits_i,

         // Application Interfaces
         .id0_instantiation_req_i,
         .id0_instantiation_ack_o,
         .id0_instantiation_status_o,
         .id0_application_seed_i,
         .id0_application_seed_valid_i,
         .id0_application_seed_ready_o,
         .id0_application_seed_clear_i,
         .id0_application_seed_empty_o,
         .id0_application_seed_full_o,
         .id0_full_deterministic_mode_i,

         .id0_reseed_req_i,
         .id0_reseed_ack_o,
         .id0_reseed_status_o,

         .id0_generate_req_i,
         .id0_generate_ack_o,
         .id0_generate_status_o,
         .id0_generate_count_i,
         .id0_rnd_out_o,
         .id0_rnd_out_valid_o,
         .id0_rnd_out_ready_i,
         .id0_rnd_out_clear_i,
         .id0_prediction_resistance_i,

         .id0_update_req_i,
         .id0_update_ack_o,
         .id0_update_status_o,
         .id0_additional_data_in_i,
         .id0_additional_data_valid_i,
         .id0_additional_data_ready_o,
         .id0_additional_data_clear_i,
         .id0_additional_data_empty_o,

         .id0_uninstantiation_req_i,
         .id0_uninstantiation_ack_o,
         .id0_uninstantiation_status_o,

         .id1_instantiation_req_i,
         .id1_instantiation_ack_o,
         .id1_instantiation_status_o,
         .id1_application_seed_i,
         .id1_application_seed_valid_i,
         .id1_application_seed_ready_o,
         .id1_application_seed_clear_i,
         .id1_application_seed_empty_o,
         .id1_application_seed_full_o,
         .id1_full_deterministic_mode_i,

         .id1_reseed_req_i,
         .id1_reseed_ack_o,
         .id1_reseed_status_o,

         .id1_generate_req_i,
         .id1_generate_ack_o,
         .id1_generate_status_o,
         .id1_generate_count_i,
         .id1_rnd_out_o,
         .id1_rnd_out_valid_o,
         .id1_rnd_out_ready_i,
         .id1_rnd_out_clear_i,
         .id1_prediction_resistance_i,

         .id1_update_req_i,
         .id1_update_ack_o,
         .id1_update_status_o,
         .id1_additional_data_in_i,
         .id1_additional_data_valid_i,
         .id1_additional_data_ready_o,
         .id1_additional_data_clear_i,
         .id1_additional_data_empty_o,

         .id1_uninstantiation_req_i,
         .id1_uninstantiation_ack_o,
         .id1_uninstantiation_status_o,

         .id2_instantiation_req_i,
         .id2_instantiation_ack_o,
         .id2_instantiation_status_o,
         .id2_application_seed_i,
         .id2_application_seed_valid_i,
         .id2_application_seed_ready_o,
         .id2_application_seed_clear_i,
         .id2_application_seed_empty_o,
         .id2_application_seed_full_o,
         .id2_full_deterministic_mode_i,

         .id2_reseed_req_i,
         .id2_reseed_ack_o,
         .id2_reseed_status_o,

         .id2_generate_req_i,
         .id2_generate_ack_o,
         .id2_generate_status_o,
         .id2_generate_count_i,
         .id2_rnd_out_o,
         .id2_rnd_out_valid_o,
         .id2_rnd_out_ready_i,
         .id2_rnd_out_clear_i,
         .id2_prediction_resistance_i,

         .id2_update_req_i,
         .id2_update_ack_o,
         .id2_update_status_o,
         .id2_additional_data_in_i,
         .id2_additional_data_valid_i,
         .id2_additional_data_ready_o,
         .id2_additional_data_clear_i,
         .id2_additional_data_empty_o,

         .id2_uninstantiation_req_i,
         .id2_uninstantiation_ack_o,
         .id2_uninstantiation_status_o,

         .id3_instantiation_req_i,
         .id3_instantiation_ack_o,
         .id3_instantiation_status_o,
         .id3_application_seed_i,
         .id3_application_seed_valid_i,
         .id3_application_seed_ready_o,
         .id3_application_seed_clear_i,
         .id3_application_seed_empty_o,
         .id3_application_seed_full_o,
         .id3_full_deterministic_mode_i,

         .id3_reseed_req_i,
         .id3_reseed_ack_o,
         .id3_reseed_status_o,

         .id3_generate_req_i,
         .id3_generate_ack_o,
         .id3_generate_status_o,
         .id3_generate_count_i,
         .id3_rnd_out_o,
         .id3_rnd_out_valid_o,
         .id3_rnd_out_ready_i,
         .id3_rnd_out_clear_i,
         .id3_prediction_resistance_i,

         .id3_update_req_i,
         .id3_update_ack_o,
         .id3_update_status_o,
         .id3_additional_data_in_i,
         .id3_additional_data_valid_i,
         .id3_additional_data_ready_o,
         .id3_additional_data_clear_i,
         .id3_additional_data_empty_o,

         .id3_uninstantiation_req_i,
         .id3_uninstantiation_ack_o,
         .id3_uninstantiation_status_o,

         .cs_ins_req_done_o,
         .cs_res_req_done_o,
         .cs_gen_req_done_o,
         .cs_upd_req_done_o,
         .cs_uni_req_done_o,
         .cs_fifo_err_o
         );

endmodule
