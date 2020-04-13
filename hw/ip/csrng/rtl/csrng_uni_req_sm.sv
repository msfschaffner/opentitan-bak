// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description: csrng instantiation request state machine module
//
//   handles instantiation requests from all requesting interfaces

module csrng_uni_req_sm (
  input                  clk_i,
  input                  rst_ni,

   // ins req interface
  input logic                uni_req_i,
  output logic               uni_req_rdy_o, // ready to process the req above
  output logic               uni_req_start_o,
  input logic                uni_req_done_i,
  output logic               uni_req_ack_o  // respond with final ack
);


  typedef enum logic [1:0] {
                            IDLE  = 2'b00,
                            STALL = 2'b01,
                            ACK   = 2'b10
                            } state_e;
  
  state_e state_q, state_d;


  always_ff @(posedge clk_i or negedge rst_ni)
    if (!rst_ni) begin
      state_q    <= IDLE;
    end else begin
      state_q    <= state_d;
    end


  always_comb begin
    state_d = state_q;
    uni_req_rdy_o = 1'b0;
    uni_req_start_o = 1'b0;
    uni_req_ack_o = 1'b0;
    unique case (state_q) 
      IDLE:
        if (uni_req_i) begin
          uni_req_rdy_o = 1'b1;
          state_d = STALL;
        end
      STALL:
        begin
          uni_req_start_o = 1'b1;
          if (uni_req_done_i) begin
            state_d = ACK;
          end
        end
      ACK:
        begin
          uni_req_ack_o = 1'b1;
          state_d = IDLE;
        end
      default:
        begin
          state_d = IDLE;
        end
    endcase 
  end
  
endmodule
