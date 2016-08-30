# Nexys4 Pin Assignments
##########################################
# On-board Slide Switches/Button/Signal  #
##########################################
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_src_IBUF]
set_property PACKAGE_PIN E3 [get_ports clk_src]
set_property IOSTANDARD LVCMOS33 [get_ports clk_src]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets power_IBUF]
set_property PACKAGE_PIN U9 [get_ports power]
set_property IOSTANDARD LVCMOS33 [get_ports power]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets switch_en_IBUF]
set_property PACKAGE_PIN U8 [get_ports switch_en]
set_property IOSTANDARD LVCMOS33 [get_ports switch_en]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_sel[1]_IBUF]
#set_property PACKAGE_PIN R7 [get_ports clk_sel[1]]
#set_property IOSTANDARD LVCMOS33 [get_ports clk_sel[1]]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_sel[2]_IBUF]
#set_property PACKAGE_PIN R6 [get_ports clk_sel[2]]
#set_property IOSTANDARD LVCMOS33 [get_ports clk_sel[2]]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_sel[3]_IBUF]
#set_property PACKAGE_PIN R5 [get_ports clk_sel[3]]
#set_property IOSTANDARD LVCMOS33 [get_ports clk_sel[3]]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_sel[4]_IBUF]
#set_property PACKAGE_PIN V7 [get_ports clk_sel[4]]
#set_property IOSTANDARD LVCMOS33 [get_ports clk_sel[4]]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets D[3]_IBUF]
#set_property PACKAGE_PIN V6 [get_ports D[3]]
#set_property IOSTANDARD LVCMOS33 [get_ports D[3]]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets swt[7]]
#set_property PACKAGE_PIN V5 [get_ports swt[7]]
#set_property IOSTANDARD LVCMOS33 [get_ports swt[7]]

############################
# Output                   #
############################
set_property PACKAGE_PIN T8 [get_ports sig_start]
set_property IOSTANDARD LVCMOS33 [get_ports sig_start]

set_property PACKAGE_PIN V9 [get_ports sig_end]
set_property IOSTANDARD LVCMOS33 [get_ports sig_end]

#set_property PACKAGE_PIN R8 [get_ports state[2]]
#set_property IOSTANDARD LVCMOS33 [get_ports state[2]]

#set_property PACKAGE_PIN T6 [get_ports state[3]]
#set_property IOSTANDARD LVCMOS33 [get_ports state[3]]

#set_property PACKAGE_PIN T5 [get_ports Qcc_n]
#set_property IOSTANDARD LVCMOS33 [get_ports Qcc_n]

#set_property PACKAGE_PIN T4 [get_ports led[5]]
#set_property IOSTANDARD LVCMOS33 [get_ports led[5]]

#set_property PACKAGE_PIN U7 [get_ports led[6]]
#set_property IOSTANDARD LVCMOS33 [get_ports led[6]]

#set_property PACKAGE_PIN U6 [get_ports led[7]]
#set_property IOSTANDARD LVCMOS33 [get_ports led[7]]
