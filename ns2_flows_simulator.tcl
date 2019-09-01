# Create scheduler
set ns [new Simulator]
set max_starttime 1.0
set min_starttime 0.0
set finishtime 2.0
set bw 100Mb
set delay 0ms
set buffer 500
set bw_bottleneck 10Mb
set delay_bottleneck 0ms
set buffer_bottleneck 30
exec echo "$max_starttime" > finishtime.txt

# See headers activated
# foreach cl [PacketHeader info subclass] {
#                 puts $cl
#         }

# create output files
set tracefile [open out.tr w]
$ns trace-all $tracefile
set namfile [open out.nam w]
$ns namtrace-all $namfile

# Create topology  
set num_node 16
for {set i 0} {$i < $num_node} {incr i} {
	set n($i) [$ns node]
}
$ns set src_ [list 7 3 4 5 6 12 14]
$ns set dst_ [list 2 8 9 10 11 13 15]
# Bottleneck 
$ns simplex-link $n(0) $n(1) $bw_bottleneck $delay_bottleneck DropTail
$ns queue-limit $n(0) $n(1) $buffer_bottleneck
$ns simplex-link $n(1) $n(0) $bw $delay DropTail
$ns queue-limit $n(1) $n(0) $buffer
# Rest of nodes
$ns duplex-link $n(0) $n(2) $bw $delay DropTail
$ns queue-limit $n(0) $n(2) $buffer
$ns queue-limit $n(2) $n(0) $buffer
$ns duplex-link $n(0) $n(3) $bw $delay DropTail
$ns queue-limit $n(0) $n(3) $buffer
$ns queue-limit $n(3) $n(0) $buffer
$ns duplex-link $n(0) $n(4) $bw $delay DropTail
$ns queue-limit $n(0) $n(4) $buffer
$ns queue-limit $n(4) $n(0) $buffer
$ns duplex-link $n(0) $n(5) $bw $delay DropTail
$ns queue-limit $n(0) $n(5) $buffer
$ns queue-limit $n(5) $n(0) $buffer
$ns duplex-link $n(0) $n(6) $bw $delay DropTail
$ns queue-limit $n(0) $n(6) $buffer
$ns queue-limit $n(6) $n(0) $buffer
$ns duplex-link $n(1) $n(7) $bw $delay DropTail
$ns queue-limit $n(1) $n(7) $buffer
$ns queue-limit $n(7) $n(1) $buffer
$ns duplex-link $n(1) $n(8) $bw $delay DropTail
$ns queue-limit $n(1) $n(8) $buffer
$ns queue-limit $n(8) $n(1) $buffer
$ns duplex-link $n(1) $n(9) $bw $delay DropTail
$ns queue-limit $n(1) $n(9) $buffer
$ns queue-limit $n(9) $n(1) $buffer
$ns duplex-link $n(1) $n(10) $bw $delay DropTail
$ns queue-limit $n(1) $n(10) $buffer
$ns queue-limit $n(10) $n(1) $buffer
$ns duplex-link $n(1) $n(11) $bw $delay DropTail
$ns queue-limit $n(1) $n(11) $buffer
$ns queue-limit $n(11) $n(1) $buffer
$ns duplex-link $n(0) $n(12) $bw $delay DropTail
$ns queue-limit $n(0) $n(12) $buffer
$ns queue-limit $n(12) $n(0) $buffer
$ns duplex-link $n(0) $n(14) $bw $delay DropTail
$ns queue-limit $n(0) $n(14) $buffer
$ns queue-limit $n(14) $n(0) $buffer
$ns duplex-link $n(1) $n(13) $bw $delay DropTail
$ns queue-limit $n(1) $n(13) $buffer
$ns queue-limit $n(13) $n(1) $buffer
$ns duplex-link $n(1) $n(15) $bw $delay DropTail
$ns queue-limit $n(1) $n(15) $buffer
$ns queue-limit $n(15) $n(1) $buffer
# Node positions
$ns duplex-link-op $n(0) $n(1) orient left
$ns duplex-link-op $n(0) $n(2) orient up
$ns duplex-link-op $n(0) $n(3) orient right-up
$ns duplex-link-op $n(0) $n(4) orient right
$ns duplex-link-op $n(0) $n(5) orient right-down
$ns duplex-link-op $n(0) $n(6) orient down
$ns duplex-link-op $n(1) $n(7) orient up
$ns duplex-link-op $n(1) $n(8) orient left-up
$ns duplex-link-op $n(1) $n(9) orient left 
$ns duplex-link-op $n(1) $n(10) orient left-down
$ns duplex-link-op $n(1) $n(11) orient down
$ns duplex-link-op $n(0) $n(12) orient left-up
$ns duplex-link-op $n(0) $n(14) orient left-down
$ns duplex-link-op $n(1) $n(13) orient right-up
$ns duplex-link-op $n(1) $n(15) orient right-down
# Node shape
$n(0) shape hexagon
$n(1) shape hexagon
foreach s [$ns set src_] {
	$n($s) shape circle
}
foreach s [$ns set dst_] {
	$n($s) shape circle
}
# Node colors
$n(0) color black
$n(1) color black
$n(2) color green
$n(7) color green
$n(3) color yellow
$n(8) color yellow
$n(4) color blue
$n(9) color blue
$n(5) color red
$n(10) color red
$n(6) color gray
$n(11) color gray
$n(12) color purple
$n(13) color purple
$n(14) color maroon
$n(15) color maroon
# Flow colors
$ns color 0 green
$ns color 1 yellow
$ns color 2 blue
$ns color 3 red
$ns color 4 gray
$ns color 5 purple
$ns color 6 maroon

