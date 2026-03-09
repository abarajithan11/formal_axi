`timescale 1ns/1ps

`include "params.svh"

module f_axi_m_wrapper #(
  parameter int ADDR_W = `AXI_ADDR_W,
  parameter int DATA_W = `AXI_DATA_W,
  parameter int ID_W = `AXI_ID_W,
  parameter int F_LGDEPTH = `AXI_F_LGDEPTH,
  parameter int F_AXI_MAXSTALL = `AXI_F_AXI_MAXSTALL,
  parameter int F_AXI_MAXRSTALL = `AXI_F_AXI_MAXRSTALL,
  parameter int F_AXI_MAXDELAY = `AXI_F_AXI_MAXDELAY
) (
  input  logic clk,
  input  logic rst,
  AXI_BUS.Monitor axi
);
  localparam logic [F_LGDEPTH-1:0] F_AXI_MAXSTALL_L  = F_AXI_MAXSTALL;
  localparam logic [F_LGDEPTH-1:0] F_AXI_MAXRSTALL_L = F_AXI_MAXRSTALL;
  localparam logic [F_LGDEPTH-1:0] F_AXI_MAXDELAY_L  = F_AXI_MAXDELAY;
  logic [F_LGDEPTH-1:0] f_axi_awr_nbursts, f_axi_rd_nbursts, f_axi_rd_outstanding;
  logic [8:0] f_axi_wr_pending;

  faxi_master #(
    .C_AXI_ID_WIDTH(ID_W),
    .C_AXI_DATA_WIDTH(DATA_W),
    .C_AXI_ADDR_WIDTH(ADDR_W),
    .F_LGDEPTH(F_LGDEPTH),
    .F_AXI_MAXSTALL(F_AXI_MAXSTALL_L),
    .F_AXI_MAXRSTALL(F_AXI_MAXRSTALL_L),
    .F_AXI_MAXDELAY(F_AXI_MAXDELAY_L)
  ) u_faxi_master (
    .i_clk(clk),
    .i_axi_reset_n(~rst),
    .i_axi_awvalid(axi.aw_valid),
    .i_axi_awready(axi.aw_ready),
    .i_axi_awid(axi.aw_id),
    .i_axi_awaddr(axi.aw_addr),
    .i_axi_awlen(axi.aw_len),
    .i_axi_awsize(axi.aw_size),
    .i_axi_awburst(axi.aw_burst),
    .i_axi_awlock(axi.aw_lock),
    .i_axi_awcache(axi.aw_cache),
    .i_axi_awprot(axi.aw_prot),
    .i_axi_awqos(axi.aw_qos),
    .i_axi_wvalid(axi.w_valid),
    .i_axi_wready(axi.w_ready),
    .i_axi_wdata(axi.w_data),
    .i_axi_wstrb(axi.w_strb),
    .i_axi_wlast(axi.w_last),
    .i_axi_bvalid(axi.b_valid),
    .i_axi_bready(axi.b_ready),
    .i_axi_bid(axi.b_id),
    .i_axi_bresp(axi.b_resp),
    .i_axi_arvalid(axi.ar_valid),
    .i_axi_arready(axi.ar_ready),
    .i_axi_arid(axi.ar_id),
    .i_axi_araddr(axi.ar_addr),
    .i_axi_arlen(axi.ar_len),
    .i_axi_arsize(axi.ar_size),
    .i_axi_arburst(axi.ar_burst),
    .i_axi_arlock(axi.ar_lock),
    .i_axi_arcache(axi.ar_cache),
    .i_axi_arprot(axi.ar_prot),
    .i_axi_arqos(axi.ar_qos),
    .i_axi_rid(axi.r_id),
    .i_axi_rresp(axi.r_resp),
    .i_axi_rvalid(axi.r_valid),
    .i_axi_rdata(axi.r_data),
    .i_axi_rlast(axi.r_last),
    .i_axi_rready(axi.r_ready),
    .f_axi_awr_nbursts(f_axi_awr_nbursts),
    .f_axi_wr_pending(f_axi_wr_pending),
    .f_axi_rd_nbursts(f_axi_rd_nbursts),
    .f_axi_rd_outstanding(f_axi_rd_outstanding)
  );
endmodule

module f_axi_s_wrapper #(
  parameter int ADDR_W = `AXI_ADDR_W,
  parameter int DATA_W = `AXI_DATA_W,
  parameter int ID_W = `AXI_ID_W,
  parameter int F_LGDEPTH = `AXI_F_LGDEPTH,
  parameter int F_AXI_MAXSTALL = `AXI_F_AXI_MAXSTALL,
  parameter int F_AXI_MAXRSTALL = `AXI_F_AXI_MAXRSTALL,
  parameter int F_AXI_MAXDELAY = `AXI_F_AXI_MAXDELAY
) (
  input  logic clk,
  input  logic rst,
  AXI_BUS.Monitor axi
);
  localparam logic [F_LGDEPTH-1:0] F_AXI_MAXSTALL_L  = F_AXI_MAXSTALL;
  localparam logic [F_LGDEPTH-1:0] F_AXI_MAXRSTALL_L = F_AXI_MAXRSTALL;
  localparam logic [F_LGDEPTH-1:0] F_AXI_MAXDELAY_L  = F_AXI_MAXDELAY;
  logic [F_LGDEPTH-1:0] f_axi_awr_nbursts, f_axi_rd_nbursts, f_axi_rd_outstanding;
  logic [8:0] f_axi_wr_pending;

  faxi_slave #(
    .C_AXI_ID_WIDTH(ID_W),
    .C_AXI_DATA_WIDTH(DATA_W),
    .C_AXI_ADDR_WIDTH(ADDR_W),
    .F_LGDEPTH(F_LGDEPTH),
    .F_AXI_MAXSTALL(F_AXI_MAXSTALL_L),
    .F_AXI_MAXRSTALL(F_AXI_MAXRSTALL_L),
    .F_AXI_MAXDELAY(F_AXI_MAXDELAY_L)
  ) u_faxi_slave (
    .i_clk(clk),
    .i_axi_reset_n(~rst),
    .i_axi_awvalid(axi.aw_valid),
    .i_axi_awready(axi.aw_ready),
    .i_axi_awid(axi.aw_id),
    .i_axi_awaddr(axi.aw_addr),
    .i_axi_awlen(axi.aw_len),
    .i_axi_awsize(axi.aw_size),
    .i_axi_awburst(axi.aw_burst),
    .i_axi_awlock(axi.aw_lock),
    .i_axi_awcache(axi.aw_cache),
    .i_axi_awprot(axi.aw_prot),
    .i_axi_awqos(axi.aw_qos),
    .i_axi_wvalid(axi.w_valid),
    .i_axi_wready(axi.w_ready),
    .i_axi_wdata(axi.w_data),
    .i_axi_wstrb(axi.w_strb),
    .i_axi_wlast(axi.w_last),
    .i_axi_bvalid(axi.b_valid),
    .i_axi_bready(axi.b_ready),
    .i_axi_bid(axi.b_id),
    .i_axi_bresp(axi.b_resp),
    .i_axi_arvalid(axi.ar_valid),
    .i_axi_arready(axi.ar_ready),
    .i_axi_arid(axi.ar_id),
    .i_axi_araddr(axi.ar_addr),
    .i_axi_arlen(axi.ar_len),
    .i_axi_arsize(axi.ar_size),
    .i_axi_arburst(axi.ar_burst),
    .i_axi_arlock(axi.ar_lock),
    .i_axi_arcache(axi.ar_cache),
    .i_axi_arprot(axi.ar_prot),
    .i_axi_arqos(axi.ar_qos),
    .i_axi_rid(axi.r_id),
    .i_axi_rresp(axi.r_resp),
    .i_axi_rvalid(axi.r_valid),
    .i_axi_rdata(axi.r_data),
    .i_axi_rlast(axi.r_last),
    .i_axi_rready(axi.r_ready),
    .f_axi_awr_nbursts(f_axi_awr_nbursts),
    .f_axi_wr_pending(f_axi_wr_pending),
    .f_axi_rd_nbursts(f_axi_rd_nbursts),
    .f_axi_rd_outstanding(f_axi_rd_outstanding)
  );
endmodule
