#!/bin/baperl

rpm -Uvh --force /root/rpmbuild/RPMS/x86_64/glusterfs-3.12.15-1.el7.centos.x86_64.rpm /root/rpmbuild/RPMS/x86_64/glusterfs-client-xlators-3.12.15-1.el7.centos.x86_64.rpm /root/rpmbuild/RPMS/x86_64/glusterfs-libs-3.12.15-1.el7.centos.x86_64.rpm /root/rpmbuild/RPMS/x86_64/glusterfs-fuse-3.12.15-1.el7.centos.x86_64.rpm

perl read_time_check_600.pl
perl read_time_check_900.pl
perl read_time_check_1000.pl
