// Copyright lowRISC contributors.
// Licensed under the Apache License; Version 2.0; see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//


package csrng_pkg;

  ////////////////////
  // Fuse Interface //
  ////////////////////

  // incoming
  typedef struct packed {
    logic        entropy_src_vld;
    logic [31:0] entropy_src_bits;
  } csrng_entropy_req_t;

  // outgoing
  typedef struct packed {
    logic entropy_src_rdy;
  } csrng_entropy_rsp_t;

  ////////////////////////////
  // Application Interfaces //
  ////////////////////////////

  // instantiation interface
  // incoming
  typedef struct packed {
    logic        inst_req;
    logic [31:0] appl_seed;
    logic        appl_seed_valid;
    logic        appl_seed_clear;
    logic        full_deterministic_mode;
  } csrng_inst_req_t;

  // outgoing
  typedef struct packed {
    logic       inst_ack;
    logic [1:0] inst_status;
    logic       app_seed_ready;
    logic       app_seed_empty;
    logic       app_seed_full;
  } csrng_inst_rsp_t;

  // reseed interface
  // incoming
  typedef struct packed {
    logic        reseed_req;
  } csrng_reseed_req_t;

  // outgoing
  typedef struct packed {
    logic       reseed_ack;
    logic [1:0] reseed_status;
  } csrng_reseed_rsp_t;

  // generate interface
  // incoming
  typedef struct packed {
    logic        generate_req;
    logic [15:0] generate_count;
    logic        rnd_out_ready;
    logic        rnd_out_clear;
    logic        prediction_resistance;
  } csrng_generate_req_t;

  // outgoing
  typedef struct packed {
    logic         generate_ack;
    logic [1:0]   generate_status;
    logic [127:0] rnd_out;
    logic         rnd_out_valid;
  } csrng_generate_rsp_t;

  // update interface
  // incoming
  typedef struct packed {
    input         update_req;
    input [127:0] additional_data_in;
    input         additional_data_valid;
    input         additional_data_clear;
  } csrng_update_req_t;

  // outgoing
  typedef struct packed {
    output       update_ack;
    output [1:0] update_status;
    output       additional_data_ready;
    output       additional_data_empty;
  } csrng_update_rsp_t;

  // un-instantiation interface
  // incoming
  typedef struct packed {
    input        uninst_req;
  } csrng_uninst_req_t;

  // outgoing
  typedef struct packed {
    logic       uninst_ack;
    logic [1:0] uninst_status;
  } csrng_uninst_rsp_t;

endpackage : csrng_pkg
