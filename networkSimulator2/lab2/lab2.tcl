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
set tracefile [open lab2.tr w]

#拥塞窗口文件
set Cwinfile0 [open CWinFile0 w]
set Cwinfile1 [open CWinFile1 w]
set Cwinfile2 [open CWinFile2 w]
set Cwinfile3 [open CWinFile3 w]
set Cwinfile4 [open CWinFile4 w]
set Cwinfile5 [open CWinFile5 w]
#通告窗口文件
set winfile0 [open WinFile0 w]
set winfile1 [open WinFile1 w]
set winfile2 [open WinFile2 w]
set winfile3 [open WinFile3 w]
set winfile4 [open WinFile4 w]
set winfile5 [open WinFile5 w]

$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open lab2.nam w]
$ns namtrace-all $namfile

#===================================
#        Nodes Definition        
#===================================
#Create 28 nodes
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
set n24 [$ns node]
set n26 [$ns node]
set n28 [$ns node]
set n29 [$ns node]
set n30 [$ns node]

#===================================
#        Links Definition        
#===================================
#Createlinks between nodes


$ns duplex-link $n0 $n11 1.0Mb 10ms DropTail
$ns queue-limit $n0 $n11 5


$ns duplex-link $n11 $n22 100.0Mb 10ms DropTail
$ns queue-limit $n11 $n22 50


$ns duplex-link $n11 $n12 100.0Mb 10ms DropTail
$ns queue-limit $n11 $n12 50


$ns duplex-link $n1 $n12 1.0Mb 10ms DropTail
$ns queue-limit $n1 $n12 5


$ns duplex-link $n12 $n13 100.0Mb 10ms DropTail
$ns queue-limit $n12 $n13 50


$ns duplex-link $n2 $n13 1.0Mb 10ms DropTail
$ns queue-limit $n2 $n13 5


$ns duplex-link $n13 $n14 100.0Mb 10ms DropTail
$ns queue-limit $n13 $n14 50


$ns duplex-link $n14 $n15 100.0Mb 10ms DropTail
$ns queue-limit $n14 $n15 50


$ns duplex-link $n15 $n16 100.0Mb 10ms DropTail
$ns queue-limit $n15 $n16 50


$ns duplex-link $n17 $n16 100.0Mb 10ms DropTail
$ns queue-limit $n17 $n16 50


$ns duplex-link $n17 $n18 100.0Mb 10ms DropTail
$ns queue-limit $n17 $n18 50


$ns duplex-link $n18 $n19 100.0Mb 10ms DropTail
$ns queue-limit $n18 $n19 50


$ns duplex-link $n19 $n20 100.0Mb 10ms DropTail
$ns queue-limit $n19 $n20 50


$ns duplex-link $n20 $n21 100.0Mb 10ms DropTail
$ns queue-limit $n20 $n21 50


$ns duplex-link $n3 $n14 1.0Mb 10ms DropTail
$ns queue-limit $n3 $n14 5


$ns duplex-link $n4 $n15 1.0Mb 10ms DropTail
$ns queue-limit $n4 $n15 5


$ns duplex-link $n5 $n16 1.0Mb 10ms DropTail
$ns queue-limit $n5 $n16 5


$ns duplex-link $n6 $n17 100.0Mb 10ms DropTail
$ns queue-limit $n6 $n17 50


$ns duplex-link $n7 $n18 100.0Mb 10ms DropTail
$ns queue-limit $n7 $n18 50


$ns duplex-link $n8 $n19 100.0Mb 10ms DropTail
$ns queue-limit $n8 $n19 50


$ns duplex-link $n9 $n20 100.0Mb 10ms DropTail
$ns queue-limit $n9 $n20 50


$ns duplex-link $n10 $n21 100.0Mb 10ms DropTail
$ns queue-limit $n10 $n21 50


$ns duplex-link $n21 $n30 100.0Mb 10ms DropTail
$ns queue-limit $n21 $n30 50


$ns duplex-link $n19 $n29 100.0Mb 10ms DropTail
$ns queue-limit $n19 $n29 50


$ns duplex-link $n18 $n28 100.0Mb 10ms DropTail
$ns queue-limit $n18 $n28 50


$ns duplex-link $n16 $n26 100.0Mb 10ms DropTail
$ns queue-limit $n16 $n26 50


$ns duplex-link $n14 $n24 100.0Mb 10ms DropTail
$ns queue-limit $n14 $n24 50

#Give node position (for NAM)
$ns duplex-link-op $n0 $n11 orient right-down
$ns duplex-link-op $n11 $n22 orient left-down
$ns duplex-link-op $n11 $n12 orient right
$ns duplex-link-op $n1 $n12 orient left-down
$ns duplex-link-op $n12 $n13 orient right
$ns duplex-link-op $n2 $n13 orient right-down
$ns duplex-link-op $n13 $n14 orient right
$ns duplex-link-op $n14 $n15 orient right
$ns duplex-link-op $n15 $n16 orient right
$ns duplex-link-op $n17 $n16 orient left

