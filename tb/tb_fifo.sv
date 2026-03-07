`timescale 1ns/1ps

module tb_fifo;
  localparam int BW = 32;
  localparam int LGFLEN = 2;

  logic clk;
  logic rst;
  logic wr;
  logic rd;
  logic [BW-1:0] data_i;
  logic [BW-1:0] data_o;
  logic full;
  logic empty;
  logic [LGFLEN:0] fill;

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    rst = 1'b1;
    wr = 1'b0;
    rd = 1'b0;
    data_i = '0;
    #20;
    rst = 1'b0;
  end

  sfifo #(
    .BW(BW),
    .LGFLEN(LGFLEN),
    .OPT_ASYNC_READ(1'b0)
  ) dut (
    .i_clk(clk),
    .i_reset(rst),
    .i_wr(wr),
    .i_data(data_i),
    .o_full(full),
    .o_fill(fill),
    .i_rd(rd),
    .o_data(data_o),
    .o_empty(empty)
  );

  cover property (@(posedge clk) !rst ##1 !full && empty);

endmodule

