#!/bin/bash

tail -n +2 Bandx.dat > Bandy.dat
i=1
dist=0
cat Bandy.dat | while read line
do
if [ "$i" -eq "1" ]
then
kx=$(echo $line | awk '{ print $1}')
ky=$(echo $line | awk '{ print $2}')
kz=$(echo $line | awk '{ print $3}')
fi
if [ $((i%2)) -ne "0" ]
then
kx1=$(echo $line | awk '{ print $1}')
ky1=$(echo $line | awk '{ print $2}')
kz1=$(echo $line | awk '{ print $3}')
dist=`echo "scale=16;(sqrt((($kx-($kx1))^2) + (($ky-($ky1))^2) + (($kz-($kz1)))^2)) + $dist" |bc -l`
fi

kx=$kx1
ky=$ky1
kz=$kz1

if [ $((i%2)) -eq 0 ]
then
echo "$dist     $line" >> plotband.dat
fi
i=`expr $i + 1`
done
