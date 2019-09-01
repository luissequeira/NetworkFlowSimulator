#!/bin/bash
read -p "Enter NS2 file for simulation: " ns2_file
read -p "Enter folder name: " folder
read -p "Enter number of iterations: " iteration
echo "Preparing files"
mkdir $folder
mkdir $folder/$folder.traces
mkdir $folder/$folder.csv
mkdir $folder/$folder.resume
cp $ns2_file $folder
cp -r traffic $folder/traffic
cd $folder
for ((i=0;i<$iteration;i++))
	do
		echo "Simulating for $i of $iteration iterations"
		ns $ns2_file
		echo "Copying traces for $i of $iteration iteration"
		for x in `ls *.out`
			do
				cp $x $folder.traces/$folder.$i.$x
				cp $x $folder.resume/$folder.$i.$x
		done
		cp out.tr $folder.traces/$folder.$i.out.tr
		cp out.nam $folder.traces/$folder.$i.out.nam
		echo "Copying csv for $i of $iteration iteration"
		for x in `ls qm*.out`
			do
				cp $x $folder.csv/$folder.$i.$x.csv
				sed -i "s/ /,/g" $folder.csv/$folder.$i.$x.csv
		done
		cp out.tr $folder.traces/$folder.$i.out.tr
		cp out.nam $folder.traces/$folder.$i.out.nam
		echo "Cleaning for $i of $iteration iteration"
		rm *.out *.tr *.nam
done
echo "Simulation $i of $iteration finished"
echo "Calculating resume for UDP flows"
cd $folder.resume
for x in `ls *.out`
	do
		awk '
			BEGIN{}
			{
				if (NF!=0 && $1!=0 && $9!=0){
					instant_arrived_bw=($9+28)*8/$1
					instant_departed_bw=($10+28)*8/$1
					printf $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " instant_arrived_bw " " instant_departed_bw "\n"
				}
			}
		' $x > $x.temp
		awk '
			BEGIN{
				dropped_bytes=0
				dropped_packets=0
				arrived_bytes=0
				arrived_packets=0
				time=0
				i=0
			}
			{
				if (NF!=0){
					dropped_bytes=$11
					dropped_packets=$8
					arrived_bytes=$9
					arrived_packets=$6
					time=$1
					arrived_bw=arrived_bw+$12
					departed_bw=departed_bw+$13
					i++
				}
			}
			END{
				if (NF!=0){
					printf dropped_bytes " " dropped_packets " " arrived_bytes " " arrived_packets " " arrived_bw/i " " departed_bw/i "\n"
				}
			}
		' $x.temp > $x.resume
done
echo "Calculating resume for TCP flows"
for x in `ls *.qm02.out`
	do
		awk '
			BEGIN{}
			{
				if (NF!=0 && $1!=0 && $9!=0){
					instant_arrived_bw=($9+40)*8/$1
					instant_departed_bw=($10+40)*8/$1
					printf $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " instant_arrived_bw " " instant_departed_bw "\n"
				}
			}
		' $x > $x.temp
		awk '
			BEGIN{
				dropped_bytes=0
				dropped_packets=0
				arrived_bytes=0
				arrived_packets=0
				time=0
				i=0
			}
			{
				if (NF!=0){
					dropped_bytes=$11
					dropped_packets=$8
					arrived_bytes=$9
					arrived_packets=$6
					time=$1
					arrived_bw=arrived_bw+$12
					departed_bw=departed_bw+$13
					i++
				}
			}
			END{
				if (NF!=0){
					printf dropped_bytes " " dropped_packets " " arrived_bytes " " arrived_packets " " arrived_bw/i " " departed_bw/i "\n"
				}
			}
		' $x.temp > $x.resume