# Queue monitor
# Uplink
set monitor01 [open qm01.out w]
set qm01 [$ns monitor-queue $n(0) $n(1) $monitor01 0.001]
[$ns link $n(0) $n(1)] queue-sample-timeout
set monitor20 [open qm20.out w]
set qm20 [$ns monitor-queue $n(2) $n(0) $monitor20 0.001]
[$ns link $n(2) $n(0)] queue-sample-timeout
set monitor30 [open qm30.out w]
set qm30 [$ns monitor-queue $n(3) $n(0) $monitor30 0.001]
[$ns link $n(3) $n(0)] queue-sample-timeout
set monitor40 [open qm40.out w]
set qm40 [$ns monitor-queue $n(4) $n(0) $monitor40 0.001]
[$ns link $n(4) $n(0)] queue-sample-timeout
set monitor50 [open qm50.out w]
set qm50 [$ns monitor-queue $n(5) $n(0) $monitor50 0.001]
[$ns link $n(5) $n(0)] queue-sample-timeout
set monitor60 [open qm60.out w]
set qm60 [$ns monitor-queue $n(6) $n(0) $monitor60 0.001]
[$ns link $n(6) $n(0)] queue-sample-timeout
set monitor17 [open qm17.out w]
set qm17 [$ns monitor-queue $n(1) $n(7) $monitor17 0.001]
[$ns link $n(1) $n(7)] queue-sample-timeout
set monitor18 [open qm18.out w]
set qm18 [$ns monitor-queue $n(1) $n(8) $monitor18 0.001]
[$ns link $n(1) $n(8)] queue-sample-timeout
set monitor19 [open qm19.out w]
set qm19 [$ns monitor-queue $n(1) $n(9) $monitor19 0.001]
[$ns link $n(1) $n(9)] queue-sample-timeout
set monitor110 [open qm110.out w]
set qm110 [$ns monitor-queue $n(1) $n(10) $monitor110 0.001]
[$ns link $n(1) $n(10)] queue-sample-timeout
set monitor1_11 [open qm1_11.out w]
set qm1_11 [$ns monitor-queue $n(1) $n(11) $monitor1_11 0.001]
[$ns link $n(1) $n(11)] queue-sample-timeout
set monitor120 [open qm120.out w]
set qm120 [$ns monitor-queue $n(12) $n(0) $monitor120 0.001]
[$ns link $n(12) $n(0)] queue-sample-timeout
set monitor140 [open qm140.out w]
set qm140 [$ns monitor-queue $n(14) $n(0) $monitor140 0.001]
[$ns link $n(14) $n(0)] queue-sample-timeout
set monitor113 [open qm113.out w]
set qm113 [$ns monitor-queue $n(1) $n(13) $monitor113 0.001]
[$ns link $n(1) $n(13)] queue-sample-timeout
set monitor115 [open qm115.out w]
set qm115 [$ns monitor-queue $n(1) $n(15) $monitor115 0.001]
[$ns link $n(1) $n(15)] queue-sample-timeout
# Downlink
set monitor10 [open qm10.out w]
set qm10 [$ns monitor-queue $n(1) $n(0) $monitor10 0.001]
[$ns link $n(1) $n(0)] queue-sample-timeout
set monitor71 [open qm71.out w]
set qm71 [$ns monitor-queue $n(7) $n(1) $monitor71 0.001]
[$ns link $n(7) $n(1)] queue-sample-timeout
set monitor81 [open qm81.out w]
set qm81 [$ns monitor-queue $n(8) $n(1) $monitor81 0.001]
[$ns link $n(8) $n(1)] queue-sample-timeout
set monitor91 [open qm91.out w]
set qm91 [$ns monitor-queue $n(9) $n(1) $monitor91 0.001]
[$ns link $n(9) $n(1)] queue-sample-timeout
set monitor101 [open qm101.out w]
set qm101 [$ns monitor-queue $n(10) $n(1) $monitor101 0.001]
[$ns link $n(10) $n(1)] queue-sample-timeout
set monitor11_1 [open qm11_1.out w]
set qm11_1 [$ns monitor-queue $n(11) $n(1) $monitor11_1 0.001]
[$ns link $n(11) $n(1)] queue-sample-timeout
set monitor02 [open qm02.out w]
set qm02 [$ns monitor-queue $n(0) $n(2) $monitor02 0.001]
[$ns link $n(0) $n(2)] queue-sample-timeout
set monitor03 [open qm03.out w]
set qm03 [$ns monitor-queue $n(0) $n(3) $monitor03 0.001]
[$ns link $n(0) $n(3)] queue-sample-timeout
set monitor04 [open qm04.out w]
set qm04 [$ns monitor-queue $n(0) $n(4) $monitor04 0.001]
[$ns link $n(0) $n(4)] queue-sample-timeout
set monitor05 [open qm05.out w]
set qm05 [$ns monitor-queue $n(0) $n(5) $monitor05 0.001]
[$ns link $n(0) $n(5)] queue-sample-timeout
set monitor06 [open qm06.out w]
set qm06 [$ns monitor-queue $n(0) $n(6) $monitor06 0.001]
[$ns link $n(0) $n(6)] queue-sample-timeout
set monitor012 [open qm012.out w]
set qm012 [$ns monitor-queue $n(0) $n(12) $monitor012 0.001]
[$ns link $n(0) $n(12)] queue-sample-timeout
set monitor014 [open qm014.out w]
set qm014 [$ns monitor-queue $n(0) $n(14) $monitor014 0.001]
[$ns link $n(0) $n(14)] queue-sample-timeout
set monitor131 [open qm131.out w]
set qm131 [$ns monitor-queue $n(13) $n(1) $monitor131 0.001]
[$ns link $n(13) $n(1)] queue-sample-timeout
set monitor151 [open qm151.out w]
set qm151 [$ns monitor-queue $n(15) $n(1) $monitor151 0.001]
[$ns link $n(15) $n(1)] queue-sample-timeout

