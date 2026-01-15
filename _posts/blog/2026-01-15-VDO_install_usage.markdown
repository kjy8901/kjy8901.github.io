---
layout:     post
title:      "VDO Installation Usage"
date:       2026-01-15
categories: blog
author:     권 진영 (gc757489@gmail.com)
tags:       VDO
cover:      "/assets/757489_logo.png"
main:      "/assets/757489_logo.png"
---

## VDO install using yum

`yum install vdo kmod-kvdo`

## VDO build
`git clone git@github.com:dm-vdo/vdo.git`
`make`
`make install`

`git clone git@github.com:dm-vdo/kvdo.git`
`make -C /usr/src/kernels/\`uname -r\` M=\`pwd\``
`make -C /usr/src/kernels/\`uname -r\` M=\`pwd\` modules_install`

## usage
`vdo create --device=/dev/md0 --name=dedup_pool`

- - -

## 참고
