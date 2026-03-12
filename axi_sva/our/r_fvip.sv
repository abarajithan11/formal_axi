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

module `CONCAT(`ROLE,_r_fvip) #(
  parameter int DATA_W = 32,
  parameter int ID_W = 4,
  parameter int USER_W = 1
) (
  input logic clk,
  input logic rstn,
  input logic r_valid,
  input logic r_ready,
  input logic [ID_W-1:0] r_id,
  input logic [DATA_W-1:0] r_data,
  input logic [1:0] r_resp,
  input logic r_last,
  input logic [USER_W-1:0] r_user
);
  import pkg_axi_fvip::*;

  default clocking cb @(posedge clk); endclocking
  default disable iff (!rstn);

  wire stall = r_valid && !r_ready;
  wire hsk = r_valid && r_ready;
  wire hsk_last = hsk && r_last;

  a_valid_low_after:
    `ASSUME property (low_after(rstn, r_valid));
  a_valid_not_with_rise:
    `ASSUME property (not_with_rise(rstn, r_valid));

  a_valid_not_unknown:
    `ASSUME property (not_unknown(r_valid));
  a_ready_not_unknown:
    `ASSERT property (not_unknown(r_ready));

  c_valid_before_ready:
    cover property (valid_before_ready(r_valid, r_ready));

  a_id_stall_stable:
    `ASSUME property (stable_next_when(stall, r_id));
  a_id_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(r_valid, r_id));

  a_data_stall_stable:
    `ASSUME property (stable_next_when(stall, r_data));
  a_data_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(r_valid, r_data));

  a_resp_stall_stable:
    `ASSUME property (stable_next_when(stall, r_resp));
  a_resp_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(r_valid, r_resp));

  a_last_stall_stable:
    `ASSUME property (stable_next_when(stall, r_last));
  a_last_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(r_valid, r_last));

  a_user_stall_stable:
    `ASSUME property (stable_next_when(stall, r_user));
  a_user_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(r_valid, r_user));
endmodule

`undef ROLE
`undef ASSUME
`undef ASSERT
`undef CONCAT
