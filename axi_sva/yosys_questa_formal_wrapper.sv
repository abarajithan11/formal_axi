`timescale 1ns/1ps
`default_nettype none

module yosys_questa_formal_wrapper #(
  parameter int ADDR_W = 32,
  parameter int DATA_W = 32,
  parameter int ID_W = 4,
  parameter int USER_W = 1,
  parameter bit IS_SOURCE = 1'b0,
  parameter int MAX_WR_BURSTS = 4,
  parameter int MAX_RD_BURSTS = 4,
  parameter int MAX_WR_LENGTH = 8,
  parameter int MAX_RD_LENGTH = 8,
  parameter int MAXWAIT = 16
) (
  input wire clk,
  input wire rst,
  AXI_BUS.Monitor axi
);
`ifdef HAVE_YOSYS_AXI_SVA
  import amba_axi4_protocol_checker_pkg::*;

  localparam axi4_agent_t AGENT = IS_SOURCE ? SOURCE : DESTINATION;
  localparam axi4_checker_params_t CFG = '{
    ID_WIDTH:          ID_W,
    ADDRESS_WIDTH:     ADDR_W,
    DATA_WIDTH:        DATA_W,
    AWUSER_WIDTH:      USER_W,
    WUSER_WIDTH:       USER_W,
    BUSER_WIDTH:       USER_W,
    ARUSER_WIDTH:      USER_W,
    RUSER_WIDTH:       USER_W,
    MAX_WR_BURSTS:     MAX_WR_BURSTS,
    MAX_RD_BURSTS:     MAX_RD_BURSTS,
    MAX_WR_LENGTH:     MAX_WR_LENGTH,
    MAX_RD_LENGTH:     MAX_RD_LENGTH,
    MAXWAIT:           MAXWAIT,
    VERIFY_AGENT_TYPE: AGENT,
    PROTOCOL_TYPE:     AXI4FULL,
    INTERFACE_REQS:    1'b1,
    ENABLE_COVER:      1'b1,
    ENABLE_XPROP:      1'b1,
    ARM_RECOMMENDED:   1'b1,
    CHECK_PARAMETERS:  1'b1,
    OPTIONAL_WSTRB:    1'b1,
    FULL_WR_STRB:      1'b1,
    OPTIONAL_RESET:    1'b1,
    EXCLUSIVE_ACCESS:  1'b1,
    OPTIONAL_LP:       1'b0
  };

  // Questa 2023.2 fails parsing $isunbounded in the optional response-dependency
  // helper, so use a checker variant that keeps the core AXI4 channel properties.
  amba_axi4_protocol_checker_questa #(
    .cfg(CFG)
  ) u_amba_axi4_protocol_checker (
    .ACLK(clk),
    .ARESETn(~rst),
    .AWID(axi.aw_id),
    .AWADDR(axi.aw_addr),
    .AWLEN(axi.aw_len),
    .AWSIZE(axi.aw_size),
    .AWBURST(axi.aw_burst),
    .AWLOCK(axi.aw_lock),
    .AWCACHE(axi.aw_cache),
    .AWPROT(axi.aw_prot),
    .AWQOS(axi.aw_qos),
    .AWREGION(axi.aw_region),
    .AWUSER(axi.aw_user),
    .AWVALID(axi.aw_valid),
    .AWREADY(axi.aw_ready),
    .WDATA(axi.w_data),
    .WSTRB(axi.w_strb),
    .WLAST(axi.w_last),
    .WUSER(axi.w_user),
    .WVALID(axi.w_valid),
    .WREADY(axi.w_ready),
    .BID(axi.b_id),
    .BRESP(axi.b_resp),
    .BUSER(axi.b_user),
    .BVALID(axi.b_valid),
    .BREADY(axi.b_ready),
    .ARID(axi.ar_id),
    .ARADDR(axi.ar_addr),
    .ARLEN(axi.ar_len),
    .ARSIZE(axi.ar_size),
    .ARBURST(axi.ar_burst),
    .ARLOCK(axi.ar_lock),
    .ARCACHE(axi.ar_cache),
    .ARPROT(axi.ar_prot),
    .ARQOS(axi.ar_qos),
    .ARREGION(axi.ar_region),
    .ARUSER(axi.ar_user),
    .ARVALID(axi.ar_valid),
    .ARREADY(axi.ar_ready),
    .RID(axi.r_id),
    .RDATA(axi.r_data),
    .RRESP(axi.r_resp),
    .RLAST(axi.r_last),
    .RUSER(axi.r_user),
    .RVALID(axi.r_valid),
    .RREADY(axi.r_ready),
    .CSYSREQ(1'b1),
    .CSYSACK(1'b1),
    .CACTIVE(1'b1)
  );
`endif
endmodule

