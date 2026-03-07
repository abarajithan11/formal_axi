`timescale 1ns/1ps

`include "params.svh"

module tb_axi_fifo;
  logic clk;
  logic rst;

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    rst = 1'b1;
    #20;
    rst = 1'b0;
  end

  AXI_BUS #(
    .AXI_ADDR_WIDTH(`AXI_ADDR_W),
    .AXI_DATA_WIDTH(`AXI_DATA_W),
    .AXI_ID_WIDTH(`AXI_ID_W),
    .AXI_USER_WIDTH(`AXI_USER_W)
  ) s_axi();

  AXI_BUS #(
    .AXI_ADDR_WIDTH(`AXI_ADDR_W),
    .AXI_DATA_WIDTH(`AXI_DATA_W),
    .AXI_ID_WIDTH(`AXI_ID_W),
    .AXI_USER_WIDTH(`AXI_USER_W)
  ) m_axi();

  axi_fifo_wrapper dut (
    .clk(clk),
    .rst(rst),
    .s_axi(s_axi),
    .m_axi(m_axi)
  );

  cover property (@(posedge clk) !rst ##1 dut.aw_empty);

endmodule

