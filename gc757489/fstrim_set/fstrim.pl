#!/usr/bin/perl

use Cluster::MDSAdapter;
use Data::Dumper;

my $t = Cluster::MDSAdapter->new();
my $pu = $t->get_conf("Publisher");
#delete($pu->{Trim});

#$t->set_conf("Publisher", $pu);
print Dumper($pu);
