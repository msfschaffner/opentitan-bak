// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description: csrng instantiation request state machine module
//
//   handles instantiation requests from all requesting interfaces

module csrng_gen_req_sm (
  input                  clk_i,
  input                  rst_ni,

   // ins req interface
  input logic                gen_req_i,
  output logic               gen_req_rdy_o, // ready to process the req above
  input logic                rnd_out_fifo_not_full_i,
  output logic               rnd_out_fifo_push_o,
  output logic               gen_req_ack_o  // respond with final ack
);


  typedef enum logic [1:0] {
                            IDLE = 2'b00,
                            ENTR = 2'b01,
                            RNDO = 2'b10,
                            ACK  = 2'b11
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
    gen_req_rdy_o = 1'b0;
    gen_req_ack_o = 1'b0;
    rnd_out_fifo_push_o = 1'b0;
    unique case (state_q)
      IDLE:
        if (gen_req_i) begin
          gen_req_rdy_o = 1'b1;
          state_d = RNDO;
        end
      RNDO:
        if (rnd_out_fifo_not_full_i) begin
          rnd_out_fifo_push_o = 1'b1;
        end else begin
          state_d = ACK;
        end
      ACK:
        begin
          gen_req_ack_o = 1'b1;
          state_d = IDLE;
        end
      default:
        begin
          state_d = IDLE;
        end
    endcase 
  end
  
endmodule
