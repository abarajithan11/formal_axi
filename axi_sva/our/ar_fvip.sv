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
  parameter int DATA_W = 32,
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

  //___________ VALID ___________

  a_valid_low_after:
    `ASSUME property (low_after(rstn, ar_valid));
  a_valid_not_with_rise:
    `ASSUME property (not_with_rise(rstn, ar_valid));

  a_valid_not_unknown:
    `ASSUME property (not_unknown(ar_valid));
  a_ready_not_unknown:
    `ASSERT property (not_unknown(ar_ready));

  a_valid_stall:
    `ASSUME property (stable_next_when(stall, ar_valid));

  c_valid_before_ready:
    cover property (valid_before_ready(ar_valid, ar_ready));

  //___________ ID ___________

  a_id_stall_stable:
    `ASSUME property (stable_next_when(stall, ar_id));
  a_id_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_valid, ar_id));

  //___________ ADDR ___________

  a_addr_stall_stable:
    `ASSUME property (stable_next_when(stall, ar_addr));
  a_addr_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_valid, ar_addr));

  //___________ LEN ___________

  a_len_stall_stable:
    `ASSUME property (stable_next_when(stall, ar_len));
  a_len_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_valid, ar_len));

  //___________ SIZE ___________

  a_size_stall_stable:
    `ASSUME property (stable_next_when(stall, ar_size));
  a_size_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_valid, ar_size));

  //___________ BURST ___________

  a_burst_stall_stable:
    `ASSUME property (stable_next_when(stall, ar_burst));
  a_burst_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_valid, ar_burst));
  a_burst_size_max:
    `ASSUME property (burst_size_max(ar_valid, ar_size, DATA_W));
  a_burst_not_reserved:
    `ASSUME property (burst_not_reserved(ar_valid, ar_burst));
  a_burst_fixed_len:
    `ASSUME property (fixed_len(ar_valid, ar_burst, ar_len));
  a_burst_wrap_len:
    `ASSUME property (wrap_len(ar_valid, ar_burst, ar_len));
  a_burst_no_4kb_cross:
    `ASSUME property (no_4kb_cross(ar_valid, ar_burst, ar_addr, ar_len, ar_size));
  a_burst_wrap_aligned:
    `ASSUME property (wrap_addr_aligned(ar_valid, ar_burst, ar_addr, ar_size));

  //___________ LOCK ___________

  a_lock_stall_stable:
    `ASSUME property (stable_next_when(stall, ar_lock));
  a_lock_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_valid, ar_lock));
  a_excl_len:
    `ASSUME property (excl_len(ar_valid, ar_lock, ar_len));
  a_excl_bytes_pow2:
    `ASSUME property (excl_bytes_pow2(ar_valid, ar_lock, ar_len, ar_size));
  a_excl_max_bytes:
    `ASSUME property (excl_max_bytes(ar_valid, ar_lock, ar_len, ar_size));
  a_excl_addr_aligned:
    `ASSUME property (excl_addr_aligned(ar_valid, ar_lock, ar_addr, ar_len, ar_size));
  a_excl_cache:
    `ASSUME property (excl_cache(ar_valid, ar_lock, ar_cache));

  //___________ CACHE ___________

  a_cache_stall_stable:
    `ASSUME property (stable_next_when(stall, ar_cache));
  a_cache_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_valid, ar_cache));
  a_cache_non_mod:
    `ASSUME property (cache_non_mod(ar_valid, ar_cache));

  //___________ PROT ___________

  a_prot_stall_stable:
    `ASSUME property (stable_next_when(stall, ar_prot));
  a_prot_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_valid, ar_prot));

  //___________ QOS ___________

  a_qos_stall_stable:
    `ASSUME property (stable_next_when(stall, ar_qos));
  a_qos_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_valid, ar_qos));

  //___________ REGION ___________

  a_region_stall_stable:
    `ASSUME property (stable_next_when(stall, ar_region));
  a_region_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_valid, ar_region));

  //___________ USER ___________

  a_user_stall_stable:
    `ASSUME property (stable_next_when(stall, ar_user));
  a_user_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(ar_valid, ar_user));
endmodule

`undef ROLE
`undef ASSUME
`undef ASSERT
`undef CONCAT
