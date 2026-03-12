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

module `CONCAT(`ROLE,_ar_fvip) #(
  parameter int ADDR_W = 32,
  parameter int ID_W = 4,
  parameter int USER_W = 1
) (
  input logic clk,
  input logic rstn,
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
  input logic [USER_W-1:0] ar_user
);
  import pkg_axi_fvip::*;

  default clocking cb @(posedge clk); endclocking
  default disable iff (!rstn);

  wire stall = ar_valid && !ar_ready;
  wire hsk = ar_valid && ar_ready;

  a_valid_not_unknown:
    `ASSUME property (not_unknown(ar_valid));
  a_ready_not_unknown:
    `ASSERT property (not_unknown(ar_ready));

  a_id_stall_stable:
    `ASSUME property (stable_next_when(ar_id, stall));
  a_id_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_id, ar_valid));

  a_addr_stall_stable:
    `ASSUME property (stable_next_when(ar_addr, stall));
  a_addr_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_addr, ar_valid));

  a_len_stall_stable:
    `ASSUME property (stable_next_when(ar_len, stall));
  a_len_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_len, ar_valid));

  a_size_stall_stable:
    `ASSUME property (stable_next_when(ar_size, stall));
  a_size_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_size, ar_valid));

  a_burst_stall_stable:
    `ASSUME property (stable_next_when(ar_burst, stall));
  a_burst_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_burst, ar_valid));

  a_lock_stall_stable:
    `ASSUME property (stable_next_when(ar_lock, stall));
  a_lock_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_lock, ar_valid));

  a_cache_stall_stable:
    `ASSUME property (stable_next_when(ar_cache, stall));
  a_cache_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_cache, ar_valid));

  a_prot_stall_stable:
    `ASSUME property (stable_next_when(ar_prot, stall));
  a_prot_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_prot, ar_valid));

  a_qos_stall_stable:
    `ASSUME property (stable_next_when(ar_qos, stall));
  a_qos_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_qos, ar_valid));

  a_region_stall_stable:
    `ASSUME property (stable_next_when(ar_region, stall));
  a_region_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_region, ar_valid));

  a_user_stall_stable:
    `ASSUME property (stable_next_when(ar_user, stall));
  a_user_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_user, ar_valid));
endmodule

`undef ROLE
`undef ASSUME
`undef ASSERT
`undef CONCAT
