#!/bin/perl

use strict;
use warnings;

# IO
for (0..9)
{
    system("sh -c 'perl /root/memoryLeak/million/${_}million.pl &'");
}

#FIND
system ("sh -c 'find /mnt/EC_VOL -ls > /dev/null &'");

#TOP
my $vol = 'EC_VOL';
my $glfsPid = `ps -ef | grep -v grep|grep glusterfs | grep $vol | awk '{print \$2 }'`;
chomp $glfsPid;

`date '+%Y-%m-%d %H:%M:%S' >> /root/IO_RES2`;
system ("sh -c 'dstat -n 3000 >> /root/IO_RES2 &'");
`top -b -p $glfsPid -n 1 |tail -1 >> /root/IO_RES2`;
`sleep 600`;
`top -b -p $glfsPid -n 1 |tail -1 >> /root/IO_RES2`;
`sleep 600`;
`top -b -p $glfsPid -n 1 |tail -1 >> /root/IO_RES2`;
`sleep 600`;
`top -b -p $glfsPid -n 1 |tail -1 >> /root/IO_RES2`;
`sleep 600`;
`top -b -p $glfsPid -n 1 |tail -1 >> /root/IO_RES2`;
`sleep 600`;
`sleep 5`;
`killall dstat`;