# Traffic used
# Web traffic
# Setup PackMime
Agent/TCP/FullTcp set segsize_ 1500
set web_traffic [new PackMimeHTTP]
$web_traffic set-client $n(2)
$web_traffic set-server $n(7)
$web_traffic set-rate 2
$web_traffic set-http-1.1
# FTP traffic
set tcp_ftp [new Agent/TCP]
set tcpsink_ftp [new Agent/TCPSink]
$ns attach-agent $n(3) $tcp_ftp
$ns attach-agent $n(8) $tcpsink_ftp
$ns connect $tcp_ftp $tcpsink_ftp
set ftp_traffic [new Application/FTP]
$ftp_traffic attach-agent $tcp_ftp
$tcp_ftp set fid_ 1
# Streaming traffic
set udp_streaming [new Agent/UDP]
set udpnull_streaming [new Agent/Null]
$ns attach-agent $n(4) $udp_streaming
$ns attach-agent $n(9) $udpnull_streaming
$udp_streaming set packetSize_ 1500
$ns connect $udp_streaming $udpnull_streaming
$udp_streaming set fid_ 2
set tracefile_streaming [new Tracefile]
$tracefile_streaming filename traffic/camera_1M_704x576_50kB.txt.if-0.bin
set streaming_traffic [new Application/Traffic/Trace]
$streaming_traffic attach-tracefile $tracefile_streaming
$streaming_traffic attach-agent $udp_streaming
# Game traffic
set udp_game [new Agent/UDP]
set udpnull_game [new Agent/Null]
$ns attach-agent $n(5) $udp_game
$ns attach-agent $n(10) $udpnull_game
$udp_game set packetSize_ 1500
$ns connect $udp_game $udpnull_game
$udp_game set fid_ 3
set tracefile_game [new Tracefile]
$tracefile_game filename traffic/camera_1M_704x576_50kB.txt.if-0.bin
set game_traffic [new Application/Traffic/Trace]
$game_traffic attach-tracefile $tracefile_game
$game_traffic attach-agent $udp_game
# VoIP traffic
set udp_voip [new Agent/UDP]
set udpnull_voip [new Agent/Null]
$ns attach-agent $n(6) $udp_voip
$ns attach-agent $n(11) $udpnull_voip
$ns connect $udp_voip $udpnull_voip
$udp_voip set fid_ 4
set voip_traffic [new Application/Traffic/CBR]
$voip_traffic set packetSize_ 60
$voip_traffic set interval_ 0.02
$voip_traffic attach-agent $udp_voip
# VoIP traffic
set udp_voip_1 [new Agent/UDP]
set udpnull_voip_1 [new Agent/Null]
$ns attach-agent $n(12) $udp_voip_1
$ns attach-agent $n(13) $udpnull_voip_1
$ns connect $udp_voip_1 $udpnull_voip_1
$udp_voip_1 set fid_ 5
set voip_traffic_1 [new Application/Traffic/CBR]
$voip_traffic_1 set packetSize_ 60
$voip_traffic_1 set interval_ 0.02
$voip_traffic_1 attach-agent $udp_voip_1
# Videoconferencing traffic
set udp_videoconferencing [new Agent/UDP]
set udpnull_videoconferencing [new Agent/Null]
$ns attach-agent $n(14) $udp_videoconferencing
$ns attach-agent $n(15) $udpnull_videoconferencing
$udp_videoconferencing set packetSize_ 1500
$ns connect $udp_videoconferencing $udpnull_videoconferencing
$udp_videoconferencing set fid_ 6
set tracefile_videoconferencing [new Tracefile]
$tracefile_videoconferencing filename traffic/c2MBRes800x450RugbybigPc3serv_2_360s.txt.if-0.bin
set videoconferencing_traffic [new Application/Traffic/Trace]
$videoconferencing_traffic attach-tracefile $tracefile_videoconferencing
$videoconferencing_traffic attach-agent $udp_videoconferencing

