---
layout:     post
title:      "GRAID Installation"
date:       2026-01-15
categories: blog
author:     권 진영 (gc757489@gmail.com)
tags:       GRAID
cover:      "/assets/757489_logo.png"
main:      "/assets/757489_logo.png"
---

#### GRAID

대만에서 만든 GPU + RAID, NVMe 장치를 RAID할때 유용

#### GRAID 설치

드라이버 설치
1. download SupremeRAID™ Pre-installer
   - wget https://download.graidtech.com/driver/pre-install/graid-sr-pre-installer-1.6.1-128-x86_64.run
2. download driver sr-1001
   - wget https://download.graidtech.com/driver/sr/linux/1.6.1/release/graid-sr-installer-1.6.1-001-327-315.run
- [SupremeRAID™ Linux Driver 1.6.1 Update 327 Release Notes, Software, and Documentation | Software and Documentation](https://docs.graidtech.com/release-notes/linux-driver/1.6.1-327/#fixes)
3. chmod +x graid*
   - chmod +x graid-sr-pre-installer-1.6.1-128-x86_64.run
   - chmod +x graid-sr-installer-1.6.1-001-327-315.run
4. ./graid-sr-pre-installer-1.6.1-128-x86_64.run
5. ./graid-sr-installer-1.6.1-001-327-315.run
   - next, next, accept+next, next
6. graidctl apply license 44M3L5XN-BA517282-5TUYNAIP-XBUWY91J
7. graidctl list controller

레이드 구성
1. graidctl create physical_drive /dev/nvme0-3
   - 0-3은 nvme 숫자 nvme0,nvme1,nvme2,nvme3
   - 혹시 실패할 경우 nvme0n1 같이 장치의 다른 이름으로 1개씩 재시도
     - ex.  graidctl create physical_drive /dev/nvme0n1
   - 확인: graidctl list physical_drive
2.  graidctl create drive_group raid5 0-3
   - 확인: graidctl list drive_group
3. graidctl create virtual_drive 0 2T
   - 확인: graidctl list virtual_drive
   - /dev/gdg0n1 생성 완료 - 해당 장치로 사용

- - -

## 참고

 * https://graidtech.com/
