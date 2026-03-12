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

module `CONCAT(`ROLE,_w_fvip) #(
  parameter int DATA_W = 32,
  parameter int USER_W = 1
) (
  input logic clk,
  input logic rstn,
  input logic w_valid,
  input logic w_ready,
  input logic [DATA_W-1:0] w_data,
  input logic [DATA_W/8-1:0] w_strb,
  input logic w_last,
  input logic [USER_W-1:0] w_user
);
  import pkg_axi_fvip::*;

  default clocking cb @(posedge clk); endclocking
  default disable iff (!rstn);

  wire stall = w_valid && !w_ready;
  wire hsk = w_valid && w_ready;
  wire hsk_last = hsk && w_last;

  a_valid_not_unknown:
    `ASSUME property (not_unknown(w_valid));
  a_ready_not_unknown:
    `ASSERT property (not_unknown(w_ready));

  a_data_stall_stable:
    `ASSUME property (stable_next_when(w_data, stall));
  a_data_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(w_data, w_valid));

  a_strb_stall_stable:
    `ASSUME property (stable_next_when(w_strb, stall));
  a_strb_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(w_strb, w_valid));

  a_last_stall_stable:
    `ASSUME property (stable_next_when(w_last, stall));
  a_last_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(w_last, w_valid));

  a_user_stall_stable:
    `ASSUME property (stable_next_when(w_user, stall));
  a_user_not_unknown_when_valid:
    `ASSUME property (not_unknown_when(w_user, w_valid));
endmodule

`undef ROLE
`undef ASSUME
`undef ASSERT
`undef CONCAT
