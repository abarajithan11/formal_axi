if {[info exists ::env(FLIST)]} {
  set flist $::env(FLIST)
} else {
  set flist "qverify/flist.f"
}

if {[info exists ::env(TOP)]} {
  set top $::env(TOP)
} else {
  set top "tb_axi_fifo"
}

vlib work
vlog -sv -f $flist
formal compile -d $top
formal verify
exit
