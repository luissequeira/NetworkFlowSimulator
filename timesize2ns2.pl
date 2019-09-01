# This code is not mine but do not remember where I got it
# Thank you very much to the author
#
# use this way:
# $ perl crl_2_ns2.pl -v pru.txt
#
# pru.txt is a .txt file. In each row it has
# inter_packet_time_in_milliseconds(no decimals) blank_space  packet_size
#10 1500
#20 1000
#30 1000
#10 20
#50 800
#20 1000
#30 1500

# generates a file
#  pru.txt.if-0.bin

#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;

our $opt_v;
getopts('v');

my $trace = shift;

die "Usage: perl crl_2_ns2.pl [-v] TRACE [PREFIX]\n"
  unless $trace;


my $ns2_prefix = shift || $trace;

# Open trace file
#
open(INPUT, '<', $trace)
  or die "Cannot open $trace for processing. $!";

binmode INPUT; # Needed for non-UNIX OSes; no harm in UNIX

use constant TSH_RECORD_LENGTH => 44;

my (%ns2_fh, %ns2_previous_timestamp, $record, %ns2_t);

print STDERR "Converting $trace to ns2 Traffic/Trace binary format...\n"
  if $opt_v;

while( $record=<INPUT> ) {

	my @vals=split(/\s+/,$record);
	my $if=0;#$vals[0]; 	Esto le puse 0 directamente, no se que significa el IF en las trazas de TSH, 
				#para el caso de convertir el fichero de nosotros de tiempo y tamaño no hace falta
	my $ip_len=$vals[1];	#Tamaño
	my $timestamp = $vals[0]; # Tiempo
	
  	unless ( defined $ns2_fh{$if}) {
    open($ns2_fh{$if}, '>', "$ns2_prefix.if-$if.bin")
      or die"Cannot open $ns2_prefix.if-$if.bin. $!";

    binmode $ns2_fh{$if}; # Needed for non-UNIX OSes; no harm in UNIX

    $ns2_previous_timestamp{$if} = $timestamp;
  }

  my $dt = ( $timestamp );# * 1_000;#( $timestamp - $ns2_previous_timestamp{$if} ) * 1_000_000; # Le quité la resta porque lo que hay en el
												# fichero es tiempo entre paquetes
#if($dt==0){ $dt=1;}
  print
    { $ns2_fh{$if} }
      pack( 'NN', # two integers: interpacket time (usec), packet size (B)
	    sprintf("%.0f", $dt), $ip_len
	  );
  printf("%.0f %4d\n", $dt, $ip_len);
  $ns2_t{$if} += $dt;
  $ns2_previous_timestamp{$if} = $timestamp;
}

close INPUT;

foreach ( sort keys %ns2_fh ) {
  close $ns2_fh{$_};

  print STDERR
    "Interface $_ traffic stored in $ns2_prefix.if-$_.bin. ",
    "Traffic duration: ", $ns2_t{$_}/1_000_000, " sec\n"
    if $opt_v;

}
__END__

####MODIFIED FROM### BY ALOK 
Takes in an ASCII format of input and converst into NS trace format.  the trace formate 
that has been used is of the following format.. 
<IF> <TIME_STAMP>  <IP_FROM> <IP_TO>  <PACKETSIZE> ....
0 1115024405.935260 151.46.152.219 152.2.210.120 40 6 1654 8000
0 1115024405.935406 220.134.53.170 152.2.210.120 40 6 1096 8000
0 1115024405.935465 68.209.187.239 152.2.210.120 40 6 50016 8000
0 1115024405.935465 69.168.22.180 152.2.210.120 40 6 3356 8000
1 1115024405.935542 152.2.210.109 81.64.90.212 1500 6 80 47513
1 1115024405.935636 152.2.210.121 62.194.34.167 1500 6 80 1153
1 1115024405.935667 152.2.210.109 81.64.90.212 1500 6 80 47513
0 1115024405.935825 217.230.24.106 152.2.210.80 40 6 60025 53316
0 1115024405.935825 201.137.69.127 152.2.210.80 40 6 1868 59887
0 1115024405.936002 200.76.190.41 152.2.210.80 40 6 1209 53888
####
trace replay requires only two paramters the inter-arrival time and the packet size.
The interface is optionally used to split the traffic into the forward and reverse directions.

In order to extend this script.. just change lines 33-35 of script to conform to your input trace format
#####END ALOKS PART#################

=head1 NAME

tsh2ns2.pl - Convert a single TSH trace to ns2 Traffic/Trace binary format

=head1 SYNOPSIS

 perl tsh2ns2.pl [-v] TRACE [PREFIX]

=head1 DESCRIPTION

C<tsh2ns2.pl> converts a binary TSH TRACE to ns2 Traffic/Trace binary
files, generating one file per interface observed in the trace.  Use
the C<-v> option to display progress information.  If F<PREFIX> is
provided, C<tsh2ns2.pl> will store the results of the conversion to
F<PREFIX.if-X.bin>, where F<X> is the interface number.

For example, if F<sample.tsh> contains traffic from two interfaces, 1
and 2, the following command

 % perl tsh2ns2.pl -v sample.tsh
 Converting sample.tsh to ns2 Traffic/Trace binary format...
 Interface 1 traffic stored in sample.tsh.if-1.bin. Traffic duration: 0.937443 sec
 Interface 2 traffic stored in sample.tsh.
