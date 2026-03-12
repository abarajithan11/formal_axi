`timescale 1ns/1ps

`include "params.svh"

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

  yosys_questa_formal_wrapper #(
    .ADDR_W(ADDR_W),
    .DATA_W(DATA_W),
    .ID_W(ID_W),
    .USER_W(USER_W),
    .IS_SOURCE(1'b1)
  ) u_yosys (
    .clk(clk),
    .rst(rst),
    .axi(axi)
  );

  // f_axi_m_wrapper #(
  //   .ADDR_W(ADDR_W),
  //   .DATA_W(DATA_W),
  //   .ID_W(ID_W)
  // ) u_zipcpu (
  //   .clk(clk),
  //   .rst(rst),
  //   .axi(axi)
  // );
endmodule
