#!/bin/perl

use strict;
use warnings;

#TOP
#TOP
my $vol = 'EC_VOL';
my $glfsPid = `ps -ef | grep -v grep|grep glusterfs | grep $vol | awk '{print \$2 }'`;
chomp $glfsPid;

`date '+%Y-%m-%d %H:%M:%S' >> /root/IO_RES2`;
`top -b -p $glfsPid -n 1 |tail -1 >> /root/IO_RES2`;
`sleep 3`;
`top -b -p $glfsPid -n 1 |tail -1 >> /root/IO_RES2`;
`sleep 3`;
`top -b -p $glfsPid -n 1 |tail -1 >> /root/IO_RES2`;
`sleep 3`;
`sleep 5`;

