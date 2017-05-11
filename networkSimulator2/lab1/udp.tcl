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
#Create 25 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]
set n10 [$ns node]
set n11 [$ns node]
set n12 [$ns node]
set n13 [$ns node]
set n14 [$ns node]
set n15 [$ns node]
set n16 [$ns node]
set n17 [$ns node]
set n18 [$ns node]
set n19 [$ns node]
set n20 [$ns node]
set n21 [$ns node]
set n22 [$ns node]
set n23 [$ns node]
set n24 [$ns node]

#===================================
#        Links Definition        
#===================================
#Createlinks between nodes


$ns duplex-link $n0 $n5 100.0Mb 10ms DropTail
$ns queue-limit $n0 $n5 50


$ns duplex-link $n5 $n10 100.0Mb 10ms DropTail
$ns queue-limit $n5 $n10 50


$ns duplex-link $n11 $n10 100.0Mb 10ms DropTail
$ns queue-limit $n11 $n10 50


$ns duplex-link $n11 $n12 100.0Mb 10ms DropTail
$ns queue-limit $n11 $n12 50


$ns duplex-link $n4 $n9 100.0Mb 10ms DropTail
$ns queue-limit $n4 $n9 50


$ns duplex-link $n8 $n9 100.0Mb 10ms DropTail
$ns queue-limit $n8 $n9 50


$ns duplex-link $n8 $n3 100.0Mb 10ms DropTail
$ns queue-limit $n8 $n3 50


$ns duplex-link $n8 $n7 100.0Mb 10ms DropTail
$ns queue-limit $n8 $n7 50


$ns duplex-link $n7 $n12 100.0Mb 10ms DropTail
$ns queue-limit $n7 $n12 50


$ns duplex-link $n5 $n6 100.0Mb 10ms DropTail
$ns queue-limit $n5 $n6 50


$ns duplex-link $n6 $n7 100.0Mb 10ms DropTail
$ns queue-limit $n6 $n7 50


$ns duplex-link $n1 $n6 100.0Mb 10ms DropTail
$ns queue-limit $n1 $n6 50


$ns duplex-link $n2 $n7 100.0Mb 10ms DropTail
$ns queue-limit $n2 $n7 50


$ns duplex-link $n20 $n15 100.0Mb 10ms DropTail
$ns queue-limit $n20 $n15 50


$ns duplex-link $n20 $n16 100.0Mb 10ms DropTail
$ns queue-limit $n20 $n16 50


$ns duplex-link $n21 $n17 100.0Mb 10ms DropTail
$ns queue-limit $n21 $n17 50


$ns duplex-link $n15 $n16 100.0Mb 10ms DropTail
$ns queue-limit $n15 $n16 50


$ns duplex-link $n16 $n17 100.0Mb 10ms DropTail
$ns queue-limit $n16 $n17 50


$ns duplex-link $n22 $n18 100.0Mb 10ms DropTail
$ns queue-limit $n22 $n18 50


$ns duplex-link $n17 $n18 100.0Mb 10ms DropTail
$ns queue-limit $n17 $n18 50


$ns duplex-link $n18 $n23 100.0Mb 10ms DropTail
$ns queue-limit $n18 $n23 50


$ns duplex-link $n18 $n19 100.0Mb 10ms DropTail
$ns queue-limit $n18 $n19 50


$ns duplex-link $n24 $n19 100.0Mb 10ms DropTail
$ns queue-limit $n24 $n19 50


$ns duplex-link $n19 $n14 100.0Mb 10ms DropTail
$ns queue-limit $n19 $n14 50


$ns duplex-link $n18 $n13 100.0Mb 10ms DropTail
$ns queue-limit $n18 $n13 50


$ns duplex-link $n13 $n14 100.0Mb 10ms DropTail
$ns queue-limit $n13 $n14 50

#Give node position (for NAM)
$ns duplex-link-op $n0 $n5 orient left-down
$ns duplex-link-op $n5 $n10 orient left-down
$ns duplex-link-op $n11 $n10 orient left