done
for x in `ls *.qm20.out`
	do
		awk '
			BEGIN{}
			{
				if (NF!=0 && $1!=0 && $9!=0){
					instant_arrived_bw=($9+40)*8/$1
					instant_departed_bw=($10+40)*8/$1
					printf $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " instant_arrived_bw " " instant_departed_bw "\n"
				}
			}
		' $x > $x.temp
		awk '
			BEGIN{
				dropped_bytes=0
				dropped_packets=0
				arrived_bytes=0
				arrived_packets=0
				time=0
				i=0
			}
			{
				if (NF!=0){
					dropped_bytes=$11
					dropped_packets=$8
					arrived_bytes=$9
					arrived_packets=$6
					time=$1
					arrived_bw=arrived_bw+$12
					departed_bw=departed_bw+$13
					i++
				}
			}
			END{
				if (NF!=0){
					printf dropped_bytes " " dropped_packets " " arrived_bytes " " arrived_packets " " arrived_bw/i " " departed_bw/i "\n"
				}
			}
		' $x.temp > $x.resume
done
for x in `ls *.qm03.out`
	do
		awk '
			BEGIN{}
			{
				if (NF!=0 && $1!=0 && $9!=0){
					instant_arrived_bw=($9+40)*8/$1
					instant_departed_bw=($10+40)*8/$1
					printf $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " instant_arrived_bw " " instant_departed_bw "\n"
				}
			}
		' $x > $x.temp
		awk '
			BEGIN{
				dropped_bytes=0
				dropped_packets=0
				arrived_bytes=0
				arrived_packets=0
				time=0
				i=0
			}
			{
				if (NF!=0){
					dropped_bytes=$11
					dropped_packets=$8
					arrived_bytes=$9
					arrived_packets=$6
					time=$1
					arrived_bw=arrived_bw+$12
					departed_bw=departed_bw+$13
					i++
				}
			}
			END{
				if (NF!=0){
					printf dropped_bytes " " dropped_packets " " arrived_bytes " " arrived_packets " " arrived_bw/i " " departed_bw/i "\n"
				}
			}
		' $x.temp > $x.resume
done
for x in `ls *.qm30.out`
	do
		awk '
			BEGIN{}
			{
				if (NF!=0 && $1!=0 && $9!=0){
					instant_arrived_bw=($9+40)*8/$1
					instant_departed_bw=($10+40)*8/$1
					printf $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " instant_arrived_bw " " instant_departed_bw "\n"
				}
			}
		' $x > $x.temp
		awk '
			BEGIN{
				dropped_bytes=0
				dropped_packets=0
				arrived_bytes=0
				arrived_packets=0
				time=0
				i=0
			}
			{
				if (NF!=0){
					dropped_bytes=$11
					dropped_packets=$8
					arrived_bytes=$9
					arrived_packets=$6
					time=$1
					arrived_bw=arrived_bw+$12
					departed_bw=departed_bw+$13
					i++
				}
			}
			END{
				if (NF!=0){
					printf dropped_bytes " " dropped_packets " " arrived_bytes " " arrived_packets " " arrived_bw/i " " departed_bw/i "\n"
				}
			}
		' $x.temp > $x.resume
done
for x in `ls *.qm17.out`
	do
		awk '
			BEGIN{}
			{
				if (NF!=0 && $1!=0 && $9!=0){
					instant_arrived_bw=($9+40)*8/$1
					instant_departed_bw=($10+40)*8/$1
					printf $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " instant_arrived_bw " " instant_departed_bw "\n"
				}
			}
		' $x > $x.temp
		awk '
			BEGIN{
				dropped_bytes=0
				dropped_packets=0
				arrived_bytes=0
				arrived_packets=0
				time=0
				i=0
			}
			{
				if (NF!=0){
					dropped_bytes=$11
					dropped_packets=$8
					arrived_bytes=$9
					arrived_packets=$6
					time=$1
					arrived_bw=arrived_bw+$12
					departed_bw=departed_bw+$13
					i++
				}
			}
			END{
				if (NF!=0){
					printf dropped_bytes " " dropped_packets " " arrived_bytes " " arrived_packets " " arrived_bw/i " " departed_bw/i "\n"
				}
			}
		' $x.temp > $x.resume
