# Nexys4 Pin Assignments
############################
# On-board Slide Switches  #
############################
# reset,X
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets X_IBUF]
set_property PACKAGE_PIN U9 [get_ports X]
set_property IOSTANDARD LVCMOS33 [get_ports X]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets reset_IBUF]
set_property PACKAGE_PIN U8 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]
#set_property PACKAGE_PIN R7 [get_ports swt[2]]
#set_property IOSTANDARD LVCMOS33 [get_ports swt[2]]
#set_property PACKAGE_PIN R6 [get_ports swt[3]]
#set_property IOSTANDARD LVCMOS33 [get_ports swt[3]]
#set_property PACKAGE_PIN R5 [get_ports swt[4]]
#set_property IOSTANDARD LVCMOS33 [get_ports swt[4]]
#set_property PACKAGE_PIN V7 [get_ports swt[5]]
#set_property IOSTANDARD LVCMOS33 [get_ports swt[5]]
#set_property PACKAGE_PIN V6 [get_ports swt[6]]
#set_property IOSTANDARD LVCMOS33 [get_ports swt[6]]
#set_property PACKAGE_PIN V5 [get_ports swt[7]]
#set_property IOSTANDARD LVCMOS33 [get_ports swt[7]]

############################
# On-board led             #
############################
# Q4,Q3,Q2,Q1,Z
set_property PACKAGE_PIN T8 [get_ports Q1]
set_property IOSTANDARD LVCMOS33 [get_ports Q1]
set_property PACKAGE_PIN V9 [get_ports Q2]
set_property IOSTANDARD LVCMOS33 [get_ports Q2]
set_property PACKAGE_PIN R8 [get_ports Q3]
set_property IOSTANDARD LVCMOS33 [get_ports Q3]
set_property PACKAGE_PIN T6 [get_ports Q4]
set_property IOSTANDARD LVCMOS33 [get_ports Q4]
set_property PACKAGE_PIN T5 [get_ports Z]
set_property IOSTANDARD LVCMOS33 [get_ports Z]
#set_property PACKAGE_PIN T4 [get_ports led[5]]
#set_property IOSTANDARD LVCMOS33 [get_ports led[5]]
#set_property PACKAGE_PIN U7 [get_ports led[6]]
#set_property IOSTANDARD LVCMOS33 [get_ports led[6]]
#set_property PACKAGE_PIN U6 [get_ports led[7]]
#set_property IOSTANDARD LVCMOS33 [get_ports led[7]]
