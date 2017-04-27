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
set tracefile [open sack1.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open sack1.nam w]
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


$ns duplex-link $n2 $n3 1.0Mb 20ms DropTail
$ns queue-limit $n2 $n3 50


$ns duplex-link $n0 $n2 6.0Mb 10ms DropTail
$ns queue-limit $n0 $n2 50


$ns duplex-link $n1 $n2 6.0Mb 10ms DropTail
$ns queue-limit $n1 $n2 50

#Give node position (for NAM)
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up

#===================================
#        Agents Definition        
#===================================
#Setup a TCP/Sack1 connection
set sack0 [new Agent/TCP/Sack1]
$ns attach-agent $n0 $sack0
set sink2 [new Agent/TCPSink]
$ns attach-agent $n3 $sink2
$ns connect $sack0 $sink2
	$sack0 set packetSize_ 1500.0
	$sink2 set packetSize_ 1500.0

#Setup a TCP/Sack1 connection
set sack1 [new Agent/TCP/Sack1]
$ns attach-agent $n1 $sack1
set sink3 [new Agent/TCPSink]
$ns attach-agent $n3 $sink3
$ns connect $sack1 $sink3
	$sack1 set packetSize_ 1500.0
	$sink3 set packetSize_ 1500.0


#===================================
#        Applications Definition        
#===================================
#Setup a FTP Application over TCP/Sack1 connection
set ftp0 [new Application/FTP]
$ftp0 attach-agent $sack0
$ns at 1.0 "$ftp0 start"
$ns at 2.0 "$ftp0 stop"

#Setup a FTP Application over TCP/Sack1 connection
set ftp1 [new Application/FTP]
$ftp1 attach-agent $sack1
$ns at 1.0 "$ftp1 start"
$ns at 2.0 "$ftp1 stop"


#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam sack1.nam &
    exit 0
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