done
for x in `ls *.qm71.out`
	do
		awk '
			BEGIN{}
			{
				if (NF!=0 && $1!=0 && $9!=0){
					instant_arrived_bw=($9+40)*8/$1
					instant_departed_bw=($10+40)*8/$1
					printf $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " instant_arrived_bw " " instant_departed_bw "\n"
				}
			}
		' $x > $x.temp
		awk '
			BEGIN{
				dropped_bytes=0
				dropped_packets=0
				arrived_bytes=0
				arrived_packets=0
				time=0
				i=0
			}
			{
				if (NF!=0){
					dropped_bytes=$11
					dropped_packets=$8
					arrived_bytes=$9
					arrived_packets=$6
					time=$1
					arrived_bw=arrived_bw+$12
					departed_bw=departed_bw+$13
					i++
				}
			}
			END{
				if (NF!=0){
					printf dropped_bytes " " dropped_packets " " arrived_bytes " " arrived_packets " " arrived_bw/i " " departed_bw/i "\n"
				}
			}
		' $x.temp > $x.resume
done
for x in `ls *.qm18.out`
	do
		awk '
			BEGIN{}
			{
				if (NF!=0 && $1!=0 && $9!=0){
					instant_arrived_bw=($9+40)*8/$1
					instant_departed_bw=($10+40)*8/$1
					printf $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " instant_arrived_bw " " instant_departed_bw "\n"
				}
			}
		' $x > $x.temp
		awk '
			BEGIN{
				dropped_bytes=0
				dropped_packets=0
				arrived_bytes=0
				arrived_packets=0
				time=0
				i=0
			}
			{
				if (NF!=0){
					dropped_bytes=$11
					dropped_packets=$8
					arrived_bytes=$9
					arrived_packets=$6
					time=$1
					arrived_bw=arrived_bw+$12
					departed_bw=departed_bw+$13
					i++
				}
			}
			END{
				if (NF!=0){
					printf dropped_bytes " " dropped_packets " " arrived_bytes " " arrived_packets " " arrived_bw/i " " departed_bw/i "\n"
				}
			}
		' $x.temp > $x.resume
done
for x in `ls *.qm81.out`
	do
		awk '
			BEGIN{}
			{
				if (NF!=0 && $1!=0 && $9!=0){
					instant_arrived_bw=($9+40)*8/$1
					instant_departed_bw=($10+40)*8/$1
					printf $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " instant_arrived_bw " " instant_departed_bw "\n"
				}
			}
		' $x > $x.temp
		awk '
			BEGIN{
				dropped_bytes=0
				dropped_packets=0
				arrived_bytes=0
				arrived_packets=0
				time=0
				i=0
			}
			{
				if (NF!=0){
					dropped_bytes=$11
					dropped_packets=$8
					arrived_bytes=$9
					arrived_packets=$6
					time=$1
					arrived_bw=arrived_bw+$12
					departed_bw=departed_bw+$13
					i++
				}
			}
			END{
				if (NF!=0){
					printf dropped_bytes " " dropped_packets " " arrived_bytes " " arrived_packets " " arrived_bw/i " " departed_bw/i "\n"
				}
			}
		' $x.temp > $x.resume
done
echo "Calculating total resume"
for x in qm01 qm10 qm20 qm02 qm30 qm03 qm40 qm04 qm50 qm05 qm60 qm06 qm120 qm012 qm140 qm014 qm17 qm71 qm18 qm81 qm19 qm91 qm110 qm101 qm1_11 qm11_1 qm131 qm113 qm151 qm115
	do
		for y in `ls *.*.$x.*.resume`
			do
				cat $y >> $x.txt
		done
