onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color {Pale Green} -radix binary /multiplier/Run
add wave -noupdate -color {Pale Green} -radix binary /multiplier/Reset
add wave -noupdate -color {Pale Green} -radix binary /multiplier/ClearA_LoadB
add wave -noupdate -color {Pale Green} -radix binary /multiplier/Switch
add wave -noupdate -color {Pale Green} -radix binary /multiplier/Clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {149435 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 181
configure wave -valuecolwidth 135
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {442503 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern constant -value 0 -starttime 0ns -endtime 1000ns sim:/multiplier/Run 
wave create -driver freeze -pattern clock -initialvalue 0 -period 50ns -dutycycle 50 -starttime 0ns -endtime 1000ns sim:/multiplier/Clk 
wave create -driver freeze -pattern clock -initialvalue 0 -period 10ns -dutycycle 50 -starttime 0ns -endtime 1000ns sim:/multiplier/Clk 
wave create -driver freeze -pattern constant -value 0 -starttime 0ns -endtime 1000ns sim:/multiplier/Run 
wave create -driver freeze -pattern constant -value 0 -starttime 0ns -endtime 1000ns sim:/multiplier/Reset 
wave create -driver freeze -pattern constant -value 0 -starttime 0ns -endtime 1000ns sim:/multiplier/ClearA_LoadB 
wave create -driver freeze -pattern constant -range 7 0 -value 00000000 -starttime 0ns -endtime 1000ns sim:/multiplier/Switch 
wave create -driver freeze -pattern clock -initialvalue 0 -period 10ns -dutycycle 50 -starttime 0ns -endtime 1000ns sim:/multiplier/Clk 
wave create -driver freeze -pattern constant -value 0 -starttime 0ns -endtime 1000ns sim:/multiplier/Run 
wave create -driver freeze -pattern constant -value 0 -starttime 0ns -endtime 1000ns sim:/multiplier/Reset 
wave create -driver freeze -pattern constant -value 0 -starttime 0ns -endtime 1000ns sim:/multiplier/ClearA_LoadB 
wave create -driver freeze -pattern constant -range 7 0 -value 00000000 -starttime 0ns -endtime 1000ns sim:/multiplier/Switch 
WaveExpandAll -1
wave create -driver freeze -pattern clock -initialvalue 0 -period 10ns -dutycycle 50 -starttime 0ns -endtime 1000ns sim:/multiplier/Clk 
wave modify -driver freeze -pattern constant -value 1 -starttime 0ns -endtime 50ns Edit:/multiplier/Reset 
wave modify -driver freeze -pattern constant -value 01111111 -range 7 0 -starttime 0ns -endtime 100ns Edit:/multiplier/Switch 
wave modify -driver freeze -pattern constant -value 1 -starttime 50ns -endtime 100ns Edit:/multiplier/ClearA_LoadB 
wave modify -driver freeze -pattern constant -value 1 -starttime 150ns -endtime 1000ns Edit:/multiplier/Run 
wave modify -driver freeze -pattern constant -value 0 -starttime 800ns -endtime 1000ns Edit:/multiplier/Run 
wave modify -driver freeze -pattern constant -value 01110000 -range 7 0 -starttime 120ns -endtime 600ns Edit:/multiplier/Switch 
WaveCollapseAll -1
wave clipboard restore
