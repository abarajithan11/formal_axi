`define CONCAT(a,b) a``b

`ifdef MASTER
  `define ROLE m
  `define ASSUME assert
  `define ASSERT assume
`else
  `define ROLE s
  `define ASSUME assume
  `define ASSERT assert
`endif

module `CONCAT(`ROLE,_aw_fvip) #(
  parameter int ADDR_W = 32,
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
  input logic [USER_W-1:0] aw_user
);
  import pkg_axi_fvip::*;

  default clocking cb @(posedge clk); endclocking
  default disable iff (!rstn);

  wire stall = aw_valid && !aw_ready;
  wire hsk = aw_valid && aw_ready;

  //___________ VALID ___________

  a_valid_low_after:
    `ASSUME property (low_after(rstn, aw_valid));
  a_valid_not_with_rise:
    `ASSUME property (not_with_rise(rstn, aw_valid));

  a_valid_not_unknown:
    `ASSUME property (not_unknown(aw_valid));
  a_ready_not_unknown:
    `ASSERT property (not_unknown(aw_ready));

  c_valid_before_ready:
    cover property (valid_before_ready(aw_valid, aw_ready));

  //___________ ID ___________

  a_id_stall_stable:
    `ASSUME property (stable_next_when(stall, aw_id));
  a_id_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_valid, aw_id));

  //___________ ADDR ___________

  a_addr_stall_stable:
    `ASSUME property (stable_next_when(stall, aw_addr));
  a_addr_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_valid, aw_addr));

  //___________ LEN ___________

  a_len_stall_stable:
    `ASSUME property (stable_next_when(stall, aw_len));
  a_len_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_valid, aw_len));

  //___________ SIZE ___________

  a_size_stall_stable:
    `ASSUME property (stable_next_when(stall, aw_size));
  a_size_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_valid, aw_size));

  //___________ BURST ___________

  a_burst_stall_stable:
    `ASSUME property (stable_next_when(stall, aw_burst));
  a_burst_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_valid, aw_burst));

  //___________ LOCK ___________

  a_lock_stall_stable:
    `ASSUME property (stable_next_when(stall, aw_lock));
  a_lock_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_valid, aw_lock));

  //___________ CACHE ___________

  a_cache_stall_stable:
    `ASSUME property (stable_next_when(stall, aw_cache));
  a_cache_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_valid, aw_cache));

  //___________ PROT ___________

  a_prot_stall_stable:
    `ASSUME property (stable_next_when(stall, aw_prot));
  a_prot_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_valid, aw_prot));

  //___________ QOS ___________

  a_qos_stall_stable:
    `ASSUME property (stable_next_when(stall, aw_qos));
  a_qos_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_valid, aw_qos));

  //___________ REGION ___________

  a_region_stall_stable:
    `ASSUME property (stable_next_when(stall, aw_region));
  a_region_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_valid, aw_region));

  //___________ ATOP ___________

  a_atop_stall_stable:
    `ASSUME property (stable_next_when(stall, aw_atop));
  a_atop_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_valid, aw_atop));

  //___________ USER ___________

  a_user_stall_stable:
    `ASSUME property (stable_next_when(stall, aw_user));
  a_user_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_valid, aw_user));
endmodule

`undef ROLE
`undef ASSUME
`undef ASSERT
`undef CONCAT
