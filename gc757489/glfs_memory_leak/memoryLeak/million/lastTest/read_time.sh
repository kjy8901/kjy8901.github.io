#!/bin/baperl

rpm -Uvh --force /root/rpmbuild/RPMS/x86_64/glusterfs-3.12.15-1.el7.centos.x86_64.rpm /root/rpmbuild/RPMS/x86_64/glusterfs-client-xlators-3.12.15-1.el7.centos.x86_64.rpm /root/rpmbuild/RPMS/x86_64/glusterfs-libs-3.12.15-1.el7.centos.x86_64.rpm /root/rpmbuild/RPMS/x86_64/glusterfs-fuse-3.12.15-1.el7.centos.x86_64.rpm

perl read_time_check_1.pl
perl read_time_check_1000.pl
perl read_time_check_10000.pl
perl read_time_check_32768.pl
perl read_time_check_65536.pl
perl read_time_check_98304.pl
perl read_time_check_dft.pl

yum remove -y glusterfs glusterfs-fuse glusterfs-libs glusterfs-client
yum install -y glusterfs glusterfs-fuse
perl read_time_check_no.pl
