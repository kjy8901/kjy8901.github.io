#!/bin/perl

use strict;
use warnings;

#sub println(@)
#{
#    print map{"$_\n"} @_;
#}

my $tmp = `df |grep EC_vol`;
my @tmp2 = split(/\s+/,$tmp);
my $availCapacity=$tmp2[3];
my $i=0;

print "I/O Start";
while ( $availCapacity > 40960) #40960
{
    my $ran=int(rand(20))+20;
    $tmp = `df |grep EC_vol`;
    @tmp2 = split(/\s+/,$tmp);
    $availCapacity=$tmp2[3];

    print "I/O $i \n ";
    `dd if=/dev/urandom of=/mnt/EC_vol/tmp$i bs=1M count=$ran`;
    $i+=1;
}

print "I/O Finish";

print "remove data \n";
`rm -rf /mnt/EC_vol/tmp*`;
`sleep 10`;
print "remove complete \n"
