#!bin/perl

use strict;
use warnings;

my $filename = '/usr/lib/systemd/system/fstrim.timer';
my $data = read_file($filename);
my $cycle = 'daily'; #weekly/daily

exec ('perl -pi -e \'s/OnCalendar=[\s]/$cycle/g\' $filename');

exec ('systemctl enable fstrim.service');
print "fstrim.service enabled";
exec ('ystemctl enable fstrim.timer');
print "fstrim.timer enabled";
exec ('ystemctl start fstrim.timer');
print "fstrim.timer start";
