# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/sabertazimi/Work/Source/dld/controler/controler.cache/wt [current_project]
set_property parent.project_path /home/sabertazimi/Work/Source/dld/controler/controler.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_verilog -library xil_defaultlib {
  /home/sabertazimi/Work/Source/dld/controler/controler.srcs/sources_1/new/integer_to_bcd.v
  /home/sabertazimi/Work/Source/dld/controler/controler.srcs/sources_1/new/bcd_to_segment.v
  /home/sabertazimi/Work/Source/dld/controler/controler.srcs/sources_1/new/timer.v
  /home/sabertazimi/Work/Source/dld/controler/controler.srcs/sources_1/new/time_to_segment.v
  /home/sabertazimi/Work/Source/dld/controler/controler.srcs/sources_1/new/water_let_mode.v
  /home/sabertazimi/Work/Source/dld/controler/controler.srcs/sources_1/new/selector_mode.v
  /home/sabertazimi/Work/Source/dld/controler/controler.srcs/sources_1/new/wash_mode.v
  /home/sabertazimi/Work/Source/dld/controler/controler.srcs/sources_1/new/time_display.v
  /home/sabertazimi/Work/Source/dld/controler/controler.srcs/sources_1/new/tick_divider.v
  /home/sabertazimi/Work/Source/dld/controler/controler.srcs/sources_1/new/ring.v
  /home/sabertazimi/Work/Source/dld/controler/controler.srcs/sources_1/new/dewater_mode.v
  /home/sabertazimi/Work/Source/dld/controler/controler.srcs/sources_1/new/rinse_mode.v
  /home/sabertazimi/Work/Source/dld/controler/controler.srcs/sources_1/new/controler.v
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc /home/sabertazimi/Work/Source/dld/controler/controler.srcs/constrs_1/new/washing_machine.xdc
set_property used_in_implementation false [get_files /home/sabertazimi/Work/Source/dld/controler/controler.srcs/constrs_1/new/washing_machine.xdc]


synth_design -top controler -part xc7a100tcsg324-1


write_checkpoint -force -noxdef controler.dcp

catch { report_utilization -file controler_utilization_synth.rpt -pb controler_utilization_synth.pb }
