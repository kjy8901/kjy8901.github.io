#!/bin/perl

use strict;
use warnings;

my $timestamp = '1235123541.3000';
my @timestamp_tmp = split(/\./, $timestamp);
$timestamp = sprintf('%s', $timestamp_tmp[0]);
print "$timestamp";

