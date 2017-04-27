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
set tracefile [open udp.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open udp.nam w]
$ns namtrace-all $namfile

#===================================
#        Nodes Definition        
#===================================
#Create 5 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

#===================================
#        Links Definition        
#===================================
#Createlinks between nodes


$ns duplex-link $n0 $n1 100.0Mb 10ms DropTail
$ns queue-limit $n0 $n1 50


$ns duplex-link $n1 $n2 100.0Mb 10ms DropTail
$ns queue-limit $n1 $n2 50


$ns duplex-link $n3 $n2 100.0Mb 10ms DropTail
$ns queue-limit $n3 $n2 50


$ns duplex-link $n2 $n4 100.0Mb 10ms DropTail
$ns queue-limit $n2 $n4 50

#Give node position (for NAM)
$ns duplex-link-op $n0 $n1 orient right
$ns duplex-link-op $n1 $n2 orient right
$ns duplex-link-op $n3 $n2 orient right-up
$ns duplex-link-op $n2 $n4 orient right

#===================================
#        Agents Definition        
#===================================
#Setup a UDP connection
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set null2 [new Agent/Null]
$ns attach-agent $n4 $null2
$ns connect $udp0 $null2
	$udp0 set packetSize_ 1500.0

#Setup a UDP connection
set udp1 [new Agent/UDP]
$ns attach-agent $n3 $udp1
set null5 [new Agent/Null]
$ns attach-agent $n4 $null5
$ns connect $udp1 $null5
	$udp1 set packetSize_ 1500.0


#===================================
#        Applications Definition        
#===================================
#Setup a CBR Application over UDP connection
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
	$cbr0 set packetSize_ 1000
	$cbr0 set rate_ 1.0Mb
	$cbr0 set interval_ 0.005ms
	$cbr0 set maxpkts_ 5.0
	$cbr0 set random_ false
$ns at 1.0 "$cbr0 start"
$ns at 8.0 "$cbr0 stop"

#Setup a CBR Application over UDP connection
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
	$cbr1 set packetSize_ 1000
	$cbr1 set rate_ 1.0Mb
	$cbr1 set interval_ 0.005ms
	$cbr1 set maxpkts_ 5.0
	$cbr1 set random_ false
$ns at 1.0 "$cbr1 start"
$ns at 8.0 "$cbr1 stop"


#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam udp.nam &
    exit 0
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
