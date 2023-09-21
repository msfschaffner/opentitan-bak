// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// xbar_${xbar.name}_tb module generated by `tlgen.py` tool for smoke check
<%
  import random
%>
module xbar_${xbar.name}_tb;

  import tlul_pkg::*;

  // Clock generator
% for clock in xbar.clocks:
  localparam CLK_${clock.upper()}_PERIOD = ${random.randint(10,40)};
% endfor

% for clock in xbar.clocks:
  logic clk_${clock};
  initial begin
    clk_${clock} = 1'b0;
    forever begin
      #(CLK_${clock.upper()}_PERIOD/2)
      clk_${clock} = ~clk_${clock};
    end
  end

% endfor

  // One reset but synchronized to multiple reset
  logic rst_n ;
  initial begin
    rst_n = 1'b0;
    #117ns
    rst_n = 1'b1;
  end

% for clock in xbar.clocks:
  logic rst_${clock}_n;
  initial begin
    rst_${clock}_n = 1'b0;

    wait(rst_n == 1'b1);
    @(negedge clk_${clock});
    rst_${clock}_n = 1'b1;
  end

% endfor

  // Signals
% for node in xbar.hosts + xbar.devices:
  tl_h2d_t tl_${node.name}_h2d ;
  tl_d2h_t tl_${node.name}_d2h ;
% endfor

  // Instance of xbar_${xbar.name}
  xbar_${xbar.name} dut (
% for clock in xbar.clocks:
    .clk_${clock}_i   (clk_${clock}),
    .rst_${clock}_ni  (rst_${clock}_n),
% endfor

    // Host interfaces
% for node in xbar.hosts:
    .tl_${node.name}_i  (tl_${node.name}_h2d),
    .tl_${node.name}_o  (tl_${node.name}_d2h),
% endfor

    // Device interfaces
% for node in xbar.devices:
    .tl_${node.name}_o  (tl_${node.name}_h2d),
    .tl_${node.name}_i  (tl_${node.name}_d2h),
% endfor

    .scanmode_i (1'b0)

  );

  task automatic tl_write(ref clk, ref tl_h2d_t tl_h2d, ref tl_d2h_t tl_d2h,
    input [31:0] addr, input [31:0] wdata);
    tl_h2d.a_address = addr;
    tl_h2d.a_opcode = PutFullData;
    tl_h2d.a_param = '0;
    tl_h2d.a_size = 2'h2;
    tl_h2d.a_user = '0;
    tl_h2d.a_data = wdata;
    tl_h2d.a_mask = 'hF;
    tl_h2d.a_source = 0;
    tl_h2d.a_valid = 1'b1;
    @(posedge clk iff tl_d2h.a_ready == 1'b1);
    tl_h2d.a_valid = 1'b0;
    tl_h2d.d_ready = 1'b1;
    @(posedge clk iff tl_d2h.d_valid == 1'b1);
    if (tl_d2h.d_error == 1'b1) $error("TL-UL interface error occurred");
    tl_h2d.d_ready = 1'b0;
  endtask : tl_write

  task automatic tl_read(ref clk, ref tl_h2d_t tl_h2d, ref tl_d2h_t tl_d2h,
    input [31:0] addr, output logic [31:0] rdata);
    tl_h2d.a_address = addr;
    tl_h2d.a_opcode = Get;
    tl_h2d.a_param = '0;
    tl_h2d.a_size = 2'h2;
    tl_h2d.a_user = '0;
    tl_h2d.a_source = 0;
    tl_h2d.a_valid = 1'b1;
    @(posedge clk iff tl_d2h.a_ready == 1'b1);
    tl_h2d.a_valid = 1'b0;
    tl_h2d.d_ready = 1'b1;
    @(posedge clk iff tl_d2h.d_valid == 1'b1);
    if (tl_d2h.d_error == 1'b1) $error("TL-UL interface error occurred");
    rdata = tl_d2h.d_data;
    tl_h2d.d_ready = 1'b0;
  endtask : tl_read

  task automatic tl_compare(ref clk, ref tl_h2d_t tl_h2d, ref tl_d2h_t tl_d2h,
    input [31:0] addr, input [31:0] wdata);
    automatic logic [31:0] rdata;
    tl_write(clk, tl_h2d, tl_d2h, addr, wdata);
    tl_read(clk, tl_h2d, tl_d2h, addr, rdata);
    if (wdata != rdata) $error("Addr(%x) mismatch: Exp(%x), Got(%x)", addr, wdata, rdata);
  endtask : tl_compare

  // Transaction generator
  //
  // Goal: Each host creates random sequence
  //  1. select random device
  //  2. select random burst (not implemented)
  //  3. select random address range within the device
  //  4. Write and read then compare
  //  Note: There's chance that another host updates content at the same address location when a host
  //        reads. This is unavoidable but the change is unlikely. But remind that it is possible.
  typedef struct {
    logic [31:0] addr_from;
    logic [31:0] addr_to;
  } addr_range_t;
% for host in xbar.hosts:
<%
  clkname = "clk_" + host.clocks[0]
  rstname = "rst_" + host.clocks[0] + "_n"
  num_dev = len(xbar.get_socket_if_exist(host).ds)

  addrs = list(map(xbar.get_addr, xbar.get_devices_from_host(host)))
%>\
  addr_range_t ${host.name}_map [${num_dev}] = '{
% for addr in addrs:
% if loop.last:
    '{addr_from: 32'h${"%x"%(addr[0])}, addr_to: 32'h${"%x" %(addr[1])}}
% else:
    '{addr_from: 32'h${"%x"%(addr[0])}, addr_to: 32'h${"%x" %(addr[1])}},
% endif
% endfor
  };
  initial begin
    // Wait until reset is released
    tl_${host.name}_h2d.a_valid = 1'b0;
    tl_${host.name}_h2d.d_ready = 1'b0;
    wait(${rstname} == 1'b1);
    @(negedge ${clkname});
    forever begin
      // choose among the device
      automatic int dev_sel = $urandom_range(${num_dev-1},0);

      // determine address
      automatic logic [31:0] addr = $urandom_range(${host.name}_map[dev_sel].addr_to,
                                                   ${host.name}_map[dev_sel].addr_from);
      addr = addr & 32'h FFFF_FFFC;

      // compare
      tl_compare(${clkname}, tl_${host.name}_h2d, tl_${host.name}_d2h, addr, $urandom());
    end
  end
% endfor

  // Instantiate generic TL-UL sram
% for device in xbar.devices:
<%
  tl_h2d_sig = "tl_" + device.name + "_h2d"
  tl_d2h_sig = "tl_" + device.name + "_d2h"
%>
  device_sram u_device_${device.name} (
    .clk_i      (clk_${device.clocks[0]}),
    .tl_i       (${tl_h2d_sig}),
    .tl_o       (${tl_d2h_sig})
  );
% endfor

  initial begin
    #100us
    $finish(1);
  end
endmodule


