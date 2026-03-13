`ifdef MASTER
  `define MODNAME_AXI m_axi_fvip
  `define MODNAME_AW  m_aw_fvip
  `define MODNAME_AR  m_ar_fvip
  `define MODNAME_W   m_w_fvip
  `define MODNAME_R   s_r_fvip
  `define MODNAME_B   s_b_fvip
`else
  `define MODNAME_AXI s_axi_fvip
  `define MODNAME_AW  s_aw_fvip
  `define MODNAME_AR  s_ar_fvip
  `define MODNAME_W   s_w_fvip
  `define MODNAME_R   m_r_fvip
  `define MODNAME_B   m_b_fvip
`endif

// AW
`define MODNAME `MODNAME_AW
`ifdef MASTER
  `define ASSUME assert
  `define ASSERT assume
`else
  `define ASSUME assume
  `define ASSERT assert
`endif
`include "aw_fvip.sv"
`undef MODNAME
`undef ASSUME
`undef ASSERT

// AR
`define MODNAME `MODNAME_AR
`ifdef MASTER
  `define ASSUME assert
  `define ASSERT assume
`else
  `define ASSUME assume
  `define ASSERT assert
`endif
`include "ar_fvip.sv"
`undef MODNAME
`undef ASSUME
`undef ASSERT

// W
`define MODNAME `MODNAME_W
`ifdef MASTER
  `define ASSUME assert
  `define ASSERT assume
`else
  `define ASSUME assume
  `define ASSERT assert
`endif
`include "w_fvip.sv"
`undef MODNAME
`undef ASSUME
`undef ASSERT

// R
`define MODNAME `MODNAME_R
`ifdef MASTER
  `define ASSUME assume
  `define ASSERT assert
`else
  `define ASSUME assert
  `define ASSERT assume
`endif
`include "r_fvip.sv"
`undef MODNAME
`undef ASSUME
`undef ASSERT

// B
`define MODNAME `MODNAME_B
`ifdef MASTER
  `define ASSUME assume
  `define ASSERT assert
`else
  `define ASSUME assert
  `define ASSERT assume
`endif
`include "b_fvip.sv"
`undef MODNAME
`undef ASSUME
`undef ASSERT