// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// This module gathers and synchronizes the clock gating and reset indication signals for all
// low-power groups (LPGs), synchronizes them to the alert handler clock domain.
// The clock gating and reset indication signals are then logically OR'ed to produce one multibit
// value for each LPG. The LPG multibit values are then mapped to the alert channels using
// the AlertLpgMap parameter, and each multibit output value is buffered independently.
//

`include "prim_assert.sv"

module alert_handler_lp_sync import alert_pkg::*; #(
  // Parameters for integration
  parameter int unsigned NResets = 1,
  parameter int unsigned NClocks = 1
) (
  input  clk_i,
  input  rst_ni,
  // Low power clk and rst indication signals.
  input  lc_ctrl_pkg::lc_tx_t [NClocks-1:0] cg_en_i,
  input  lc_ctrl_pkg::lc_tx_t [NResets-1:0] rst_en_i,
  // Init requests going to the individual alert channels.
  output lc_ctrl_pkg::lc_tx_t [NClocks-1:0] cg_en_o,
  output lc_ctrl_pkg::lc_tx_t [NResets-1:0] rst_en_o,
);

  ////////////////////////////////////////////////////////
  // Instantiate synchronizers for each clock and reset //
  ////////////////////////////////////////////////////////

  for (genvar k = 0; k < NClocks; k++) begin : gen_cg_en
    prim_lc_sync u_prim_lc_sync (
      .clk_i,
      .rst_ni,
      .lc_en_i(cg_en_i[k]),
      .lc_en_o(cg_en_o[k])
    );
  end
  for (genvar k = 0; k < NResets; k++) begin : gen_rst_en
    prim_lc_sync u_prim_lc_sync (
      .clk_i,
      .rst_ni,
      .lc_en_i(rst_en_i[k]),
      .lc_en_o(rst_en_o[k])
    );
  end

endmodule : alert_handler_lp_sync
