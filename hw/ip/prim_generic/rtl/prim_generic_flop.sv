// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

`include "prim_assert.sv"

module prim_generic_flop #(
    parameter int Width = 1,
    localparam int WidthSubOne = Width - 1,
    parameter logic [WidthSubOne:0] ResetValue = 0
) (
    input                    clk_i,
    input                    rst_ni,
    input        [Width-1:0] d_i,
    output logic [Width-1:0] q_o
);

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      q_o <= ResetValue;
    end else begin
      q_o <= d_i;
    end
  end

endmodule  // prim_generic_flop
