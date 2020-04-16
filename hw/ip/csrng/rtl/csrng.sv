// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description: csrng top level wrapper file

module csrng import csrng_pkg::*; #(
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
  input  csrng_entropy_req_t csrng_entropy_i,
  output csrng_entropy_rsp_t csrng_entropy_o,

  // Application Interfaces
  // instantiation interface
  input  csrng_inst_req_t     [NHwApps-1:0] csrng_inst_i,
  output csrng_inst_rsp_t     [NHwApps-1:0] csrng_inst_o,
  // reseed interface
  input  csrng_reseed_req_t   [NHwApps-1:0] csrng_reseed_i,
  output csrng_reseed_rsp_t   [NHwApps-1:0] csrng_reseed_o,
  // generate interface
  input  csrng_generate_req_t [NHwApps-1:0] csrng_generate_i,
  output csrng_generate_rsp_t [NHwApps-1:0] csrng_generate_o,
  // update interface
  input  csrng_update_req_t   [NHwApps-1:0] csrng_update_i,
  output csrng_update_rsp_t   [NHwApps-1:0] csrng_update_o,
  // un-instantiation interface
  input  csrng_uninst_req_t   [NHwApps-1:0] csrng_uninst_i,
  output csrng_uninst_rsp_t   [NHwApps-1:0] csrng_uninst_o,

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

  csrng_core #(.NSwApps(NSwApps),
    .NHwApps(NHwApps)
  ) u_csrng_core (
    .clk_i,
    .rst_ni,
    .reg2hw,
    .hw2reg,

    .efuse_sw_app_enable_i,

    // Entropy Interface
    .csrng_entropy_i,
    .csrng_entropy_o,

    // Application Interfaces
    .csrng_inst_i,
    .csrng_inst_o,
    .csrng_reseed_i,
    .csrng_reseed_o,
    .csrng_generate_i,
    .csrng_generate_o,
    .csrng_update_i,
    .csrng_update_o,
    .csrng_uninst_i,
    .csrng_uninst_o,

    // Interrupts
    .cs_ins_req_done_o,
    .cs_res_req_done_o,
    .cs_gen_req_done_o,
    .cs_upd_req_done_o,
    .cs_uni_req_done_o,
    .cs_fifo_err_o
  );

endmodule
