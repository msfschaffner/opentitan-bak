// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

module lc_ctrl_bind;

  bind lc_ctrl tlul_assert #(
    .EndpointType("Device")
  ) tlul_assert_device_regs (
    .clk_i,
    .rst_ni,
    .h2d  (regs_tl_i),
    .d2h  (regs_tl_o)
  );

  bind lc_ctrl tlul_assert #(
    .EndpointType("Device")
  ) tlul_assert_device_dbg (
    .clk_i,
    .rst_ni,
    .h2d  (dbg_tl_i),
    .d2h  (dbg_tl_o)
  );

  bind lc_ctrl lc_ctrl_regs_csr_assert_fpv lc_ctrl_regs_csr_assert (
    .clk_i,
    .rst_ni,
    .h2d    (regs_tl_i),
    .d2h    (regs_tl_o)
  );

endmodule
