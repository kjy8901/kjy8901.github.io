---
layout:     post
title:      "KVM Disk Expansion"
date:       2026-01-15
categories: blog
author:     권 진영 (gc757489@gmail.com)
tags:       KVM
cover:      "/assets/757489_logo.png"
main:      "/assets/757489_logo.png"
---

## KVM 디스크 확장

#### 호스트 서버
`cd /var/lib/libvirt/images`
`qemu-img resize k8s_master.qcow2 +100G`


#### 각 VM
`sudo parted /dev/vda --script "print"`
`sudo parted /dev/vda --script "resizepart 2 100%"`
`sudo partprobe /dev/vda || true`

`sudo pvresize /dev/vda2`
`pvs -o+pv_size,pv_free,vg_name | grep rl`

`sudo lvextend -r -l +100%FREE /dev/rl/root`

`xfs_growfs /dev/rl/root`

- - -

## 참고