module amba_axi4_protocol_checker_questa
  import amba_axi4_protocol_checker_pkg::*;
   #(parameter axi4_checker_params_t cfg =
     '{ID_WIDTH:          4,
       ADDRESS_WIDTH:     32,
       DATA_WIDTH:        64,
       AWUSER_WIDTH:      32,
       WUSER_WIDTH:       32,
       BUSER_WIDTH:       32,
       ARUSER_WIDTH:      32,
       RUSER_WIDTH:       32,
       MAX_WR_BURSTS:     4,
       MAX_RD_BURSTS:     4,
       MAX_WR_LENGTH:     8,
       MAX_RD_LENGTH:     8,
       MAXWAIT:           16,
       VERIFY_AGENT_TYPE: SOURCE,
       PROTOCOL_TYPE:     AXI4LITE,
       INTERFACE_REQS:    1,
       ENABLE_COVER:      1,
       ENABLE_XPROP:      1,
       ARM_RECOMMENDED:   1,
       CHECK_PARAMETERS:  1,
       OPTIONAL_WSTRB:    1,
       FULL_WR_STRB:      1,
       OPTIONAL_RESET:    1,
       EXCLUSIVE_ACCESS:  1,
       OPTIONAL_LP:       1},
     localparam unsigned STRB_WIDTH = cfg.DATA_WIDTH/8)
   (input wire                         ACLK,
    input wire                         ARESETn,
    input wire [cfg.ID_WIDTH-1:0]      AWID,
    input wire [cfg.ADDRESS_WIDTH-1:0] AWADDR,
    input wire [7:0]                   AWLEN,
    input wire [2:0]                   AWSIZE,
    input wire [1:0]                   AWBURST,
    input wire                         AWLOCK,
    input wire [3:0]                   AWCACHE,
    input wire [2:0]                   AWPROT,
    input wire [3:0]                   AWQOS,
    input wire [3:0]                   AWREGION,
    input wire [cfg.AWUSER_WIDTH-1:0]  AWUSER,
    input wire                         AWVALID,
    input wire                         AWREADY,
    input wire [cfg.DATA_WIDTH-1:0]    WDATA,
    input wire [STRB_WIDTH-1:0]        WSTRB,
    input wire                         WLAST,
    input wire [cfg.WUSER_WIDTH-1:0]   WUSER,
    input wire                         WVALID,
    input wire                         WREADY,
    input wire [cfg.ID_WIDTH-1:0]      BID,
    input wire [1:0]                   BRESP,
    input wire [cfg.BUSER_WIDTH-1:0]   BUSER,
    input wire                         BVALID,
    input wire                         BREADY,
    input wire [cfg.ID_WIDTH-1:0]      ARID,
    input wire [cfg.ADDRESS_WIDTH-1:0] ARADDR,
    input wire [7:0]                   ARLEN,
    input wire [2:0]                   ARSIZE,
    input wire [1:0]                   ARBURST,
    input wire                         ARLOCK,
    input wire [3:0]                   ARCACHE,
    input wire [2:0]                   ARPROT,
    input wire [3:0]                   ARQOS,
    input wire [3:0]                   ARREGION,
    input wire [cfg.ARUSER_WIDTH-1:0]  ARUSER,
    input wire                         ARVALID,
    input wire                         ARREADY,
    input wire [cfg.ID_WIDTH-1:0]      RID,
    input wire [cfg.DATA_WIDTH-1:0]    RDATA,
    input wire [1:0]                   RRESP,
    input wire                         RLAST,
    input wire [cfg.RUSER_WIDTH-1:0]   RUSER,
    input wire                         RVALID,
    input wire                         RREADY,
    input wire                         CSYSREQ,
    input wire                         CSYSACK,
    input wire                         CACTIVE);

   amba_axi4_write_address_channel #(.cfg(cfg)) AW_channel_checker(.*);
   amba_axi4_write_data_channel #(.cfg(cfg)) W_channel_checker(.*);
   amba_axi4_write_response_channel #(.cfg(cfg)) B_channel_checker(.*);
   amba_axi4_read_address_channel #(.cfg(cfg)) AR_channel_checker(.*);
   amba_axi4_read_data_channel #(.cfg(cfg)) R_channel_checker(.*);
   amba_axi4_low_power_channel #(.cfg(cfg)) LP_channel_checker(.*);
   amba_axi4_exclusive_access_source_perspective
     #(.cfg(cfg)) yosyshq_amba4_exclusive_abstract_checker(.*);
endmodule

`default_nettype wire
