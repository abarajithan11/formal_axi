`timescale 1ns/1ps

`include "params.svh"
`include "axi_include.svh"

module axi_fifo_wrapper #(
  parameter int ADDR_W = `AXI_ADDR_W,
  parameter int DATA_W = `AXI_DATA_W,
  parameter int ID_W   = `AXI_ID_W,
  parameter int USER_W = `AXI_USER_W,
  parameter int FIFO_DEPTH = `AXI_FIFO_DEPTH,
  parameter bit FIFO_FALL_THROUGH = `AXI_FIFO_FALL_THROUGH
) (
  input  logic clk,
  input  logic rst,
  AXI_BUS.Slave  s_axi,
  AXI_BUS.Master m_axi
);

  localparam int STRB_W = DATA_W / 8;
  localparam int LGFIFO = (FIFO_DEPTH <= 1) ? 1 : $clog2(FIFO_DEPTH);

  localparam int AW_FWD_W = ID_W + ADDR_W + 8 + 3 + 2 + 1 + 4 + 3 + 4 + 4 + 6 + USER_W;
  localparam int W_FWD_W  = DATA_W + STRB_W + 1 + USER_W;
  localparam int B_REV_W  = ID_W + 2 + USER_W;
  localparam int AR_FWD_W = ID_W + ADDR_W + 8 + 3 + 2 + 1 + 4 + 3 + 4 + 4 + USER_W;
  localparam int R_REV_W  = ID_W + DATA_W + 2 + 1 + USER_W;

  logic [AW_FWD_W-1:0] aw_data_in, aw_data_out;
  logic [W_FWD_W-1:0]  w_data_in, w_data_out;
  logic [B_REV_W-1:0]  b_data_in, b_data_out;
  logic [AR_FWD_W-1:0] ar_data_in, ar_data_out;
  logic [R_REV_W-1:0]  r_data_in, r_data_out;

  logic aw_full, aw_empty;
  logic w_full,  w_empty;
  logic b_full,  b_empty;
  logic ar_full, ar_empty;
  logic r_full,  r_empty;

  logic [LGFIFO:0] aw_fill, w_fill, b_fill, ar_fill, r_fill;

  assign aw_data_in = {
    s_axi.aw_id, s_axi.aw_addr, s_axi.aw_len, s_axi.aw_size, s_axi.aw_burst,
    s_axi.aw_lock, s_axi.aw_cache, s_axi.aw_prot, s_axi.aw_qos, s_axi.aw_region,
    s_axi.aw_atop, s_axi.aw_user
  };
  assign w_data_in = {s_axi.w_data, s_axi.w_strb, s_axi.w_last, s_axi.w_user};
  assign b_data_in = {m_axi.b_id, m_axi.b_resp, m_axi.b_user};
  assign ar_data_in = {
    s_axi.ar_id, s_axi.ar_addr, s_axi.ar_len, s_axi.ar_size, s_axi.ar_burst,
    s_axi.ar_lock, s_axi.ar_cache, s_axi.ar_prot, s_axi.ar_qos, s_axi.ar_region,
    s_axi.ar_user
  };
  assign r_data_in = {m_axi.r_id, m_axi.r_data, m_axi.r_resp, m_axi.r_last, m_axi.r_user};

  assign s_axi.aw_ready = !aw_full;
  assign s_axi.w_ready  = !w_full;
  assign s_axi.ar_ready = !ar_full;
  assign m_axi.b_ready  = !b_full;
  assign m_axi.r_ready  = !r_full;

  assign m_axi.aw_valid = !aw_empty;
  assign m_axi.w_valid  = !w_empty;
  assign s_axi.b_valid  = !b_empty;
  assign m_axi.ar_valid = !ar_empty;
  assign s_axi.r_valid  = !r_empty;

  assign {s_axi.b_id, s_axi.b_resp, s_axi.b_user} = b_data_out;
  assign {s_axi.r_id, s_axi.r_data, s_axi.r_resp, s_axi.r_last, s_axi.r_user} = r_data_out;
  assign {
    m_axi.aw_id, m_axi.aw_addr, m_axi.aw_len, m_axi.aw_size, m_axi.aw_burst,
    m_axi.aw_lock, m_axi.aw_cache, m_axi.aw_prot, m_axi.aw_qos, m_axi.aw_region,
    m_axi.aw_atop, m_axi.aw_user
  } = aw_data_out;
  assign {m_axi.w_data, m_axi.w_strb, m_axi.w_last, m_axi.w_user} = w_data_out;
  assign {
    m_axi.ar_id, m_axi.ar_addr, m_axi.ar_len, m_axi.ar_size, m_axi.ar_burst,
    m_axi.ar_lock, m_axi.ar_cache, m_axi.ar_prot, m_axi.ar_qos, m_axi.ar_region,
    m_axi.ar_user
  } = ar_data_out;

  sfifo #(
    .BW(AW_FWD_W),
    .LGFLEN(LGFIFO),
    .OPT_ASYNC_READ(FIFO_FALL_THROUGH)
  ) aw_fifo (
    .i_clk(clk),
    .i_reset(rst),
    .i_wr(s_axi.aw_valid && s_axi.aw_ready),
    .i_data(aw_data_in),
    .o_full(aw_full),
    .o_fill(aw_fill),
    .i_rd(m_axi.aw_valid && m_axi.aw_ready),
    .o_data(aw_data_out),
    .o_empty(aw_empty)
  );

  sfifo #(
    .BW(W_FWD_W),
    .LGFLEN(LGFIFO),
    .OPT_ASYNC_READ(FIFO_FALL_THROUGH)
  ) w_fifo (
    .i_clk(clk),
    .i_reset(rst),
    .i_wr(s_axi.w_valid && s_axi.w_ready),
    .i_data(w_data_in),
    .o_full(w_full),
    .o_fill(w_fill),
    .i_rd(m_axi.w_valid && m_axi.w_ready),
    .o_data(w_data_out),
    .o_empty(w_empty)
  );

  sfifo #(
    .BW(B_REV_W),
    .LGFLEN(LGFIFO),
    .OPT_ASYNC_READ(FIFO_FALL_THROUGH)
  ) b_fifo (
    .i_clk(clk),
    .i_reset(rst),
    .i_wr(m_axi.b_valid && m_axi.b_ready),
    .i_data(b_data_in),
    .o_full(b_full),
    .o_fill(b_fill),
    .i_rd(s_axi.b_valid && s_axi.b_ready),
    .o_data(b_data_out),
    .o_empty(b_empty)
  );

  sfifo #(
    .BW(AR_FWD_W),
    .LGFLEN(LGFIFO),
    .OPT_ASYNC_READ(FIFO_FALL_THROUGH)
  ) ar_fifo (
    .i_clk(clk),
    .i_reset(rst),
    .i_wr(s_axi.ar_valid && s_axi.ar_ready),
    .i_data(ar_data_in),
    .o_full(ar_full),
    .o_fill(ar_fill),
    .i_rd(m_axi.ar_valid && m_axi.ar_ready),
    .o_data(ar_data_out),
    .o_empty(ar_empty)
  );

  sfifo #(
    .BW(R_REV_W),
    .LGFLEN(LGFIFO),
    .OPT_ASYNC_READ(FIFO_FALL_THROUGH)
  ) r_fifo (
    .i_clk(clk),
    .i_reset(rst),
    .i_wr(m_axi.r_valid && m_axi.r_ready),
    .i_data(r_data_in),
    .o_full(r_full),
    .o_fill(r_fill),
    .i_rd(s_axi.r_valid && s_axi.r_ready),
    .o_data(r_data_out),
    .o_empty(r_empty)
  );

endmodule

