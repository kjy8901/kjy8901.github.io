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
my $vol="tmpvol";

print "I/O Start";
`mkdir /mnt/EC_VOL/$vol`;
for(my $i=0;$i<50;$i++)
{
        `dd if=/dev/zero of=/mnt/EC_VOL/$vol/tmp$i bs=10G count=1`;
}
print "I/O Finish";