done
for x in `ls *.txt`
	do
		awk '
			BEGIN{
				dropped_bytes=0
				dropped_packets=0
				arrived_bytes=0
				arrived_packets=0
				arrived_bw=0
				departed_bw=0
				i=0
			}
			{
				if (NF!=0){
					dropped_bytes=dropped_bytes+$1
					dropped_packets=dropped_packets+$2
					arrived_bytes=arrived_bytes+$3
					arrived_packets=arrived_packets+$4
					arrived_bw=arrived_bw+$5
					departed_bw=departed_bw+$6
					i++
				}
			}
			END{
				if (NF!=0){
					printf dropped_bytes/i " " 100*((dropped_bytes/i)/(arrived_bytes/i)) " " dropped_packets/i " " 100*((dropped_packets/i)/(arrived_packets/i)) " " arrived_bytes/i " " arrived_packets/i " " arrived_bw/i " " departed_bw/i "\n"
				}
			}
		' $x > $x.total
done
for x in qm20 qm30 qm40 qm50 qm60 qm120 qm140
	do
		cat $x.txt.total >> qm01.in
done
for x in qm17 qm18 qm19 qm110 qm1_11 qm113 qm115
	do
		cat $x.txt.total >> qm01.out
done
for x in qm02 qm03 qm04 qm05 qm06 qm012 qm014
	do
		cat $x.txt.total >> qm10.out
done
for x in qm71 qm81 qm91 qm101 qm11_1 qm131 qm151
	do
		cat $x.txt.total >> qm10.in
done
for x in qm01.in qm01.out qm10.in qm10.out
	do
		awk '
			BEGIN{
				dropped_bytes=0
				dropped_packets=0
				arrived_bytes=0
				arrived_packets=0
				arrived_bw=0
				departed_bw=0
			}
			{
				if (NF!=0){
					dropped_bytes=dropped_bytes+$1
					dropped_packets=dropped_packets+$3
					arrived_bytes=arrived_bytes+$5
					arrived_packets=arrived_packets+$6
					arrived_bw=arrived_bw+$7
					departed_bw=departed_bw+$8
				}
			}
			END{
				if (NF!=0){
					printf dropped_bytes " " dropped_packets " " arrived_bytes " " arrived_packets " " arrived_bw " " departed_bw "\n"
				}
			}
		' $x > $x.temp
done
awk '
	BEGIN{
		getline out < "qm01.out.temp"
		split(out,line," ")
	}
	{
		if (NF!=0){
			printf ($3-$1)-line[3] " " 100*((($3-$1)-line[3])/($3-$1)) " " ($4-$2)-line[4] " " 100*((($4-$2)-line[4])/($4-$2)) " " $3-$1 " " $4-$2 " " $5 " " line[6] "\n"
		}
	}
' qm01.in.temp > qm01.txt.total
awk '
	BEGIN{
		getline out < "qm10.out.temp"
		split(out,line," ")
	}
	{
		if (NF!=0){
			printf ($3-$1)-line[3] " " 100*((($3-$1)-line[3])/($3-$1)) " " ($4-$2)-line[4] " " 100*((($4-$2)-line[4])/($4-$2)) " " $3-$1 " " $4-$2 " " $5 " " line[6] "\n"
		}
	}
' qm10.in.temp > qm10.txt.total
echo "Cleaning"
rm *.resume *.temp *.in *.out
echo "Displaying information"
for x in qm01 qm10 qm20 qm02 qm30 qm03 qm40 qm04 qm50 qm05 qm60 qm06 qm120 qm012 qm140 qm014 qm17 qm71 qm18 qm81 qm19 qm91 qm110 qm101 qm1_11 qm11_1 qm131 qm113 qm151 qm115
	do
		if [ -s "$x.txt.total" ]
			then
				echo "$x.txt.total"
				echo "Dropped_bytes "%" Dropped_packets "%" Arrived_bytes Arrived_packets Arrived_bw Departed_bw"
				cat $x.txt.total
				echo " "
		fi
done
