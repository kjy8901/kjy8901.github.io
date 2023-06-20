#!/bin/bash
glfsPid=`ps -C glusterfs -o pid --no-heading`; #crond => glusterfs change
glfsPid2=`echo $glfsPid|tr -d ''`
echo $glfsPid2
cat /proc/$glfsPid2/status | grep -E "FDSize|VmPeak|VmSize|VmHWM|VmRSS" | sed -e "1 e date +\"\n[%Y-%m-%d %T]\"" -e "s/^.\+:\s\+//g;" >> /root/15m_mem.dump