$ns duplex-link-op $n11 $n12 orient right
$ns duplex-link-op $n4 $n9 orient left-down
$ns duplex-link-op $n8 $n9 orient right
$ns duplex-link-op $n8 $n3 orient left-up
$ns duplex-link-op $n8 $n7 orient left

$ns duplex-link-op $n7 $n12 orient left-down
$ns duplex-link-op $n5 $n6 orient right
$ns duplex-link-op $n6 $n7 orient right
$ns duplex-link-op $n1 $n6 orient left-down
$ns duplex-link-op $n2 $n7 orient left-down
$ns duplex-link-op $n20 $n15 orient left-up
$ns duplex-link-op $n20 $n16 orient right-up
$ns duplex-link-op $n21 $n17 orient right-up
$ns duplex-link-op $n15 $n16 orient right
$ns duplex-link-op $n16 $n17 orient right
$ns duplex-link-op $n22 $n18 orient right-up
$ns duplex-link-op $n17 $n18 orient right
$ns duplex-link-op $n18 $n23 orient left-down
$ns duplex-link-op $n18 $n19 orient right
$ns duplex-link-op $n24 $n19 orient left-up
$ns duplex-link-op $n19 $n14 orient left-up
$ns duplex-link-op $n18 $n13 orient left-up
$ns duplex-link-op $n13 $n14 orient right

#===================================
#        Agents Definition        
#===================================
#Setup a TCP connection
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink12 [new Agent/TCPSink]
$ns attach-agent $n12 $sink12
$ns connect $tcp0 $sink12
	$tcp0 set packetSize_ 1500.0
	$sink12 set packetSize_ 1500.0

#Setup a TCP connection
set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1
set sink13 [new Agent/TCPSink]
$ns attach-agent $n12 $sink13
$ns connect $tcp1 $sink13
	$tcp1 set packetSize_ 1500.0
	$sink13 set packetSize_ 1500.0

#Setup a TCP connection
set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2
set sink14 [new Agent/TCPSink]
$ns attach-agent $n12 $sink14
$ns connect $tcp2 $sink14
	$tcp2 set packetSize_ 1500.0
	$sink14 set packetSize_ 1500.0

#Setup a TCP connection
set tcp3 [new Agent/TCP]
$ns attach-agent $n3 $tcp3
set sink15 [new Agent/TCPSink]
$ns attach-agent $n12 $sink15
$ns connect $tcp3 $sink15
	$tcp3 set packetSize_ 1500.0
	$sink15 set packetSize_ 1500.0

#Setup a TCP connection
set tcp4 [new Agent/TCP]
$ns attach-agent $n4 $tcp4
set sink16 [new Agent/TCPSink]
$ns attach-agent $n12 $sink16
$ns connect $tcp4 $sink16
	$tcp4 set packetSize_ 1500.0
	$sink16 set packetSize_ 1500.0

#Setup a TCP connection
set tcp5 [new Agent/TCP]
$ns attach-agent $n5 $tcp5
set sink11 [new Agent/TCPSink]
$ns attach-agent $n12 $sink11
$ns connect $tcp5 $sink11
	$tcp5 set packetSize_ 1500.0
	$sink11 set packetSize_ 1500.0

#Setup a UDP connection
set udp6 [new Agent/UDP]
$ns attach-agent $n19 $udp6
set null21 [new Agent/Null]
$ns attach-agent $n14 $null21
$ns connect $udp6 $null21
	$udp6 set packetSize_ 1500.0

#Setup a UDP connection
set udp7 [new Agent/UDP]
$ns attach-agent $n23 $udp7
set null20 [new Agent/Null]
$ns attach-agent $n14 $null20
$ns connect $udp7 $null20
	$udp7 set packetSize_ 1500.0

#Setup a UDP connection
set udp8 [new Agent/UDP]
$ns attach-agent $n22 $udp8
set null19 [new Agent/Null]
$ns attach-agent $n14 $null19
$ns connect $udp8 $null19
	$udp8 set packetSize_ 1500.0

