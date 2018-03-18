# This script is created by ck

#===================================
#     Simulation parameters setup
#===================================
set val(stop)   10.0                         ;# time of simulation end

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#定义不同数据流的颜色
$ns color 1 Blue  ;#1为蓝色
$ns color 2 Red  ;#2为红色
$ns color 3 Yellow  ;#3为黄色
$ns color 4 Pink  ;#4为紫色
#Open the NS trace file
set tracefile [open final.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open final.nam w]
$ns namtrace-all $namfile

#===================================
#        Nodes Definition        
#===================================
#Create 0 nodes
for {set i 0} {$i < 411} {incr i} {
  set n($i) [$ns node]
}
for {set i 0} {$i < 50} {incr i} {
  set nt($i) [$ns node]
}

# cademy: 0-249
# room: 250-400
# router: 400-411
# library: 401-449;

#===================================
#        Links Definition
#===================================
for {set i 0} {$i < 50} {incr i} {
  $ns duplex-link $n($i) $n(400) 1Mb 10ms DropTail
}
for {set i 50} {$i < 100} {incr i} {
  $ns duplex-link $n($i) $n(401) 1Mb 10ms DropTail
}
for {set i 100} {$i < 150} {incr i} {
  $ns duplex-link $n($i) $n(402) 1Mb 10ms DropTail
}
for {set i 150} {$i < 200} {incr i} {
  $ns duplex-link $n($i) $n(403) 1Mb 10ms DropTail
}
for {set i 200} {$i < 250} {incr i} {
  $ns duplex-link $n($i) $n(404) 1Mb 10ms DropTail
}
for {set i 250} {$i < 300} {incr i} {
  $ns duplex-link $n($i) $n(405) 1Mb 10ms DropTail
}
for {set i 300} {$i < 350} {incr i} {
  $ns duplex-link $n($i) $n(406) 1Mb 10ms DropTail
}
for {set i 350} {$i < 400} {incr i} {
  $ns duplex-link $n($i) $n(407) 1Mb 10ms DropTail
}
for {set i 0} {$i < 50} {incr i} {
  $ns duplex-link $nt($i) $n(408) 1Mb 10ms DropTail
}
for {set i 400} {$i < 405} {incr i} {
  $ns duplex-link $n($i) $n(409) 1Mb 10ms DropTail
}
for {set i 405} {$i < 408} {incr i} {
  $ns duplex-link $n($i) $n(410) 1Mb 10ms DropTail
}

# router connection
$ns duplex-link $n(408) $n(409) 1Mb 10ms DropTail
$ns duplex-link $n(409) $n(410) 1Mb 10ms DropTail
$ns duplex-link $n(408) $n(410) 1Mb 10ms DropTail

#Give node position (for NAM)

#===================================
#        Agents Definition        
#===================================
for {set i 0} {$i < 400} {incr i} {
  for {set j 0} {$j < 50} {incr j} {
    set tcp($i,$j) [new Agent/TCP]
    $ns attach-agent $n($i) $tcp($i,$j)
  }
}
for {set i 0} {$i < 50} {incr i} {
  for {set j 0} {$j < 400} {incr j} {
    set sink($i,$j) [new Agent/TCPSink]
    $ns attach-agent $nt($i) $sink($i,$j)
  }
}
for {set i 0} {$i < 400} {incr i} {
  for {set j 0} {$j < 50} {incr j} {
          $ns connect $tcp($i,$j) $sink($j,$i)
	  $tcp($i,$j) set packetSize_ 1500.0
	  $sink($j,$i) set packetSize_ 1500.0
  }
}
#===================================
#        Applications Definition        
#===================================
for {set i 0} {$i < 400} {incr i} {
  for {set j 0} {$j < 50} {incr j} {
    set ftp($i,$j) [new Application/FTP]
    $ftp($i,$j) attach-agent $tcp($i,$j)
    $ns at 1.0 "$ftp($i,$j) start"
    $ns at 5.0 "$ftp($i,$j) stop"
  }
}

#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam final.nam &
    exit 0
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run

