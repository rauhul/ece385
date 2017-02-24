transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/rmathur2/ece385/LC3 {C:/Users/rmathur2/ece385/LC3/tristate.sv}
vlog -sv -work work +incdir+C:/Users/rmathur2/ece385/LC3 {C:/Users/rmathur2/ece385/LC3/SLC3_2.sv}
vlog -sv -work work +incdir+C:/Users/rmathur2/ece385/LC3 {C:/Users/rmathur2/ece385/LC3/register.sv}
vlog -sv -work work +incdir+C:/Users/rmathur2/ece385/LC3 {C:/Users/rmathur2/ece385/LC3/mux.sv}
vlog -sv -work work +incdir+C:/Users/rmathur2/ece385/LC3 {C:/Users/rmathur2/ece385/LC3/Mem2IO.sv}
vlog -sv -work work +incdir+C:/Users/rmathur2/ece385/LC3 {C:/Users/rmathur2/ece385/LC3/ISDU.sv}
vlog -sv -work work +incdir+C:/Users/rmathur2/ece385/LC3 {C:/Users/rmathur2/ece385/LC3/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/rmathur2/ece385/LC3 {C:/Users/rmathur2/ece385/LC3/bus.sv}
vlog -sv -work work +incdir+C:/Users/rmathur2/ece385/LC3 {C:/Users/rmathur2/ece385/LC3/alu.sv}
vlog -sv -work work +incdir+C:/Users/rmathur2/ece385/LC3 {C:/Users/rmathur2/ece385/LC3/test_memory.sv}
vlog -sv -work work +incdir+C:/Users/rmathur2/ece385/LC3 {C:/Users/rmathur2/ece385/LC3/slc3.sv}

