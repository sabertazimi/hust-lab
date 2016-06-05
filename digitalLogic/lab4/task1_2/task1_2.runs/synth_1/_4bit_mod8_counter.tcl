# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/sabertazimi/gitrepo/hust-lab/digitalLogic/lab4/task1_2/task1_2.cache/wt [current_project]
set_property parent.project_path /home/sabertazimi/gitrepo/hust-lab/digitalLogic/lab4/task1_2/task1_2.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_verilog -library xil_defaultlib {
  /home/sabertazimi/gitrepo/hust-lab/digitalLogic/lab4/task1_2/task1_2.srcs/sources_1/new/_4bit_binary_counter.v
  /home/sabertazimi/gitrepo/hust-lab/digitalLogic/lab4/task1_2/task1_2.srcs/sources_1/new/_4bit_mod8_counter.v
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc /home/sabertazimi/gitrepo/hust-lab/digitalLogic/lab4/task1_2/task1_2.srcs/constrs_1/new/_4bit_mod8_counter.xdc
set_property used_in_implementation false [get_files /home/sabertazimi/gitrepo/hust-lab/digitalLogic/lab4/task1_2/task1_2.srcs/constrs_1/new/_4bit_mod8_counter.xdc]


synth_design -top _4bit_mod8_counter -part xc7a100tcsg324-1


write_checkpoint -force -noxdef _4bit_mod8_counter.dcp

catch { report_utilization -file _4bit_mod8_counter_utilization_synth.rpt -pb _4bit_mod8_counter_utilization_synth.pb }
