#!/bin/perl

use strict;
use warnings;

#sub println(@)
#{
#    print map{"$_\n"} @_;
#}

my $tmp = `df |grep EC_VOL`;
my @tmp2 = split(/\s+/,$tmp);
my $availCapacity=$tmp2[3];
my $i=0;
my $vol=3;

print "I/O Start";
`mkdir /mnt/EC_VOL/$vol`;
for(my $i=0;$i<5;$i++)
{
    `mkdir /mnt/EC_VOL/$vol/$i`;
    for(my $j=0;$j<50;$j++)
    {
        print "I/O $j \n ";
        `dd if=/dev/urandom of=/mnt/EC_VOL/$vol/$i/tmp$j bs=1G count=1`;
    }
}
print "I/O Finish";
