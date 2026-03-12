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

  a_valid_not_unknown:
    `ASSUME property (not_unknown(r_valid));
  a_ready_not_unknown:
    `ASSERT property (not_unknown(r_ready));

  a_id_stall_stable:
    `ASSUME property (stable_next_when(r_id, stall));
  a_id_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(r_id, r_valid));

  a_data_stall_stable:
    `ASSUME property (stable_next_when(r_data, stall));
  a_data_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(r_data, r_valid));

  a_resp_stall_stable:
    `ASSUME property (stable_next_when(r_resp, stall));
  a_resp_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(r_resp, r_valid));

  a_last_stall_stable:
    `ASSUME property (stable_next_when(r_last, stall));
  a_last_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(r_last, r_valid));

  a_user_stall_stable:
    `ASSUME property (stable_next_when(r_user, stall));
  a_user_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(r_user, r_valid));
endmodule

`undef ROLE
`undef ASSUME
`undef ASSERT
`undef CONCAT
