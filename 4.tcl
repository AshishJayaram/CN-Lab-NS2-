#Simulate the transmission of ping messages over a network topology consisting of 6 nodes and find the number of packets dropped due to congestion

#create a simulator object
set ns [new Simulator]
#set up trace files
set tracefile [open 4.tr w]
$ns trace-all $tracefile
set namfile [open 4.nam w]
$ns namtrace-all $namfile
proc finish {} {
global ns namfile tracefile
$ns flush-trace
#close the trace files
close $tracefile
close $namfile
exec awk -f 44.awk 4.tr &
exec nam 4.nam &
exit 0
}
#create 4 nodes
for {set i 0} {$i<7} {incr i} {
set n($i) [$ns node]
}
#create links between nodes
for {set i 1} {$i<4} {incr i} {
$ns duplex-link $n($i) $n(0) 1Mb 10ms DropTail
}
$ns duplex-link $n(4) $n(0) 1Mb 100ms DropTail
$ns duplex-link $n(5) $n(0) 1Mb 100ms DropTail
$ns duplex-link $n(6) $n(0) 1Mb 90ms DropTail

Agent/Ping instproc recv {from rtt} {
$self instvar node_
puts "node [$node_ id] received ping answer from \
$from with round-trip-time $rtt ms."
}
#create pingagents,queue-limits
for {set i 1} {$i<7} {incr i} {
set pingagent($i) [new Agent/Ping]
$ns attach-agent $n($i) $pingagent($i)

}
$ns queue-limit $n(0) $n(6) 1
$ns connect $pingagent(1) $pingagent(4)
$ns connect $pingagent(2) $pingagent(5)
$ns connect $pingagent(3) $pingagent(6)


#schedule events
$ns at 0.1 "$pingagent(1) send"
$ns at 0.5 "$pingagent(2) send"
$ns at 0.5 "$pingagent(3) send"
$ns at 0.5 "$pingagent(4) send"
$ns at 1.0 "$pingagent(5) send"
$ns at 1.0 "$pingagent(6) send"
$ns at 1.1 "$pingagent(1) send"
$ns at 1.5 "$pingagent(1) send"
$ns at 1.5 "$pingagent(3) send"
$ns at 1.5 "$pingagent(4) send"
$ns at 2.0 "$pingagent(5) send"
$ns at 2.0 "$pingagent(6) send"
#run simulation
$ns run
