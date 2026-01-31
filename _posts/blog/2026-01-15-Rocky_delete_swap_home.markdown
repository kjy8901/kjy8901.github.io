---
layout:     post
title:      "Delete Swap,home on Rocky8"
date:       2026-01-15
categories: blog
author:     권 진영 (gc757489@gmail.com)
tags:       Rocky8 swap home
cover:      "/assets/757489_logo.png"
main:      "/assets/757489_logo.png"
---
#### 1. `/etc/fstab` 수정
   - 하위의 home, 및 swap 관련 부분 주석(#) 혹은 삭제
```bash
[root@localhost ~]# vim /etc/fstab
#/dev/mapper/rl-home     /home                   xfs     defaults        0 0
#/dev/mapper/rl-swap     none                    swap    defaults        0 0
```
#### 2. home 제거 절차
2-1. home umount
```bash
   [root@localhost ~]# umount /home
```
2-2. home LV 삭제
```bash
[root@localhost ~]# lvremove /dev/rl/home
Do you really want to remove active logical volume rl/home? [y/n]: y
  Logical volume "home" successfully removed.
```
#### 3. swap 제거 절차
3-1. swap LV 삭제
```bash
[root@localhost ~]# lvremove /dev/rl/swap
  Logical volume rl/swap in use.
[root@localhost ~]# swapoff -a
[root@localhost ~]# lvremove /dev/rl/swap
Do you really want to remove active logical volume rl/swap? [y/n]: y
  Logical volume "swap" successfully removed.
```
3-2. /boot/grub2/grubenv 수정
- resume=/dev/mapper/rl-swap,  rd.lvm.lv=rl/swap 삭제
```bash
# GRUB Environment Block
saved_entry=7b92728670d64c65879a91ae405012ed-4.18.0-553.22.1.el8_10.x86_64
kernelopts=root=/dev/mapper/rl-root ro crashkernel=auto resume=/dev/mapper/rl-swap rd.lvm.lv=rl/root rd.lvm.lv=rl/swap
boot_success=0

- - -
# GRUB Environment Block
saved_entry=7b92728670d64c65879a91ae405012ed-4.18.0-553.22.1.el8_10.x86_64
kernelopts=root=/dev/mapper/rl-root ro crashkernel=auto  rd.lvm.lv=rl/root
boot_success=0
```
3-3. /etc/grub2.cfg 수정 (Line 140)
```bash
139 if [ -z "${kernelopts}" ]; then
140   set kernelopts="root=/dev/mapper/rl-root ro crashkernel=auto resume=/dev/mapper/rl-swap rd.lvm.lv=rl/root rd.lvm.lv=rl/swap "
141 fi

- - -
139 if [ -z "${kernelopts}" ]; then
140   set kernelopts="root=/dev/mapper/rl-root ro crashkernel=auto rd.lvm.lv=rl/root"
141 fi

```
#### 4. root LV 확장
```bash
[root@localhost ~]# lvextend -l +100%FREE /dev/rl/root
  Size of logical volume rl/root changed from 70.00 GiB (17920 extents) to <464.76 GiB (118978 extents).
  Logical volume rl/root successfully resized.
```
#### 5. root xfs 파일시스템 확장
```bash
[root@localhost ~]# xfs_growfs /dev/rl/root
meta-data=/dev/mapper/rl-root    isize=512    agcount=4, agsize=4587520 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=18350080, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=8960, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 18350080 to 121833472
```

- - -

## 참고

