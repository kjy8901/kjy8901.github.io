#!/bin/perl

use strict;
use warnings;

system("sh -c 'umount /mnt/EC_VOL'");
system("sh -c 'mount -t glusterfs -o lru-limit=200 10.10.1.222:EC_VOL /mnt/EC_VOL'");

`date '+%Y-%m-%d %H:%M:%S' >> /root/find_2040_200`;
`echo "#### START FIND LRU = 1 ####" >> /root/find_2040_200 &`;

my $vol = 'EC_VOL';
my $millPid = `ps -ef | grep -v grep|grep 9million | awk '{print \$2 }'`;
chomp $millPid;
my $glfsPid = `ps -ef | grep -v grep|grep glusterfs | grep $vol | awk '{print \$2 }'`;
chomp $glfsPid;
#FIND
`echo "#### find start ####" >> /root/find_2040_200 &`;
system ("sh -c 'find /mnt/EC_VOL -ls > /dev/null &'");
`sleep 10`;
my $findPid = `ps -ef | grep -v grep|grep find| awk '{print \$2 }'`;
chomp $findPid;
while ($findPid ne "")
{
    `top -b -p $glfsPid -n 1 |tail -1 >> /root/find_2040_200`;
    $findPid = `ps -ef | grep -v grep|grep find| awk '{print \$2 }'`;
    chomp $findPid;
    
    `sleep 10`;
}

`date '+%Y-%m-%d %H:%M:%S' >> /root/find_2040_200`;
`killall find`;
`sleep 60`;
