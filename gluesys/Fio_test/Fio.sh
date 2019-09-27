#!/bin/bash

today=`date +%Y%m%d`

mkdir /root/dir/perf_test/$today
echo "FIO Seq Read Test"
fio /root/dir/perf_test/SeqR --output=/root/dir/perf_test/$today/SeqR.txt
mv -f /root/dir/perf_test/*.log /root/dir/perf_test/SeqR
sleep 1m
echo "FIO Seq Write Test"
fio /root/dir/perf_test/SeqW --output=/root/dir/perf_test/$today/SeqW.txt
mv -f /root/dir/perf_test/*.log /root/dir/perf_test/SeqW
echo "FIO Seq RW Test"
fio /root/dir/perf_test/Seq91 --output=/root/dir/perf_test/$today/Seq91.txt
mv -f /root/dir/perf_test/*.log /root/dir/perf_test/Seq91
sleep 1m
echo "FIO Random Read Test"
fio /root/dir/perf_test/RanR --output=/root/dir/perf_test/$today/RanR.txt
mv -f /root/dir/perf_test/*.log /root/dir/perf_test/RanR
sleep 1m
echo "FIO Random Write Test"
fio /root/dir/perf_test/RanW --output=/root/dir/perf_test/$today/RanW.txt
mv -f /root/dir/perf_test/*.log /root/dir/perf_test/RanW
sleep 1m
echo "FIO Random RW Test"
fio /root/dir/perf_test/Ran91 --output=/root/dir/perf_test/$today/Ran91.txt
mv -f /root/dir/perf_test/*.log /root/dir/perf_test/Ran91
sleep 1m
echo "FIO Nubjobs8 Write Test"
fio /root/dir/perf_test/NumJob8_SeqW --output=/root/dir/perf_test/$today/NumJob8_SeqW.txt
mv -f /root/dir/perf_test/*.log /root/dir/perf_test/NumJob8_SeqW
sleep 1m
echo "FIO Nubjobs8 Read Test"
fio /root/dir/perf_test/NumJob8_SeqR --output=/root/dir/perf_test/$today/NumJob8_SeqR.txt
mv -f /root/dir/perf_test/*.log /root/dir/perf_test/NumJob8_SeqR
sleep 1m
echo "FIO Nubjobs8 RW Test"
fio /root/dir/perf_test/NumJob8_Seq91 --output=/root/dir/perf_test/$today/NumJob8_Seq91.txt
mv -f /root/dir/perf_test/*.log /root/dir/perf_test/NumJob8_Seq91
sleep 1m