# Close files
proc finish {} {
	global ns tracefile namfile monitor01 monitor02 monitor03 monitor04 monitor05 monitor06 monitor20 monitor30 monitor40 monitor50 monitor60 monitor10 monitor17 monitor18 monitor19 monitor110 monitor1_11 monitor71 monitor81 monitor91 monitor101 monitor11_1 monitor120 monitor140 monitor113 monitor115 monitor131 monitor151 monitor012 monitor014 web_traffic
	$ns flush-trace
	close $tracefile
	close $namfile
	close $monitor01
	close $monitor10
	close $monitor02
	close $monitor03
	close $monitor04
	close $monitor05
	close $monitor06
	close $monitor17
	close $monitor18
	close $monitor19
	close $monitor110
	close $monitor1_11
	close $monitor20
	close $monitor30
	close $monitor40
	close $monitor50
	close $monitor60
	close $monitor71
	close $monitor81
	close $monitor91
	close $monitor101
	close $monitor11_1
	close $monitor120
	close $monitor140
	close $monitor113
	close $monitor115
	close $monitor131
	close $monitor151
	close $monitor012
	close $monitor014
	delete $web_traffic
	exit 0
}

# amination rate
$ns at $min_starttime "$ns set-animation-rate 0.1ms"

# scheduling events
set flows [expr ($num_node-2)/2]
$defaultRNG seed 0
set rand [new RandomVariable/Uniform]
$rand set max_ $max_starttime
$rand set min_ $min_starttime
for {set i 0} {$i < $flows} {incr i} {
	set starttime($i) [$rand value]
}
for {set i 0} {$i < $flows} {incr i} {
	puts $starttime($i)
}
$ns at $starttime(0) "$web_traffic start"
$ns at $starttime(1) "$ftp_traffic start"
$ns at $starttime(2) "$streaming_traffic start"
$ns at $starttime(3) "$game_traffic start"
$ns at $starttime(4) "$voip_traffic start"
$ns at $starttime(5) "$voip_traffic_1 start"
$ns at $starttime(6) "$videoconferencing_traffic start"
$ns at $finishtime "$web_traffic stop"
$ns at $finishtime "$ftp_traffic stop"
$ns at $finishtime "$streaming_traffic stop"
$ns at $finishtime "$game_traffic stop"
$ns at $finishtime "$voip_traffic stop"
$ns at $finishtime "$voip_traffic_1 stop"
$ns at $finishtime "$videoconferencing_traffic stop"
$ns at $finishtime "finish"
$ns run
