#!/bin/perl

use strict;
use warnings;

my $out_file = '/root/memoryLeak/out_diff_statedump';
open my $out,'>',$out_file or die "Can't write new file: $!";

my @arr;
my @file;
my @line;
my $ARGC=@ARGV;
my @double_line=([],[]);
my $double_tmp=0;

for (my $i=0;$i<$ARGC;$i++) 
{
    $arr[$i]=shift; #매개변수받은거 전달ok
    open $file[$i],'<',$arr[$i] or die "Can't open file: $!";
}

while(1)
{
#    print $out "attribute  : size:num_allocs:max_size:max_num_allocs:total_allocs \n";
    for (my $i=0;$i<$ARGC;$i++)
    {
        $line[$i] = readline $file[$i];
#	print $out "dump num $i : ";
#	print $out $line[$i];
	$double_line[$double_tmp][$i]=$line[$i];
    }
#    print $out "------------------------------------------------------------ \n";
    $double_tmp++;
    last if($line[0] eq '');
}

my $key;
my @keys;
my $tmp;
my @tmp2;
for(my $i=0;$i<$double_tmp;$i++)
{
    my @tmp = split(/:/,$double_line[$i][0]);
    $tmp2[$i]= $tmp[0]; #기준값 삽입
}

my $i=0;
my $j=0;
my $k=0;

# insertion_sort
for($i=0;$i<$double_tmp;$i++)
{
    $key = $tmp2[$i];
    for($k=0;$k<$ARGC;$k++)
    {
        $keys[$k] = $double_line[$i][$k];
    }

    for($j=$i-1;$j>=0 && $tmp2[$j]<$key;$j--)
    {
        $tmp2[$j+1] = $tmp2[$j];
        for(my $k=0;$k<$ARGC;$k++)
        {
            $double_line[$j+1][$k] = $double_line[$j][$k];
        }
    }

    $tmp2[$j+1] = $key;
    for(my $k=0;$k<$ARGC;$k++)
    {
        $double_line[$j+1][$k] = $keys[$k];
    }
}

# 2차원 배열 파일 프린트
for(my $m=0;$m<$double_tmp;$m++)
{
    print $out "attribute  : size:num_allocs:max_size:max_num_allocs:total_allocs \n";
    for(my $n=0;$n<$ARGC;$n++)
    {
	print $out "dump num $n : ";
        print $out $double_line[$m][$n];
    }
    print $out "----------------------------------------------------------------- \n";
}

for (my $i=0;$i<$ARGC;$i++) 
{
    close($file[$i]);
}
close($out);
