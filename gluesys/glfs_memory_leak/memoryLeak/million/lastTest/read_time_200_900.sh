#!/bin/baperl

rpm -Uvh --force /root/rpmbuild/RPMS/x86_64/glusterfs-3.12.15-1.el7.centos.x86_64.rpm /root/rpmbuild/RPMS/x86_64/glusterfs-client-xlators-3.12.15-1.el7.centos.x86_64.rpm /root/rpmbuild/RPMS/x86_64/glusterfs-libs-3.12.15-1.el7.centos.x86_64.rpm /root/rpmbuild/RPMS/x86_64/glusterfs-fuse-3.12.15-1.el7.centos.x86_64.rpm

perl read_time_check_200.pl
perl read_time_check_300.pl
perl read_time_check_400.pl
perl read_time_check_500.pl
perl read_time_check_600.pl
perl read_time_check_700.pl
perl read_time_check_800.pl
perl read_time_check_900.pl
