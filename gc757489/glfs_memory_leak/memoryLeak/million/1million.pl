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
my $vol=1;
my $ran=int(rand(20))+20;
print "I/O Start";
`mkdir /mnt/EC_VOL/$vol`;
for(my $i=0;$i<100;$i++)
{
    `mkdir /mnt/EC_VOL/$vol/$i`;
    for(my $j=0;$j<1000;$j++)
    {
        $ran=int(rand(20))+20;
        print "I/O $j \n ";
        `dd if=/dev/urandom of=/mnt/EC_VOL/$vol/$i/tmp$j bs=100k count=$ran`;
    }
}
print "I/O Finish";
#`find /mnt/EC_VOL/ -ls > /dev/null`;
#while ($availCapacity > 42412802048)
#{
#    $ran=int(rand(20))+20;
#    $tmp=`df |grep EC_VOL`;
#    @tmp2 = split(/\s+/,$tmp);
#    $availCapacity=$tmp2[3];
#    
#    `dd if=/dev/urandom of=/mnt/EC_VOL/$vol/tmp$i bs=10k count=$ran`;
#    $i+=1;
#}

