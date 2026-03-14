`timescale 1ns/1ps

`include "params.svh"

module tb_axi_dma;
  logic clk;
  logic rst;
  logic irq;

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    rst = 1'b1;
    #20;
    rst = 1'b0;
  end

  AXI_LITE #(
    .AXI_ADDR_WIDTH(5),
    .AXI_DATA_WIDTH(32)
  ) s_axil();

  AXI_BUS #(
    .AXI_ADDR_WIDTH(`AXI_ADDR_W),
    .AXI_DATA_WIDTH(`AXI_DATA_W),
    .AXI_ID_WIDTH(`AXI_ID_W),
    .AXI_USER_WIDTH(`AXI_USER_W)
  ) m_axi();

  axi_dma_wrapper dut (
    .clk(clk),
    .rst(rst),
    .s_axil(s_axil),
    .m_axi(m_axi),
    .irq(irq)
  );

  s_sva_wrap #(
    .ADDR_W(`AXI_ADDR_W),
    .DATA_W(`AXI_DATA_W),
    .ID_W(`AXI_ID_W),
    .USER_W(`AXI_USER_W)
  ) u_s_sva_wrap (
    .clk(clk),
    .rst(rst),
    .axi(m_axi)
  );

  cover property (@(posedge clk) !rst ##[1:16] m_axi.aw_valid);
  cover property (@(posedge clk) irq);

endmodule
