#!bin/perl

use strict;
use warnings;

my $filename = '/root/lvm.tmp'; #'/etc/lvm/lvm.conf';
my $line_num = 0;
open my $file,'+<',$filename or die "Can't open file";

while (my $line = <$file>){
    $line_num++;
    if($line =~ /global\s\{/){
        $line_num++;
        close($file);
        last;
    }
}
print $line_num;
my $str='    thin_check_options=\"--skip-mappings\"';
system("perl -p -i -e '\$.==$line_num and print \"$str \n\"' $filename"); 
#system("perl -p -i -e '\$.==667 and print \"kjykjy\"' /root/lvm.tmp"); 
