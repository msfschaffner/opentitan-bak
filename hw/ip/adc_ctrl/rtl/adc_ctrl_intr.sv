// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description: adc_ctrl interrupt Module
//
module adc_ctrl_intr
  import adc_ctrl_reg_pkg::*;
#(
) (
  input  clk_aon_i,
  input  rst_aon_ni,
  input  clk_i,
  input  rst_ni,

  input  [NumAdcFilter-1:0] aon_filter_match_i,
  input  aon_fsm_trans_i,
  input  cfg_oneshot_done_i,

  input  [NumAdcFilter-1:0] cfg_intr_en_i,
  input  cfg_intr_trans_en_i,
  input  cfg_oneshot_done_en_i,

  input  adc_ctrl_reg2hw_intr_state_reg_t intr_state_i,
  input  adc_ctrl_reg2hw_intr_enable_reg_t intr_enable_i,
  input  adc_ctrl_reg2hw_intr_test_reg_t intr_test_i,

  output adc_ctrl_hw2reg_intr_state_reg_t intr_state_o,
  input  adc_ctrl_reg2hw_adc_intr_status_reg_t adc_intr_status_i,
  output adc_ctrl_hw2reg_adc_intr_status_reg_t adc_intr_status_o,

  output intr_o
);


  // Number of filters and FSM transition interrupt.
  localparam int NumAonIntrEvents = NumAdcFilter + 1;
  logic [NumAonIntrEvents-1:0] aon_reqs;
  assign aon_reqs = {aon_fsm_trans_i, aon_filter_match_i};

  // aon interrupt requests are split into staging and request portions.
  // The staging portion always absorbs the incoming event pulse.
  // The request portion on the other hand does not change until
  // a request/ack handshake cycle has completed.
  logic [NumAonIntrEvents-1:0] staging_reqs_q;
  logic aon_ld_req;

  // staging portion takes on the value of the incoming event match
  // and clears when it is snapshot into request hold.
  always_ff @(posedge clk_aon_i or negedge rst_aon_ni) begin
     if (!rst_aon_ni) begin
        staging_reqs_q <= '0;
     end else if (aon_ld_req && |aon_reqs) begin
        staging_reqs_q <= aon_reqs;
     end else if (aon_ld_req) begin
        staging_reqs_q <= '0;
     end else if (|aon_reqs) begin
        staging_reqs_q <= staging_reqs_q | aon_reqs;
     end
  end

  logic [NumAonIntrEvents-1:0] aon_req_hold_q;
  logic aon_ack;

  // staging has pending requsts
  assign aon_ld_req = (aon_req_hold_q == '0) & |staging_reqs_q;

  // request hold self clears when the handshake cycle is complete
  always_ff @(posedge clk_aon_i or negedge rst_aon_ni) begin
     if (!rst_aon_ni) begin
        aon_req_hold_q <= '0;
     end else if (aon_ld_req) begin
        aon_req_hold_q <= staging_reqs_q;
     end else if (aon_ack) begin
        aon_req_hold_q <= '0;
     end
  end

  logic dst_ack;
  prim_sync_reqack u_match_sync (
    .clk_src_i(clk_aon_i),
    .rst_src_ni(rst_aon_ni),
    .clk_dst_i(clk_i),
    .rst_dst_ni(rst_ni),
    .req_chk_i(1'b1),
    .src_req_i(|aon_req_hold_q),
    .src_ack_o(aon_ack),
    .dst_req_o(dst_ack),
    .dst_ack_i(dst_ack)
  );

  // To write into interrupt status register. Note that we're also adding the non-AON interrupt
  // source cfg_oneshot_done_i at this point.
  logic [1+NumAonIntrEvents-1:0] intr_events;

  // Note that aon_req_hold is a value held in an async domain.
  // aon_req_hold's value should not change until handshake is completed by `prim_sync_reqack`.
  // There is no reason to use `prim_sync_reqack` in this case because that module passes
  // through data only when the direction is src->dst.
  assign intr_events = {cfg_oneshot_done_i, {NumAonIntrEvents{dst_ack}} & aon_req_hold_q} &
                       {cfg_oneshot_done_en_i, cfg_intr_trans_en_i, cfg_intr_en_i};

  assign adc_intr_status_o.match.de = |intr_events[7:0];
  assign adc_intr_status_o.trans.de = intr_events[8];
  assign adc_intr_status_o.oneshot.de = intr_events[9];

  // since interrupt events are pulsed, when successive events arrive we need to make sure to
  // hold the previously latched values
  assign adc_intr_status_o.match.d = intr_events[7:0] | adc_intr_status_i.match.q;

  logic unused_sigs;
  assign unused_sigs = ^{adc_intr_status_i.oneshot.q,
                         adc_intr_status_i.trans.q};
  assign adc_intr_status_o.trans.d = 1'b1;
  assign adc_intr_status_o.oneshot.d = 1'b1;

  // instantiate interrupt hardware primitive
  prim_intr_hw #(.Width(1)) i_adc_ctrl_intr_o (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .event_intr_i           (|intr_events),
    .reg2hw_intr_enable_q_i (intr_enable_i.q),
    .reg2hw_intr_test_q_i   (intr_test_i.q),
    .reg2hw_intr_test_qe_i  (intr_test_i.qe),
    .reg2hw_intr_state_q_i  (intr_state_i.q),
    .hw2reg_intr_state_de_o (intr_state_o.de),
    .hw2reg_intr_state_d_o  (intr_state_o.d),
    .intr_o
  );

endmodule
