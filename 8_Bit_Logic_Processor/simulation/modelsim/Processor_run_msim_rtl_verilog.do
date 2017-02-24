transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+E:/ece385-master/8BitLogicProcessor {E:/ece385-master/8BitLogicProcessor/Router.sv}
vlog -sv -work work +incdir+E:/ece385-master/8BitLogicProcessor {E:/ece385-master/8BitLogicProcessor/HexDriver.sv}
vlog -sv -work work +incdir+E:/ece385-master/8BitLogicProcessor {E:/ece385-master/8BitLogicProcessor/Control.sv}
vlog -sv -work work +incdir+E:/ece385-master/8BitLogicProcessor {E:/ece385-master/8BitLogicProcessor/compute.sv}
vlog -sv -work work +incdir+E:/ece385-master/8BitLogicProcessor {E:/ece385-master/8BitLogicProcessor/Reg_8.sv}
vlog -sv -work work +incdir+E:/ece385-master/8BitLogicProcessor {E:/ece385-master/8BitLogicProcessor/sync.sv}
vlog -sv -work work +incdir+E:/ece385-master/8BitLogicProcessor {E:/ece385-master/8BitLogicProcessor/Register_unit.sv}
vlog -sv -work work +incdir+E:/ece385-master/8BitLogicProcessor {E:/ece385-master/8BitLogicProcessor/Processor.sv}

vlog -sv -work work +incdir+E:/ece385-master/8BitLogicProcessor {E:/ece385-master/8BitLogicProcessor/testbench_8.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  Test Bench 8

add wave *
view structure
view signals
run 1000 ns
