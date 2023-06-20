#!/bin/perl
use strict;
use warnings;

my $command='lvmconfig \
                --type current --mergedconfig \
                --config=global/thin_check_options=\'"--skip-mappings"\' \
                --withcomment -f /etc/lvm/lvm.conf';
system ($command);
