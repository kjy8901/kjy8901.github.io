#!/bin/perl

use strict;
use warnings;

my $out_file = '/root/memoryLeak/out_diff_statedump';
open my $out,'>',$out_file or die "Can't write new file: $!";

my $read_file0 = '/root/memoryLeak/out_1559646002';
my $read_file1 = '/root/memoryLeak/out_1559647803';
my $read_file2 = '/root/memoryLeak/out_1559649601';
my $read_file3 = '/root/memoryLeak/out_1559651401';
my $read_file4 = '/root/memoryLeak/out_1559646002';
my $read_file5 = '/root/memoryLeak/out_1559646002';

open my $file0,'<',$read_file0 or die "Can't open file: $!";
open my $file1,'<',$read_file1 or die "Can't open file: $!";
open my $file2,'<',$read_file2 or die "Can't open file: $!";
open my $file3,'<',$read_file3 or die "Can't open file: $!";
open my $file4,'<',$read_file4 or die "Can't open file: $!";
open my $file5,'<',$read_file5 or die "Can't open file: $!";
my $line0;
my $line1;
my $line2;
my $line3;
my $line4;
my $line5;

while (1){
    read_line();
    print_line();
    last if($line0 eq '');
}

close($file0);
close($file1);
close($file2);
close($file3);
close($file4);
close($file5);

##### subroutin
sub read_line {
    $line0 = <$file0>;
    $line1 = <$file1>;
    $line2 = <$file2>;
    $line3 = <$file3>;
    $line4 = <$file4>;
    $line5 = <$file5>;
}
sub print_line {
#    if($line0 eq $line4){
#        return;
#    }
    print $out "  before IO : ";
    print $out $line0;
    print $out "  after  IO : ";
    print $out $line1;
    print $out "after patch : ";
    print $out $line2;
    print $out "    rm data : ";
    print $out $line3;
    print $out "  after  IO : ";
    print $out $line4;
    print $out "    rm data : ";
    print $out $line5;
    print $out ("-------------------------------------------------------------\n");
}