$ns duplex-link-op $n17 $n18 orient right
$ns duplex-link-op $n18 $n19 orient right
$ns duplex-link-op $n19 $n20 orient right
$ns duplex-link-op $n20 $n21 orient right
$ns duplex-link-op $n3 $n14 orient right-down
$ns duplex-link-op $n4 $n15 orient left-down
$ns duplex-link-op $n5 $n16 orient left-down
$ns duplex-link-op $n6 $n17 orient left-down
$ns duplex-link-op $n7 $n18 orient left-down
$ns duplex-link-op $n8 $n19 orient left-down
$ns duplex-link-op $n9 $n20 orient right-down
$ns duplex-link-op $n10 $n21 orient left-down
$ns duplex-link-op $n21 $n30 orient left-down
$ns duplex-link-op $n19 $n29 orient right-down
$ns duplex-link-op $n18 $n28 orient left-down
$ns duplex-link-op $n16 $n26 orient right-down
$ns duplex-link-op $n14 $n24 orient left-down

#===================================
#        Agents Definition        
#===================================
#Setup a UDP connection
set udp6 [new Agent/UDP]
$ns attach-agent $n6 $udp6
set null22 [new Agent/Null]
$ns attach-agent $n26 $null22
$ns connect $udp6 $null22
	$udp6 set packetSize_ 1500.0

#Setup a UDP connection
set udp7 [new Agent/UDP]
$ns attach-agent $n7 $udp7
set null17 [new Agent/Null]
$ns attach-agent $n28 $null17
$ns connect $udp7 $null17
	$udp7 set packetSize_ 1500.0

#Setup a UDP connection
set udp8 [new Agent/UDP]
$ns attach-agent $n8 $udp8
set null18 [new Agent/Null]
$ns attach-agent $n29 $null18
$ns connect $udp8 $null18
	$udp8 set packetSize_ 1500.0

#Setup a UDP connection
set udp9 [new Agent/UDP]
$ns attach-agent $n9 $udp9
set null21 [new Agent/Null]
$ns attach-agent $n30 $null21
$ns connect $udp9 $null21
	$udp9 set packetSize_ 1500.0

#Setup a UDP connection
set udp10 [new Agent/UDP]
$ns attach-agent $n10 $udp10
set null19 [new Agent/Null]
$ns attach-agent $n30 $null19
$ns connect $udp10 $null19
	$udp10 set packetSize_ 1500.0

#Setup a TCP connection
set tahoe22 [new Agent/TCP]
$ns attach-agent $n0 $tahoe22
set sink11 [new Agent/TCPSink]
$ns attach-agent $n22 $sink11
$ns connect $tahoe22 $sink11
	$tahoe22 set packetSize_ 1500.0
	$sink11 set packetSize_ 1500.0

#Setup a TCP/Reno connection
set reno23 [new Agent/TCP/Reno]
$ns attach-agent $n1 $reno23
set sink20 [new Agent/TCPSink]
$ns attach-agent $n22 $sink20
$ns connect $reno23 $sink20
	$reno23 set packetSize_ 1500.0
	$sink20 set packetSize_ 1500.0

#Setup a TCP/Newreno connection
set newReno24 [new Agent/TCP/Newreno]
$ns attach-agent $n2 $newReno24
set sink23 [new Agent/TCPSink]
$ns attach-agent $n24 $sink23
$ns connect $newReno24 $sink23
	$newReno24 set packetSize_ 1500.0
	$sink23 set packetSize_ 1500.0

#Setup a TCP/Vegas connection
set vegas25 [new Agent/TCP/Vegas]
$ns attach-agent $n3 $vegas25
set sink13 [new Agent/TCPSink]
$ns attach-agent $n24 $sink13
$ns connect $vegas25 $sink13
	$vegas25 set packetSize_ 1500.0
	$sink13 set packetSize_ 1500.0

#Setup a TCP/Sack1 connection
set sack26 [new Agent/TCP/Sack1]
$ns attach-agent $n4 $sack26
set sink24 [new Agent/TCPSink]
$ns attach-agent $n24 $sink24
$ns connect $sack26 $sink24
	$sack26 set packetSize_ 1500.0
	$sink24 set packetSize_ 1500.0

#Setup a TCP/Fack connection
set fack27 [new Agent/TCP/Fack]
$ns attach-agent $n5 $fack27
set sink15 [new Agent/TCPSink]
$ns attach-agent $n26 $sink15
$ns connect $fack27 $sink15
	$fack27 set packetSize_ 1500.0
	$sink15 set packetSize_ 1500.0


