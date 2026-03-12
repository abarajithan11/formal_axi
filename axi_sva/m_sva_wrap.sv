`timescale 1ns/1ps

`include "params.svh"
`define MASTER
`include "axi_sva/our/axi_fvip.sv"
`undef MASTER

module m_sva_wrap #(
  parameter int ADDR_W = `AXI_ADDR_W,
  parameter int DATA_W = `AXI_DATA_W,
  parameter int ID_W = `AXI_ID_W,
  parameter int USER_W = `AXI_USER_W
) (
  input logic clk,
  input logic rst,
  AXI_BUS.Monitor axi
);
// `ifdef HAVE_ARM_AXI_SVA
//   arm_formal_wrapper #(
//     .ADDR_W(ADDR_W),
//     .DATA_W(DATA_W),
//     .ID_W(ID_W),
//     .USER_W(USER_W)
//   ) u_arm (
//     .clk(clk),
//     .rst(rst),
//     .axi(axi)
//   );
// `endif

  // yosys_questa_formal_wrapper #(
  //   .ADDR_W(ADDR_W),
  //   .DATA_W(DATA_W),
  //   .ID_W(ID_W),
  //   .USER_W(USER_W),
  //   .IS_SOURCE(1'b1)
  // ) u_yosys (
  //   .clk(clk),
  //   .rst(rst),
  //   .axi(axi)
  // );

  // f_axi_m_wrapper #(
  //   .ADDR_W(ADDR_W),
  //   .DATA_W(DATA_W),
  //   .ID_W(ID_W)
  // ) u_zipcpu (
  //   .clk(clk),
  //   .rst(rst),
  //   .axi(axi)
  // );

  m_axi_fvip #(
    .ADDR_W(ADDR_W),
    .DATA_W(DATA_W),
    .ID_W(ID_W),
    .USER_W(USER_W)
  ) u_our (
    .clk(clk),
    .rstn(~rst),
    .aw_valid(axi.aw_valid),
    .aw_ready(axi.aw_ready),
    .aw_id(axi.aw_id),
    .aw_addr(axi.aw_addr),
    .aw_len(axi.aw_len),
    .aw_size(axi.aw_size),
    .aw_burst(axi.aw_burst),
    .aw_lock(axi.aw_lock),
    .aw_cache(axi.aw_cache),
    .aw_prot(axi.aw_prot),
    .aw_qos(axi.aw_qos),
    .aw_region(axi.aw_region),
    .aw_atop(axi.aw_atop),
    .aw_user(axi.aw_user),
    .w_valid(axi.w_valid),
    .w_ready(axi.w_ready),
    .w_data(axi.w_data),
    .w_strb(axi.w_strb),
    .w_last(axi.w_last),
    .w_user(axi.w_user),
    .b_valid(axi.b_valid),
    .b_ready(axi.b_ready),
    .b_id(axi.b_id),
    .b_resp(axi.b_resp),
    .b_user(axi.b_user),
    .ar_valid(axi.ar_valid),
    .ar_ready(axi.ar_ready),
    .ar_id(axi.ar_id),
    .ar_addr(axi.ar_addr),
    .ar_len(axi.ar_len),
    .ar_size(axi.ar_size),
    .ar_burst(axi.ar_burst),
    .ar_lock(axi.ar_lock),
    .ar_cache(axi.ar_cache),
    .ar_prot(axi.ar_prot),
    .ar_qos(axi.ar_qos),
    .ar_region(axi.ar_region),
    .ar_user(axi.ar_user),
    .r_valid(axi.r_valid),
    .r_ready(axi.r_ready),
    .r_id(axi.r_id),
    .r_data(axi.r_data),
    .r_resp(axi.r_resp),
    .r_last(axi.r_last),
    .r_user(axi.r_user)
  );
endmodule
