// Default is AXI_MASTER, to drive a slave

`ifdef MASTER
  `define AXI_FVIP_MASTER_AW
  `define AXI_FVIP_MASTER_AR
  `define AXI_FVIP_MASTER_W
  `define AXI_FVIP_SLAVE_R
  `define AXI_FVIP_SLAVE_B

  `define MODNAME_AXI m_axi_fvip
  `define MODNAME_AW  m_aw_fvip
  `define MODNAME_AR  m_ar_fvip
  `define MODNAME_W   m_w_fvip
  `define MODNAME_R   s_r_fvip
  `define MODNAME_B   s_b_fvip
`else
  `define AXI_FVIP_SLAVE_AW
  `define AXI_FVIP_SLAVE_AR
  `define AXI_FVIP_SLAVE_W
  `define AXI_FVIP_MASTER_R
  `define AXI_FVIP_MASTER_B

  `define MODNAME_AXI s_axi_fvip
  `define MODNAME_AW  s_aw_fvip
  `define MODNAME_AR  s_ar_fvip
  `define MODNAME_W   s_w_fvip
  `define MODNAME_R   m_r_fvip
  `define MODNAME_B   m_b_fvip
`endif

`include "aw_fvip.sv"
`include "ar_fvip.sv"
`include "w_fvip.sv"
`include "r_fvip.sv"
`include "b_fvip.sv"

`ifdef MASTER
  `undef AXI_FVIP_MASTER_AW
  `undef AXI_FVIP_MASTER_AR
  `undef AXI_FVIP_MASTER_W
  `undef AXI_FVIP_SLAVE_R
  `undef AXI_FVIP_SLAVE_B
`else
  `undef AXI_FVIP_SLAVE_AW
  `undef AXI_FVIP_SLAVE_AR
  `undef AXI_FVIP_SLAVE_W
  `undef AXI_FVIP_MASTER_R
  `undef AXI_FVIP_MASTER_B
`endif