#===================================
#        Applications Definition        
#===================================
#Setup a CBR Application over UDP connection
set cbr6 [new Application/Traffic/CBR]
$cbr6 attach-agent $udp6
	$cbr6 set packetSize_ 1000
	$cbr6 set rate_ 1.0Mb
	$cbr6 set random_ false
$ns at 1.0 "$cbr6 start"
$ns at 2.0 "$cbr6 stop"

#Setup a CBR Application over UDP connection
set cbr7 [new Application/Traffic/CBR]
$cbr7 attach-agent $udp7
	$cbr7 set packetSize_ 1000
	$cbr7 set rate_ 1.0Mb
	$cbr7 set random_ false
$ns at 1.0 "$cbr7 start"
$ns at 2.0 "$cbr7 stop"

#Setup a CBR Application over UDP connection
set cbr8 [new Application/Traffic/CBR]
$cbr8 attach-agent $udp8
	$cbr8 set packetSize_ 1000
	$cbr8 set rate_ 1.0Mb
	$cbr8 set random_ false
$ns at 1.0 "$cbr8 start"
$ns at 2.0 "$cbr8 stop"

#Setup a CBR Application over UDP connection
set cbr9 [new Application/Traffic/CBR]
$cbr9 attach-agent $udp9
	$cbr9 set packetSize_ 1000
	$cbr9 set rate_ 1.0Mb
	$cbr9 set random_ false
$ns at 1.0 "$cbr9 start"
$ns at 2.0 "$cbr9 stop"

#Setup a CBR Application over UDP connection
set cbr10 [new Application/Traffic/CBR]
$cbr10 attach-agent $udp10
	$cbr10 set packetSize_ 1000
	$cbr10 set rate_ 1.0Mb
	$cbr10 set random_ false
$ns at 1.0 "$cbr10 start"
$ns at 2.0 "$cbr10 stop"

#Setup a FTP Application over TCP/Vegas connection
set ftp14 [new Application/FTP]
$ftp14 attach-agent $vegas25
$ns at 1.0 "$ftp14 start"
$ns at 5.0 "$ftp14 stop"

#Setup a FTP Application over TCP/Sack1 connection
set ftp15 [new Application/FTP]
$ftp15 attach-agent $sack26
$ns at 1.0 "$ftp15 start"
$ns at 5.0 "$ftp15 stop"

#Setup a FTP Application over TCP/Fack connection
set ftp16 [new Application/FTP]
$ftp16 attach-agent $fack27
$ns at 1.0 "$ftp16 start"
$ns at 5.0 "$ftp16 stop"

#Setup a FTP Application over TCP connection
set ftp11 [new Application/FTP]
$ftp11 attach-agent $tahoe22
$ns at 1.0 "$ftp11 start"
$ns at 5.0 "$ftp11 stop"

#Setup a FTP Application over TCP/Reno connection
set ftp12 [new Application/FTP]
$ftp12 attach-agent $reno23
$ns at 1.0 "$ftp12 start"
$ns at 5.0 "$ftp12 stop"

#Setup a FTP Application over TCP/Newreno connection
set ftp13 [new Application/FTP]
$ftp13 attach-agent $newReno24
$ns at 1.0 "$ftp13 start"
$ns at 5.0 "$ftp13 stop"


#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam lab2.nam &
    exit 0
}

###################################################
#生成拥塞窗口和通告窗口数据函数
#
###################################################
proc plotWindow {tcpSource file_Cwnd file_wnd} {
  global ns
  #设置抽样距离，每过0.1s后再调用自己
  set time 0.1
  set now [$ns now]
  #拥塞窗口
  set cwnd [$tcpSource set cwnd_]
  #通告窗口
  set wnd [$tcpSource set window_]
  #把当前时间数据和cwnd的数据记录到file_Cwnd所指向的文件中
  puts $file_Cwnd "$now $cwnd"
  #把当前时间数据和wnd的数据记录到file_wnd所指向的文件中
  puts $file_wnd "$now $wnd"
  #这是一个递归过程，在过了0.1秒后继续调用本函数，并记录时间数据和cwnd数据
  $ns at [expr $now+$time] "plotWindow $tcpSource $file_Cwnd $file_wnd"
}
####################################################

$ns at 0.1 "plotWindow $tahoe22 $Cwinfile0 $winfile0"
$ns at 0.1 "plotWindow $reno23 $Cwinfile1 $winfile1"
$ns at 0.1 "plotWindow $newReno24 $Cwinfile2 $winfile2"
$ns at 0.1 "plotWindow $vegas25 $Cwinfile3 $winfile3"
$ns at 0.1 "plotWindow $sack26 $Cwinfile4 $winfile4"
$ns at 0.1 "plotWindow $fack27 $Cwinfile5 $winfile5"

$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
