#!/bin/perl

use strict;
use warnings;

my $glfsPid = `ps -C glusterfs -o pid --no-heading`; #crond => glusterfs change
my @glfsPid = split(/\s+/,$glfsPid); #공백제거
my $glfsPid2 = $glfsPid[0];

kill 10, $glfsPid2; #create statedump

my $timestamp = `date +%s`;
chomp($timestamp);  # Err 처리 부분
my $read_file = "/var/run/gluster/glusterdump.$glfsPid2.dump.$timestamp"; #'/var/run/gluster/dumpfile';
my $out_file = "/root/memoryLeak/out_$timestamp";

print "Dumpfile: $read_file\n";

while (! -f $read_file)
{
    print "Waiting for dump file generating...\n";
    sleep 1;
}

open my $file,'+<',$read_file or die "Can't open file: $!";
open my $out,'>',$out_file or die "Can't write new file: $!";
my $current_line;
my @tmp;
while (my $line = <$file>){
    # if($line =~ /^\[(.*)(client.EC_vol)(.*)\]$/ || /^\[(.*)(iobuf)(.*)\]$/){ #matching [ client ] 
    if($line =~ /^\[(.*)(client.EC_vol|iobuf)(.*)\]$/ ){ #matching [ client ] 
        next if($line =~ /^\[(.*)(client-1|client-2)(.*)\]$/ );
        my $tmp_name=$line;
        
        $line = <$file>; #size
        next if ($line eq "\n");
        @tmp = split(/\=/,$line);
        if ($tmp[0] eq 'size'){
            $line = $tmp[1];
            $line =~ s/\n/:/g;
            print $out $line;
        }else{next;}
        
        $line = <$file>; #num_allocs
        next if ($line eq "\n");
        @tmp = split(/\=/,$line);
        if ($tmp[0] eq 'num_allocs'){
            $line = $tmp[1];
            $line =~ s/\n/:/g;
            print $out $line;
        }else{next;}

        $line = <$file>; #max_size
        next if ($line eq "\n");
        @tmp = split(/\=/,$line);
        if ($tmp[0] eq 'max_size'){
            $line = $tmp[1];
            $line =~ s/\n/:/g;
            print $out $line;
        }else{next;}

        $line = <$file>; #max_num_allocs
        next if ($line eq "\n");
        @tmp = split(/\=/,$line);
        if ($tmp[0] eq 'max_num_allocs'){
            $line = $tmp[1];
            $line =~ s/\n/:/g;
            print $out $line;
        }else{next;}
        
        $line = <$file>; #total_allocs
        next if ($line eq "\n");
        @tmp = split(/\=/,$line);
        if ($tmp[0] eq 'total_allocs'){
            $line = $tmp[1];
            $line =~ s/\n/:/g;
            print $out $line;
        }else{next;}
        print $out $tmp_name;
        # if line == null while처음으로
        # if $tmp[0] == 각항목[size..] 이 아니면 처음으로[next 사용]
        # 반복되는부분 함수로 추출
        # 원하는 부분[dump에서 내용] 정규표현식
    }
}
close($file);
close($out);