#Setup a UDP connection
set udp9 [new Agent/UDP]
$ns attach-agent $n21 $udp9
set null18 [new Agent/Null]
$ns attach-agent $n14 $null18
$ns connect $udp9 $null18
	$udp9 set packetSize_ 1500.0

#Setup a UDP connection
set udp10 [new Agent/UDP]
$ns attach-agent $n20 $udp10
set null17 [new Agent/Null]
$ns attach-agent $n14 $null17
$ns connect $udp10 $null17
	$udp10 set packetSize_ 1500.0


#===================================
#        Applications Definition        
#===================================
#Setup a FTP Application over TCP connection
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp5
$ns at 1.0 "$ftp0 start"
$ns at 2.0 "$ftp0 stop"

#Setup a FTP Application over TCP connection
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp0
$ns at 1.0 "$ftp1 start"
$ns at 2.0 "$ftp1 stop"

#Setup a FTP Application over TCP connection
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp1
$ns at 1.0 "$ftp2 start"
$ns at 2.0 "$ftp2 stop"

#Setup a FTP Application over TCP connection
set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp2
$ns at 1.0 "$ftp3 start"
$ns at 2.0 "$ftp3 stop"

#Setup a FTP Application over TCP connection
set ftp4 [new Application/FTP]
$ftp4 attach-agent $tcp3
$ns at 1.0 "$ftp4 start"
$ns at 2.0 "$ftp4 stop"

#Setup a FTP Application over TCP connection
set ftp5 [new Application/FTP]
$ftp5 attach-agent $tcp4
$ns at 1.0 "$ftp5 start"
$ns at 2.0 "$ftp5 stop"

#Setup a CBR Application over UDP connection
set cbr6 [new Application/Traffic/CBR]
$cbr6 attach-agent $udp6
	$cbr6 set packetSize_ 1000
	$cbr6 set rate_ 1.0Mb
	$cbr6 set interval_ 0.005ms
	$cbr6 set maxpkts_ 5.0
	$cbr6 set random_ false
$ns at 1.0 "$cbr6 start"
$ns at 2.0 "$cbr6 stop"

#Setup a CBR Application over UDP connection
set cbr7 [new Application/Traffic/CBR]
$cbr7 attach-agent $udp7
	$cbr7 set packetSize_ 1000
	$cbr7 set rate_ 1.0Mb
	$cbr7 set interval_ 0.005ms
	$cbr7 set maxpkts_ 5.0
	$cbr7 set random_ false
$ns at 1.0 "$cbr7 start"
$ns at 2.0 "$cbr7 stop"

#Setup a CBR Application over UDP connection
set cbr8 [new Application/Traffic/CBR]
$cbr8 attach-agent $udp8
	$cbr8 set packetSize_ 1000
	$cbr8 set rate_ 1.0Mb
	$cbr8 set interval_ 0.005ms
	$cbr8 set maxpkts_ 5.0
	$cbr8 set random_ false
$ns at 1.0 "$cbr8 start"
$ns at 2.0 "$cbr8 stop"

#Setup a CBR Application over UDP connection
set cbr9 [new Application/Traffic/CBR]
$cbr9 attach-agent $udp9
	$cbr9 set packetSize_ 1000
	$cbr9 set rate_ 1.0Mb
	$cbr9 set interval_ 0.005ms
	$cbr9 set maxpkts_ 5.0
	$cbr9 set random_ false
$ns at 1.0 "$cbr9 start"
$ns at 2.0 "$cbr9 stop"

#Setup a CBR Application over UDP connection
set cbr10 [new Application/Traffic/CBR]
$cbr10 attach-agent $udp10
	$cbr10 set packetSize_ 1000
	$cbr10 set rate_ 1.0Mb
	$cbr10 set interval_ 0.005ms
	$cbr10 set maxpkts_ 5.0
	$cbr10 set random_ false
$ns at 1.0 "$cbr10 start"
$ns at 2.0 "$cbr10 stop"


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
