force -freeze sim:/vgagenerator/fpga_clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/vgagenerator/rst 1 0
run
force -freeze sim:/vgagenerator/rst 0 0
run 10000
