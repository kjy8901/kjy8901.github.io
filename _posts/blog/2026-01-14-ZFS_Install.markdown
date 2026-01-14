---
layout:     post
title:      "ZFS make"
date:       2026-01-14
categories: blog
author:     권 진영 (gc757489@gmail.com)
tags:       MOP 
cover:      "/assets/757489_logo.png"
main:      "/assets/757489_logo.png"
---

## ZFS

#### Install

Rocky 8.7 기준 설치

1. required packagers

`sudo dnf install --skip-broken epel-release gcc make autoconf automake libtool rpm-build kernel-rpm-macros libtirpc-devel libblkid-devel libuuid-devel libudev-devel openssl-devel zlib-devel libaio-devel libattr-devel elfutils-libelf-devel kernel-devel-$(uname -r) kernel-abi-stablelists-$(uname -r | sed 's/\.[^.]\+$//') python3 python3-devel python3-setuptools python3-cffi libffi-devel ncompress`
`sudo dnf install --skip-broken --enablerepo=epel --enablerepo=powertools python3-packaging dkms`

2. git clone
`git clone https://github.com/zfsonlinux/zfs.git`
`cd zfs`
`./autogen.sh`

3. DKMS
`cd zfs`
`./configure`
`make -j1 rpm-utils rpm-dkms`
`sudo yum localinstall *.$(uname -p).rpm *.noarch.rpm`

4. ZFS
`./configure`
`make -j1 rpm-utils rpm-kmod`
`sudo yum localinstall *.$(uname -p).rpm`

5. modprobe
`modprobe zfs`
modprobe 안될 경우 참고 1번 확인

- - -

## 참고

 * https://openzfs.github.io/openzfs-docs/Developer%20Resources/Custom%20Packages.html#
  * https://openzfs.github.io/openzfs-docs/Developer%20Resources/Building%20ZFS.html#github-repositories

