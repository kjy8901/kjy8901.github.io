#!/bin/perl

use strict;
use warnings;

system("sh -c 'umount /mnt/EC_VOL'");
system("sh -c 'mount -t glusterfs -o lru-limit=1 10.10.1.222:EC_VOL /mnt/EC_VOL'");

# IO
for (0..9)
{
    system("sh -c 'perl /root/memoryLeak/million/${_}million.pl &'");
}

#TOP
my $vol = 'EC_VOL';
my $millPid = `ps -ef | grep -v grep|grep 9million | awk '{print \$2 }'`;
chomp $millPid;
my $glfsPid = `ps -ef | grep -v grep|grep glusterfs | grep $vol | awk '{print \$2 }'`;
chomp $glfsPid;


`date '+%Y-%m-%d %H:%M:%S' >> /root/IO_RES_lruleak`;
`echo "#### limit default case ####" >> /root/IO_RES_lruleak &`;

system ("sh -c 'dstat -n 600 >> /root/IO_RES_lruleak_10m &'");
system ("sh -c 'dstat -n 1 >> /root/IO_RES_lruleak_1s &'");

while ($millPid ne "")
{
    `top -b -p $glfsPid -n 1 |tail -1 >> /root/IO_RES_lruleak`;
    #$glfsPid = `ps -ef | grep -v grep|grep glusterfs | grep $vol | awk '{print \$2 }'`;
    $millPid = `ps -ef | grep -v grep|grep 9million | awk '{print \$2 }'`;
    chomp $millPid;
    
    `sleep 600`;
}
#FIND
`echo "#### find start ####" >> /root/IO_RES_lruleak &`;
system ("sh -c 'find /mnt/EC_VOL -ls > /dev/null &'");
`sleep 10`;
my $findPid = `ps -ef | grep -v grep|grep find| awk '{print \$2 }'`;
chomp $findPid;
while ($findPid ne "")
{
    `top -b -p $glfsPid -n 1 |tail -1 >> /root/IO_RES_lruleak`;
    $findPid = `ps -ef | grep -v grep|grep find| awk '{print \$2 }'`;
    chomp $findPid;
    
    `sleep 600`;
}

`killall dstat`;
`killall find`;
`killall perl`;
`killall dd`;
`sleep 60`;
system("sh -c 'umount /mnt/EC_VOL'");
