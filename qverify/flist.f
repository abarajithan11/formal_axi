+incdir+tb
+incdir+ip/pulp_ip/pulp_platform/axi/include
+incdir+axi_sva/yosys/AXI4/src
+incdir+axi_sva/yosys/AXI4/src/axi4_lib
+incdir+axi_sva/yosys/AXI4/src/axi4_spec
+define+HAVE_YOSYS_AXI_SVA

ip/pulp_ip/pulp_platform/axi/src/axi_pkg.sv
ip/pulp_ip/pulp_platform/axi/src/axi_intf.sv

ip/zipcpu_ip/wb2axip/rtl/sfifo.v
ip/zipcpu_ip/wb2axip/rtl/skidbuffer.v
ip/zipcpu_ip/wb2axip/rtl/axidma.v
ip/zipcpu_ip/wb2axip/rtl/axixbar.v
ip/zipcpu_ip/zipcpu_fifo_wrapper.sv
ip/zipcpu_ip/zipcpu_dma_wrapper.sv
ip/zipcpu_ip/zipcpu_xbar_wrapper.sv

axi_sva/yosys/AXI4/src/amba_axi4_protocol_checker_pkg.sv
axi_sva/yosys/AXI4/src/axi4_spec/amba_axi4_transaction_structure.sv
axi_sva/yosys/AXI4/src/axi4_spec/amba_axi4_transaction_attributes.sv
axi_sva/yosys/AXI4/src/axi4_spec/amba_axi4_single_interface_requirements.sv
axi_sva/yosys/AXI4/src/axi4_spec/amba_axi4_low_power_interface.sv
axi_sva/yosys/AXI4/src/axi4_spec/amba_axi4_definition_of_axi4_lite.sv
axi_sva/yosys/AXI4/src/axi4_spec/amba_axi4_atomic_accesses.sv
axi_sva/yosys/AXI4/src/axi4_lib/amba_axi4_exclusive_access_source_perspective.sv
axi_sva/yosys/AXI4/src/amba_axi4_write_address_channel.sv
axi_sva/yosys/AXI4/src/amba_axi4_write_data_channel.sv
axi_sva/yosys/AXI4/src/amba_axi4_write_response_channel.sv
axi_sva/yosys/AXI4/src/amba_axi4_read_address_channel.sv
axi_sva/yosys/AXI4/src/amba_axi4_read_data_channel.sv
axi_sva/yosys/AXI4/src/amba_axi4_low_power_channel.sv

axi_sva/yosys_questa_formal_wrapper.sv
axi_sva/zipcpu/formal_axi_master.v
axi_sva/zipcpu/formal_axi_slave.v
axi_sva/zipcpu/zipcpu_formal_wrapper.sv
axi_sva/our/pkg_axi_fvip.sv
axi_sva/s_sva_wrap.sv
axi_sva/m_sva_wrap.sv

tb/tb_fifo.sv
tb/tb_axi_fifo.sv
tb/tb_axi_dma.sv
tb/tb_axi_xbar.sv
