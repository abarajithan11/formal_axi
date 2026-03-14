`include "axi_switch_fvip.svh"

module `MODNAME_AXI #(
  parameter int ADDR_W = 32,
  parameter int DATA_W = 32,
  parameter int ID_W = 4,
  parameter int USER_W = 1
) (
  input logic clk,
  input logic rstn,

  input logic aw_valid,
  input logic aw_ready,
  input logic [ID_W-1:0] aw_id,
  input logic [ADDR_W-1:0] aw_addr,
  input logic [7:0] aw_len,
  input logic [2:0] aw_size,
  input logic [1:0] aw_burst,
  input logic aw_lock,
  input logic [3:0] aw_cache,
  input logic [2:0] aw_prot,
  input logic [3:0] aw_qos,
  input logic [3:0] aw_region,
  input logic [5:0] aw_atop,
  input logic [USER_W-1:0] aw_user,

  input logic w_valid,
  input logic w_ready,
  input logic [DATA_W-1:0] w_data,
  input logic [DATA_W/8-1:0] w_strb,
  input logic w_last,
  input logic [USER_W-1:0] w_user,

  input logic b_valid,
  input logic b_ready,
  input logic [ID_W-1:0] b_id,
  input logic [1:0] b_resp,
  input logic [USER_W-1:0] b_user,

  input logic ar_valid,
  input logic ar_ready,
  input logic [ID_W-1:0] ar_id,
  input logic [ADDR_W-1:0] ar_addr,
  input logic [7:0] ar_len,
  input logic [2:0] ar_size,
  input logic [1:0] ar_burst,
  input logic ar_lock,
  input logic [3:0] ar_cache,
  input logic [2:0] ar_prot,
  input logic [3:0] ar_qos,
  input logic [3:0] ar_region,
  input logic [USER_W-1:0] ar_user,

  input logic r_valid,
  input logic r_ready,
  input logic [ID_W-1:0] r_id,
  input logic [DATA_W-1:0] r_data,
  input logic [1:0] r_resp,
  input logic r_last,
  input logic [USER_W-1:0] r_user
);

  logic rstn_at_posedge;
  always_ff @(posedge clk) rstn_at_posedge <= rstn;

  a_rstn_rises_with_posedge:
    assume property (@(negedge clk) disable iff (0) rstn |-> rstn_at_posedge);

  `MODNAME_AW #(.ADDR_W(ADDR_W), .DATA_W(DATA_W), .ID_W(ID_W), .USER_W(USER_W)) u_aw (.*);
  `MODNAME_AR #(.ADDR_W(ADDR_W), .DATA_W(DATA_W), .ID_W(ID_W), .USER_W(USER_W)) u_ar (.*);
  `MODNAME_W  #(.DATA_W(DATA_W), .USER_W(USER_W)) u_w (.*);
  `MODNAME_R  #(.DATA_W(DATA_W), .ID_W(ID_W), .USER_W(USER_W)) u_r (.*);
  `MODNAME_B  #(.ID_W(ID_W), .USER_W(USER_W)) u_b (.*);

endmodule

`undef MODNAME_AXI
`undef MODNAME_AW
`undef MODNAME_AR
`undef MODNAME_W 
`undef MODNAME_R 
`undef MODNAME_B 