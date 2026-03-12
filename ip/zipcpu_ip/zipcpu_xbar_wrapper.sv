`timescale 1ns/1ps

`include "params.svh"

module axi_xbar_wrapper #(
  parameter int ADDR_W = `AXI_ADDR_W,
  parameter int DATA_W = `AXI_DATA_W,
  parameter int ID_W   = `AXI_ID_W
) (
  input  logic clk,
  input  logic rst,
  AXI_BUS.Slave  s_axi,
  AXI_BUS.Master m_axi
);

  localparam [ADDR_W-1:0] SLAVE_ADDR_P = {{(ADDR_W-4){1'b0}}, 4'h0};
  localparam [ADDR_W-1:0] SLAVE_MASK_P = {{(ADDR_W-4){1'b0}}, 4'hf};

  axixbar #(
    .C_AXI_DATA_WIDTH(DATA_W),
    .C_AXI_ADDR_WIDTH(ADDR_W),
    .C_AXI_ID_WIDTH(ID_W),
    .NM(1),
    .NS(1),
    .SLAVE_ADDR(SLAVE_ADDR_P),
    .SLAVE_MASK(SLAVE_MASK_P)
  ) dut (
    .S_AXI_ACLK(clk),
    .S_AXI_ARESETN(~rst),

    .S_AXI_AWVALID(s_axi.aw_valid),
    .S_AXI_AWREADY(s_axi.aw_ready),
    .S_AXI_AWID(s_axi.aw_id),
    .S_AXI_AWADDR(s_axi.aw_addr),
    .S_AXI_AWLEN(s_axi.aw_len),
    .S_AXI_AWSIZE(s_axi.aw_size),
    .S_AXI_AWBURST(s_axi.aw_burst),
    .S_AXI_AWLOCK(s_axi.aw_lock),
    .S_AXI_AWCACHE(s_axi.aw_cache),
    .S_AXI_AWPROT(s_axi.aw_prot),
    .S_AXI_AWQOS(s_axi.aw_qos),

    .S_AXI_WVALID(s_axi.w_valid),
    .S_AXI_WREADY(s_axi.w_ready),
    .S_AXI_WDATA(s_axi.w_data),
    .S_AXI_WSTRB(s_axi.w_strb),
    .S_AXI_WLAST(s_axi.w_last),

    .S_AXI_BVALID(s_axi.b_valid),
    .S_AXI_BREADY(s_axi.b_ready),
    .S_AXI_BID(s_axi.b_id),
    .S_AXI_BRESP(s_axi.b_resp),

    .S_AXI_ARVALID(s_axi.ar_valid),
    .S_AXI_ARREADY(s_axi.ar_ready),
    .S_AXI_ARID(s_axi.ar_id),
    .S_AXI_ARADDR(s_axi.ar_addr),
    .S_AXI_ARLEN(s_axi.ar_len),
    .S_AXI_ARSIZE(s_axi.ar_size),
    .S_AXI_ARBURST(s_axi.ar_burst),
    .S_AXI_ARLOCK(s_axi.ar_lock),
    .S_AXI_ARCACHE(s_axi.ar_cache),
    .S_AXI_ARPROT(s_axi.ar_prot),
    .S_AXI_ARQOS(s_axi.ar_qos),

    .S_AXI_RVALID(s_axi.r_valid),
    .S_AXI_RREADY(s_axi.r_ready),
    .S_AXI_RID(s_axi.r_id),
    .S_AXI_RDATA(s_axi.r_data),
    .S_AXI_RRESP(s_axi.r_resp),
    .S_AXI_RLAST(s_axi.r_last),

    .M_AXI_AWVALID(m_axi.aw_valid),
    .M_AXI_AWREADY(m_axi.aw_ready),
    .M_AXI_AWID(m_axi.aw_id),
    .M_AXI_AWADDR(m_axi.aw_addr),
    .M_AXI_AWLEN(m_axi.aw_len),
    .M_AXI_AWSIZE(m_axi.aw_size),
    .M_AXI_AWBURST(m_axi.aw_burst),
    .M_AXI_AWLOCK(m_axi.aw_lock),
    .M_AXI_AWCACHE(m_axi.aw_cache),
    .M_AXI_AWPROT(m_axi.aw_prot),
    .M_AXI_AWQOS(m_axi.aw_qos),

    .M_AXI_WVALID(m_axi.w_valid),
    .M_AXI_WREADY(m_axi.w_ready),
    .M_AXI_WDATA(m_axi.w_data),
    .M_AXI_WSTRB(m_axi.w_strb),
    .M_AXI_WLAST(m_axi.w_last),

    .M_AXI_BVALID(m_axi.b_valid),
    .M_AXI_BREADY(m_axi.b_ready),
    .M_AXI_BID(m_axi.b_id),
    .M_AXI_BRESP(m_axi.b_resp),

    .M_AXI_ARVALID(m_axi.ar_valid),
    .M_AXI_ARREADY(m_axi.ar_ready),
    .M_AXI_ARID(m_axi.ar_id),
    .M_AXI_ARADDR(m_axi.ar_addr),
    .M_AXI_ARLEN(m_axi.ar_len),
    .M_AXI_ARSIZE(m_axi.ar_size),
    .M_AXI_ARBURST(m_axi.ar_burst),
    .M_AXI_ARLOCK(m_axi.ar_lock),
    .M_AXI_ARCACHE(m_axi.ar_cache),
    .M_AXI_ARQOS(m_axi.ar_qos),
    .M_AXI_ARPROT(m_axi.ar_prot),

    .M_AXI_RVALID(m_axi.r_valid),
    .M_AXI_RREADY(m_axi.r_ready),
    .M_AXI_RID(m_axi.r_id),
    .M_AXI_RDATA(m_axi.r_data),
    .M_AXI_RRESP(m_axi.r_resp),
    .M_AXI_RLAST(m_axi.r_last)
  );

  assign s_axi.b_user    = '0;
  assign s_axi.r_user    = '0;

  assign m_axi.aw_region = '0;
  assign m_axi.aw_atop   = '0;
  assign m_axi.aw_user   = '0;
  assign m_axi.w_user    = '0;
  assign m_axi.ar_region = '0;
  assign m_axi.ar_user   = '0;

endmodule
