#!/bin/perl

use strict;
use warnings;

my $out_file = '/root/memoryLeak/out_diff_statedump';
open my $out,'>',$out_file or die "Can't write new file: $!";

my @arr;
my @file;
my @line;
my $ARGC=@ARGV;

for (my $i=0;$i<$ARGC;$i++) 
{
    $arr[$i]=shift; #매개변수받은거 전달ok
    open $file[$i],'<',$arr[$i] or die "Can't open file: $!";
}

while(1)
{
    print $out "attribute  : size:num_allocs:max_size:max_num_allocs:total_allocs \n";
    for (my $i=0;$i<$ARGC;$i++)
    {
        $line[$i] = readline $file[$i];
	print $out "dump num $i : ";
	print $out $line[$i];
    }
    print $out "------------------------------------------------------------ \n";
    last if($line[0] eq '');
}

for (my $i=0;$i<$ARGC;$i++) 
{
    close($file[$i]);
}
close($out);
# add sort
