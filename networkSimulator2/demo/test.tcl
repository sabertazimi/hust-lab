# This script is created by ck

#===================================
#     Simulation parameters setup
#===================================
set val(stop)   5.0                         ;# time of simulation end

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
set tracefile [open out.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile

#===================================
#        Nodes Definition        
#===================================
#Create 4 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#===================================
#        Links Definition        
#===================================
#Createlinks between nodes


$ns duplex-link $n0 $n2 100.0Mb 10ms DropTail
$ns queue-limit $n0 $n2 50


$ns duplex-link $n2 $n1 100.0Mb 10ms DropTail
$ns queue-limit $n2 $n1 50


$ns duplex-link $n2 $n3 1.5Mb 10ms DropTail
$ns queue-limit $n2 $n3 50

#Give node position (for NAM)
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n2 $n1 orient left-down
$ns duplex-link-op $n2 $n3 orient right-up

#===================================
#        Agents Definition        
#===================================
#Setup a UDP connection
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set null2 [new Agent/Null]
$ns attach-agent $n3 $null2
$ns connect $udp0 $null2
	$udp0 set packetSize_ 1500.0

#Setup a TCP connection
set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1
set sink3 [new Agent/TCPSink]
$ns attach-agent $n3 $sink3
$ns connect $tcp1 $sink3
	$tcp1 set packetSize_ 1500.0
	$sink3 set packetSize_ 1500.0


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
$ns at 0.1 "$cbr0 start"
$ns at 4.0 "$cbr0 stop"

#Setup a FTP Application over TCP connection
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 1.0 "$ftp1 start"
$ns at 4.8 "$ftp1 stop"


#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam out.nam &
    exit 0
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
