.DEFAULT_GOAL := qverify

.PHONY: qverify run_fifo run_dma run_xbar compile_only compile_fifo compile_dma compile_xbar clean

VENDOR  ?= ZIPCPU
IP      ?= fifo
TB      ?= tb_axi_$(IP)
ODIR    ?= log
DOFILE  ?= qverify/run_formal.do
FLIST   ?= qverify/flist.f
COVER_VCD ?= 0

qverify: clean
	mkdir -p $(ODIR)
	TOP=$(TB) FLIST=$(FLIST) qverify -c -od $(ODIR) -do $(DOFILE)
	@set -e; \
	dump_vcds() { \
	  section="$$1"; outdir="$$2"; \
	  mkdir -p "$(ODIR)/$$outdir"; \
	  awk -v section="$$section" 'BEGIN{on=0} \
	    $$0 ~ "^Targets " section " \\([0-9]+\\)" {on=1; next} \
	    on && /^-+/ {next} \
	    on && /^$$/ {on=0; next} \
	    on {print}' "$(ODIR)/formal_verify.rpt" | \
	  while IFS= read -r prop; do \
	    [ -n "$$prop" ] || continue; \
	    db="$(ODIR)/qwave_files/$$prop.db"; \
	    [ -f "$$db" ] || continue; \
	    script -q /dev/null -c \
	      "qwave2vcd -wavefile $$db -outfile $(ODIR)/$$outdir/$${prop}.vcd" \
	      > /dev/null 2>&1; \
	  done; \
	}; \
	dump_vcds "Fired with Warnings" error; \
	[ "$(COVER_VCD)" = "1" ] && dump_vcds Covered cover || true

compile: clean
	vlib work
	vlog -sv -f $(FLIST)

clean:
	rm -rf $(ODIR) work transcript vsim.wlf
