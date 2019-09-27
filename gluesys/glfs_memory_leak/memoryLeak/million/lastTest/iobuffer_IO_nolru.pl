#!/bin/perl

use strict;
use warnings;

system("sh -c 'umount /mnt/EC_VOL'");
system("sh -c 'mount -t glusterfs 10.10.1.222:EC_VOL /mnt/EC_VOL'");

# IO
for (0..9)
{
    system("sh -c 'perl /root/memoryLeak/million/${_}million.pl &'");
}

#TOP
my $vol = 'EC_VOL';
my $glfsPid = `ps -ef | grep -v grep|grep glusterfs | grep $vol | awk '{print \$2 }'`;
chomp $glfsPid;

`date '+%Y-%m-%d %H:%M:%S' >> /root/IO_RES_iobufnolru`;
`echo "#### limit default case ####" >> /root/IO_RES_iobufnolru &`;

system ("sh -c 'dstat -n 600 >> /root/IO_RES_iobufnolru_10m &'");
system ("sh -c 'dstat -n 1 >> /root/IO_RES_iobufnolru_1s &'");

while ($glfsPid ne "")
{
    `top -b -p $glfsPid -n 1 |tail -1 >> /root/IO_RES_iobufnolru`;
    $glfsPid = `ps -ef | grep -v grep|grep glusterfs | grep $vol | awk '{print \$2 }'`;
    chomp $glfsPid;
    
    `sleep 600`;
}

#FIND
system ("sh -c 'find /mnt/EC_VOL -ls > /dev/null '");

`killall dstat`;
`killall find`;
`killall perl`;
`killall dd`;
`sleep 60`;
system("sh -c 'umount /mnt/EC_VOL'");
