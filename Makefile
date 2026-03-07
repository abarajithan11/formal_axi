.DEFAULT_GOAL := run_formal

.PHONY: run_formal clean

IP      ?= fifo
VENDOR  ?= ZIPCPU
TB      ?= tb_axi_fifo
QVERIFY ?= qverify
ODIR    ?= log
DOFILE  ?= qverify/run_formal.do
FLIST   ?= qverify/flist.f

run_formal: clean
	TOP=$(TB) FLIST=$(FLIST) $(QVERIFY) -c -od $(ODIR) -do $(DOFILE)

clean:
	rm -rf $(ODIR) work transcript vsim.wlf
