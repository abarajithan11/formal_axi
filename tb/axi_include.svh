`ifndef FRAMEWORK_AXI_INCLUDE_SVH
`define FRAMEWORK_AXI_INCLUDE_SVH

`define AXI_CMD_STRUCT(TYPE, ADDR_W, DATA_W, ID_W, USER_W) \
  struct TYPE { \
    logic [ID_W-1:0] id; \
    logic [ADDR_W-1:0] addr; \
    logic [7:0] len; \
    logic [2:0] size; \
    logic [1:0] burst; \
    logic lock; \
    logic [3:0] cache; \
    logic [2:0] prot; \
    logic [3:0] qos; \
    logic [3:0] region; \
    logic [5:0] atop; \
    logic [USER_W-1:0] auser; \
    logic [DATA_W-1:0] data; \
    logic [DATA_W/8-1:0] strb; \
    logic [USER_W-1:0] wuser; \
  }

`endif
