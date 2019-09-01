#!/bin/bash
# cd traffic
echo "Reading capture"
# tcpdump -r $1 -tt -nn src $2 and dst $3 > $1.txt
echo "Extracting time and size"
awk '
BEGIN{
	go=0
	time_before=0
}
{
if (go==0){
	time_before=$1
	go++
}
else{
	printf ($1-time_before)*1000000 " " $2/8 "\n"
	time_before=$1
}
}' $1 > temp.txt
awk '
BEGIN{}
{
if ($1==0){
	printf 1 " " $2 "\n"
}
else{
	printf $1 " " $2 "\n"
}
}
' temp.txt > temp1.txt
cp temp1.txt $1
echo "Converting to ns2 format"
perl timesize2ns2.pl -v $1
echo "Calculating total bandwidth"
awk '
BEGIN{
	time=0
	byte=0
}
{
time=time+$1
byte=byte+$2
}
END{
printf byte "\n"
printf time/1000000 "\n"
printf (byte*8)/(time/1000000) "\n"
}' $1 > rate.txt
echo "Cleaning"
rm temp.txt temp1.txt
