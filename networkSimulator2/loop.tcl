for {set i 0} {$i < 7} {incr i} {
	set n($i) [$ns node]
}

for {set i 0} {$i < 7} {incr i} {
	$ns duplex-link $n($i) $n([expr ($i+1)%7]) 1Mb 100ms DropTail
}
