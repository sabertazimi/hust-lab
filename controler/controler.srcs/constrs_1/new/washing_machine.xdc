# Nexys4 Pin Asswitchnments
##########################################
# On-board Slide Switches/Button/Signal  #
##########################################
set_property PACKAGE_PIN E3 [get_ports clk_src]
set_property IOSTANDARD LVCMOS33 [get_ports clk_src]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets power_IBUF]
set_property PACKAGE_PIN U9 [get_ports power]
set_property IOSTANDARD LVCMOS33 [get_ports power]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets start_pause_IBUF]
set_property PACKAGE_PIN U8 [get_ports start_pause]
set_property IOSTANDARD LVCMOS33 [get_ports start_pause]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets weight_ch_IBUF]
set_property PACKAGE_PIN R7 [get_ports weight_ch]
set_property IOSTANDARD LVCMOS33 [get_ports weight_ch]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets mode_ch_IBUF]
set_property PACKAGE_PIN R6 [get_ports mode_ch]
set_property IOSTANDARD LVCMOS33 [get_ports mode_ch]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets switch_up_hour_IBUF]
#set_property PACKAGE_PIN R5 [get_ports switch_up_hour]
#set_property IOSTANDARD LVCMOS33 [get_ports switch_up_hour]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets switch_reset_IBUF]
#set_property PACKAGE_PIN V7 [get_ports switch_reset]
#set_property IOSTANDARD LVCMOS33 [get_ports switch_reset]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets switch_upen_sec_IBUF]
#set_property PACKAGE_PIN V6 [get_ports switch_upen_sec]
#set_property IOSTANDARD LVCMOS33 [get_ports switch_upen_sec]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets switch_upen_min]
#set_property PACKAGE_PIN V5 [get_ports switch_upen_min]
#set_property IOSTANDARD LVCMOS33 [get_ports switch_upen_min]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets switch_upen_hour]
#set_property PACKAGE_PIN U4 [get_ports switch_upen_hour]
#set_property IOSTANDARD LVCMOS33 [get_ports switch_upen_hour]

############################
# Output                   #
############################

set_property PACKAGE_PIN N6 [get_ports anodes[0]]
set_property IOSTANDARD LVCMOS33 [get_ports anodes[0]]
set_property PACKAGE_PIN M6 [get_ports anodes[1]]
set_property IOSTANDARD LVCMOS33 [get_ports anodes[1]]
set_property PACKAGE_PIN M3 [get_ports anodes[2]]
set_property IOSTANDARD LVCMOS33 [get_ports anodes[2]]
set_property PACKAGE_PIN N5 [get_ports anodes[3]]
set_property IOSTANDARD LVCMOS33 [get_ports anodes[3]]
set_property PACKAGE_PIN N2 [get_ports anodes[4]]
set_property IOSTANDARD LVCMOS33 [get_ports anodes[4]]
set_property PACKAGE_PIN N4 [get_ports anodes[5]]
set_property IOSTANDARD LVCMOS33 [get_ports anodes[5]]
set_property PACKAGE_PIN L1 [get_ports anodes[6]]
set_property IOSTANDARD LVCMOS33 [get_ports anodes[6]]
set_property PACKAGE_PIN M1 [get_ports anodes[7]]
set_property IOSTANDARD LVCMOS33 [get_ports anodes[7]]

set_property PACKAGE_PIN L3 [get_ports cnodes[0]]
set_property IOSTANDARD LVCMOS33 [get_ports cnodes[0]]
set_property PACKAGE_PIN N1 [get_ports cnodes[1]]
set_property IOSTANDARD LVCMOS33 [get_ports cnodes[1]]
set_property PACKAGE_PIN L5 [get_ports cnodes[2]]
set_property IOSTANDARD LVCMOS33 [get_ports cnodes[2]]
set_property PACKAGE_PIN L4 [get_ports cnodes[3]]
set_property IOSTANDARD LVCMOS33 [get_ports cnodes[3]]
set_property PACKAGE_PIN K3 [get_ports cnodes[4]]
set_property IOSTANDARD LVCMOS33 [get_ports cnodes[4]]
set_property PACKAGE_PIN M2 [get_ports cnodes[5]]
set_property IOSTANDARD LVCMOS33 [get_ports cnodes[5]]
set_property PACKAGE_PIN L6 [get_ports cnodes[6]]
set_property IOSTANDARD LVCMOS33 [get_ports cnodes[6]]
set_property PACKAGE_PIN M4 [get_ports cnodes[7]]
set_property IOSTANDARD LVCMOS33 [get_ports cnodes[7]]

set_property PACKAGE_PIN T8 [get_ports start_pause_light]
set_property IOSTANDARD LVCMOS33 [get_ports start_pause_light]

set_property PACKAGE_PIN V9 [get_ports weight_ch_light[0]]
set_property IOSTANDARD LVCMOS33 [get_ports weight_ch_light[0]]

set_property PACKAGE_PIN R8 [get_ports weight_ch_light[1]]
set_property IOSTANDARD LVCMOS33 [get_ports weight_ch_light[1]]

set_property PACKAGE_PIN T6 [get_ports weight_ch_light[2]]
set_property IOSTANDARD LVCMOS33 [get_ports weight_ch_light[2]]

set_property PACKAGE_PIN T5 [get_ports water_in_light]
set_property IOSTANDARD LVCMOS33 [get_ports water_in_light]

set_property PACKAGE_PIN T4 [get_ports water_out_light]
set_property IOSTANDARD LVCMOS33 [get_ports water_out_light]

set_property PACKAGE_PIN U7 [get_ports washing_light]
set_property IOSTANDARD LVCMOS33 [get_ports washing_light]

set_property PACKAGE_PIN U6 [get_ports rinsing_light]
set_property IOSTANDARD LVCMOS33 [get_ports rinsing_light]

set_property PACKAGE_PIN U4 [get_ports dewatering_light]
set_property IOSTANDARD LVCMOS33 [get_ports dewatering_light]