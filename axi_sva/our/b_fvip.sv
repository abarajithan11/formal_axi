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

module `CONCAT(`ROLE,_b_fvip) #(
  parameter int ID_W = 4,
  parameter int USER_W = 1
) (
  input logic clk,
  input logic rstn,
  input logic b_valid,
  input logic b_ready,
  input logic [ID_W-1:0] b_id,
  input logic [1:0] b_resp,
  input logic [USER_W-1:0] b_user
);
  import pkg_axi_fvip::*;

  default clocking cb @(posedge clk); endclocking
  default disable iff (!rstn);

  wire stall = b_valid && !b_ready;
  wire hsk = b_valid && b_ready;

  //___________ VALID ___________

  a_valid_low_after:
    `ASSUME property (low_after(rstn, b_valid));
  a_valid_not_with_rise:
    `ASSUME property (not_with_rise(rstn, b_valid));

  a_valid_not_unknown:
    `ASSUME property (not_unknown(b_valid));
  a_ready_not_unknown:
    `ASSERT property (not_unknown(b_ready));

  c_valid_before_ready:
    cover property (valid_before_ready(b_valid, b_ready));

  //___________ ID ___________

  a_id_stall_stable:
    `ASSUME property (stable_next_when(stall, b_id));
  a_id_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(b_valid, b_id));

  //___________ RESP ___________

  a_resp_stall_stable:
    `ASSUME property (stable_next_when(stall, b_resp));
  a_resp_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(b_valid, b_resp));

  //___________ USER ___________

  a_user_stall_stable:
    `ASSUME property (stable_next_when(stall, b_user));
  a_user_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(b_valid, b_user));
endmodule

`undef ROLE
`undef ASSUME
`undef ASSERT
`undef CONCAT
