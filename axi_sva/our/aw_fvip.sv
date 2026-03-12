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

  a_valid_not_unknown:
    `ASSUME property (not_unknown(aw_valid));
  a_ready_not_unknown:
    `ASSERT property (not_unknown(aw_ready));

  a_id_stall_stable:
    `ASSUME property (stable_next_when(aw_id, stall));
  a_id_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_id, aw_valid));

  a_addr_stall_stable:
    `ASSUME property (stable_next_when(aw_addr, stall));
  a_addr_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_addr, aw_valid));

  a_len_stall_stable:
    `ASSUME property (stable_next_when(aw_len, stall));
  a_len_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_len, aw_valid));

  a_size_stall_stable:
    `ASSUME property (stable_next_when(aw_size, stall));
  a_size_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_size, aw_valid));

  a_burst_stall_stable:
    `ASSUME property (stable_next_when(aw_burst, stall));
  a_burst_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_burst, aw_valid));

  a_lock_stall_stable:
    `ASSUME property (stable_next_when(aw_lock, stall));
  a_lock_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_lock, aw_valid));

  a_cache_stall_stable:
    `ASSUME property (stable_next_when(aw_cache, stall));
  a_cache_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_cache, aw_valid));

  a_prot_stall_stable:
    `ASSUME property (stable_next_when(aw_prot, stall));
  a_prot_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_prot, aw_valid));

  a_qos_stall_stable:
    `ASSUME property (stable_next_when(aw_qos, stall));
  a_qos_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_qos, aw_valid));

  a_region_stall_stable:
    `ASSUME property (stable_next_when(aw_region, stall));
  a_region_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_region, aw_valid));

  a_atop_stall_stable:
    `ASSUME property (stable_next_when(aw_atop, stall));
  a_atop_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_atop, aw_valid));

  a_user_stall_stable:
    `ASSUME property (stable_next_when(aw_user, stall));
  a_user_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(aw_user, aw_valid));
endmodule

`undef ROLE
`undef ASSUME
`undef ASSERT
`undef CONCAT
