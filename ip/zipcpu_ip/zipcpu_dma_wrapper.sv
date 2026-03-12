`timescale 1ns/1ps

`include "params.svh"

module axi_dma_wrapper #(
  parameter int ADDR_W = `AXI_ADDR_W,
  parameter int DATA_W = `AXI_DATA_W,
  parameter int ID_W   = `AXI_ID_W,
  parameter int AXIL_ADDR_W = 5,
  parameter int AXIL_DATA_W = 32,
  parameter int LGMAXBURST = 4,
  parameter int LGFIFO = LGMAXBURST + 1
) (
  input  logic clk,
  input  logic rst,
  AXI_LITE.Slave s_axil,
  AXI_BUS.Master m_axi,
  output logic irq
);

  axidma #(
    .C_AXI_ID_WIDTH(ID_W),
    .C_AXI_ADDR_WIDTH(ADDR_W),
    .C_AXI_DATA_WIDTH(DATA_W),
    .LGMAXBURST(LGMAXBURST),
    .LGFIFO(LGFIFO)
  ) dut (
    .S_AXI_ACLK(clk),
    .S_AXI_ARESETN(~rst),

    .S_AXIL_AWVALID(s_axil.aw_valid),
    .S_AXIL_AWREADY(s_axil.aw_ready),
    .S_AXIL_AWADDR(s_axil.aw_addr[AXIL_ADDR_W-1:0]),
    .S_AXIL_AWPROT(s_axil.aw_prot),
    .S_AXIL_WVALID(s_axil.w_valid),
    .S_AXIL_WREADY(s_axil.w_ready),
    .S_AXIL_WDATA(s_axil.w_data[AXIL_DATA_W-1:0]),
    .S_AXIL_WSTRB(s_axil.w_strb[AXIL_DATA_W/8-1:0]),
    .S_AXIL_BVALID(s_axil.b_valid),
    .S_AXIL_BREADY(s_axil.b_ready),
    .S_AXIL_BRESP(s_axil.b_resp),
    .S_AXIL_ARVALID(s_axil.ar_valid),
    .S_AXIL_ARREADY(s_axil.ar_ready),
    .S_AXIL_ARADDR(s_axil.ar_addr[AXIL_ADDR_W-1:0]),
    .S_AXIL_ARPROT(s_axil.ar_prot),
    .S_AXIL_RVALID(s_axil.r_valid),
    .S_AXIL_RREADY(s_axil.r_ready),
    .S_AXIL_RDATA(s_axil.r_data[AXIL_DATA_W-1:0]),
    .S_AXIL_RRESP(s_axil.r_resp),

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
    .M_AXI_ARPROT(m_axi.ar_prot),
    .M_AXI_ARQOS(m_axi.ar_qos),

    .M_AXI_RVALID(m_axi.r_valid),
    .M_AXI_RREADY(m_axi.r_ready),
    .M_AXI_RID(m_axi.r_id),
    .M_AXI_RDATA(m_axi.r_data),
    .M_AXI_RLAST(m_axi.r_last),
    .M_AXI_RRESP(m_axi.r_resp),

    .o_int(irq)
  );

  assign m_axi.aw_region = '0;
  assign m_axi.aw_atop   = '0;
  assign m_axi.aw_user   = '0;
  assign m_axi.w_user    = '0;
  assign m_axi.ar_region = '0;
  assign m_axi.ar_user   = '0;

endmodule
