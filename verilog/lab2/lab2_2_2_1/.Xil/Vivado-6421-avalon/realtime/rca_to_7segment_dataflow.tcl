# 
# Synthesis run script generated by Vivado
# 

namespace eval rt {
    variable rc
}
set rt::rc [catch {
  uplevel #0 {
    set ::env(BUILTIN_SYNTH) true
    source $::env(HRT_TCL_PATH)/rtSynthPrep.tcl
    rt::HARTNDb_resetJobStats
    rt::HARTNDb_startJobStats
    set rt::cmdEcho 0
    rt::set_parameter writeXmsg true
    rt::set_parameter enableParallelHelperSpawn true
    set ::env(RT_TMP) "./.Xil/Vivado-6421-avalon/realtime/tmp"
    if { [ info exists ::env(RT_TMP) ] } {
      file delete -force $::env(RT_TMP)
      file mkdir $::env(RT_TMP)
    }

    rt::delete_design

    set rt::partid xc7a100tcsg324-1

    set rt::multiChipSynthesisFlow false
    source $::env(SYNTH_COMMON)/common.tcl
    set rt::defaultWorkLibName xil_defaultlib

    set rt::useElabCache false
    if {$rt::useElabCache == false} {
      rt::read_verilog {
      /home/sabertazimi/gitrepo/hust-lab/verilog/lab2/lab2_2_2_1/lab2_2_2_1.srcs/sources_1/new/lab2_circuitA_dataflow.v
      /home/sabertazimi/gitrepo/hust-lab/verilog/lab2/lab2_2_2_1/lab2_2_2_1.srcs/sources_1/new/comparator_dataflow.v
      /home/sabertazimi/gitrepo/hust-lab/verilog/lab2/lab2_1/lab2_1.srcs/sources_1/new/mux_2_to_1_gate.v
      /home/sabertazimi/gitrepo/hust-lab/verilog/lab2/lab2_2_2_1/lab2_2_2_1.srcs/sources_1/new/lab2_2_2_1_partA.v
      /home/sabertazimi/gitrepo/hust-lab/verilog/lab2/lab2_1/lab2_1.srcs/sources_1/new/bcd_to_7segment_decoder.v
      /home/sabertazimi/gitrepo/hust-lab/verilog/lab2/lab2_2_3_1/lab2_2_3_1.srcs/sources_1/new/fulladder_dataflow.v
      /home/sabertazimi/gitrepo/hust-lab/verilog/lab2/lab2_2_2_1/lab2_2_2_1.srcs/sources_1/new/lab2_2_2_1.v
      /home/sabertazimi/gitrepo/hust-lab/verilog/lab2/lab2_2_3_1/lab2_2_3_1.srcs/sources_1/new/rca_dataflow.v
      /home/sabertazimi/gitrepo/hust-lab/verilog/lab2/lab2_2_3_2/lab2_2_3_2.srcs/sources_1/new/rca_to_7segment_dataflow.v
    }
      rt::filesetChecksum
    }
    rt::set_parameter usePostFindUniquification false
    set rt::top rca_to_7segment_dataflow
    set rt::reportTiming false
    rt::set_parameter elaborateOnly true
    rt::set_parameter elaborateRtl true
    rt::set_parameter eliminateRedundantBitOperator false
    rt::set_parameter writeBlackboxInterface true
    rt::set_parameter merge_flipflops true
    rt::set_parameter srlDepthThreshold 3
    rt::set_parameter rstSrlDepthThreshold 4
# MODE: 
    rt::set_parameter webTalkPath {}
    rt::set_parameter enableSplitFlowPath "./.Xil/Vivado-6421-avalon/"
    set ok_to_delete_rt_tmp true 
    if { [rt::get_parameter parallelDebug] } { 
       set ok_to_delete_rt_tmp false 
    } 
    if {$rt::useElabCache == false} {
      rt::run_rtlelab -module $rt::top
    }

    set rt::flowresult [ source $::env(SYNTH_COMMON)/flow.tcl ]
    rt::HARTNDb_stopJobStats
    if { $rt::flowresult == 1 } { return -code error }

    if { [ info exists ::env(RT_TMP) ] } {
      if { [info exists ok_to_delete_rt_tmp] && $ok_to_delete_rt_tmp } { 
        file delete -force $::env(RT_TMP)
      }
    }


  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] && [info exists rt::doParallel] && $rt::doParallel} { 
     $rt::db killSynthHelper $hsKey
  } 
  rt::set_parameter helper_shm_key "" 
    source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  } ; #end uplevel
} rt::result]

if { $rt::rc } {
  $rt::db resetHdlParse
  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] && [info exists rt::doParallel] && $rt::doParallel} { 
     $rt::db killSynthHelper $hsKey
  } 
  source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  return -code "error" $rt::result
}