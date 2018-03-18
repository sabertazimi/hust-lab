set ns [new Simulator]
set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
	global f0 f1 f2

	# close the output files
	close f0
	close f1
	close f2

	# call xgraph to display the results
	exec xgraph out0.tr out1.tr out2.tr -geometry 800x400 &
	
	# global ns nf
	# $ns flush-trace
	# close $nf
	# exec nam out.nam &
	
	exit 0
}

proc attach-expoo-traffic { node sink size burst idle rate } {
	# get an instance of the simulator
	set ns [Simulator instance]

	# create a UDP agent attach it to the node
	set source [new Agent/UDP]
	$ns attach-agent $node $source

	# create an Expoo traffic agent and set its configuration parameters
	set traffic [new Application/Traffic/Exponential]
	$traffic set packetSize_ $size
	$traffic set burst_time_ $burst
	$traffic set idle_time_ $idle
	$traffic set rate_ $rate

	# attach traffic source to the traffic generator
	$traffic attach-agent $source

	# connect the source and the sink
	$ns connect $source $sink
}

proc record {} {
	global sink0 sink1 sink2 f0 f1 f2
	
	# get an instance of the simulator
	set ns [Simulator instance]

	# set the time after which the procedure should be called again
	set time 0.5

	# how many bytes have been received by the traffic sinks
	set bw0 [$sink0 set bytes_]
	set bw1 [$sink1 set bytes_]
	set bw2 [$sink2 set bytes_]

	# get the current time
	set now [$ns now]

	# calculate the bandwidth (in MBit/s) and write it to the files
	puts $f0 "$now [expr $bw0/$time*8/1000000]"
	puts $f1 "$now [expr $bw1/$time*8/1000000]"
	puts $f2 "$now [expr $bw2/$time*8/1000000]"

	# reset the bytes_ values on the traffic sinks
	$sink0 set bytes_ 0
	$sink1 set bytes_ 0
	$sink2 set bytes_ 0

	# re-schedule the procedure
	# setInterval function
	$ns at [expr $now+$time] "record"
}

# create a CBR traffic source and attach it to udp0
# set cbr0 [new Application/Traffic/CBR]
# $cbr0 set packetSize_ 500
# $cbr0 set interval_ 0.005
# $cbr0 attach-agent $udp0

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

$ns duplex-link $n0 $n3 1Mb 100ms DropTail
$ns duplex-link $n1 $n3 1Mb 100ms DropTail
$ns duplex-link $n2 $n3 1Mb 100ms DropTail
$ns duplex-link $n3 $n4 1Mb 100ms DropTail

# create receive agent
set sink0 [new Agent/LossMonitor]
set sink1 [new Agent/LossMonitor]
set sink2 [new Agent/LossMonitor]
$ns attach-agent $n4 $sink0
$ns attach-agent $n4 $sink1
$ns attach-agent $n4 $sink2

set source0 [attach-expoo-traffic $n0 $sink0 200 2s 1s 100k]
set source1 [attach-expoo-traffic $n1 $sink1 200 2s 1s 200k]
set source2 [attach-expoo-traffic $n2 $sink2 200 2s 1s 300k]

set f0 [open out0.tr w]
set f1 [open out1.tr w]
set f2 [open out2.tr w]

$ns at 0.0 "record"
$ns at 10.0 "$source0 start"
$ns at 10.0 "$source1 start"
$ns at 10.0 "$source2 start"
$ns at 50.0 "$source0 stop"
$ns at 50.0 "$source1 stop"
$ns at 50.0 "$source2 stop"
$ns at 60.0 "finish"

$ns run

