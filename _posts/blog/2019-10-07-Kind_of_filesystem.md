---
layout:     post
title:      "Filesystem"
date:       2019-10-07 14:01:00
author:     권 진영 (gc757489@gmail.com)
categories: blog
tags:       filesystem
cover:      "/assets/whole.png"
---

## Filesystem

#### XFS

1993년 실리콘 그래픽스가 만든 고성능 64bit 저널링 파일 시스템.
B+ Tree 구조를 사용
중간노드-xfs_da_intnote_t 구조체
리프노드-xfs_dir2_leaf_t 구조체

장점
* b-trees를 사용하여 우수한 I/O 확장성을 제공
* 이론상 900만TB까지 지원
* ext3에 비해 8배 많은 inode 생성 가능
* `xfs_growfs`명령을 사용하여 마운트 상태에서도 확장 가능
* 파일 시스템 생성시간이 타 파일 시스템에 비해 압도적으로 빠름
* 동일 크기의 파일 삭제시 ext3에 비해 약 2.5배 빠른 속도 제공
단점
* 대용량 위주의 파일시스템이라 작은 사이즈 파일에서는 오히려 속도가 느림
* ext에 비하여 이식성이 떨어짐
* 파일시스템이 깨졌을 경우 `xfs_repair`명령을 수행해야 하는데 그러기 위하여 메모리나 swap이 2TB당 1GB이상 필요
* 시스템이 아닌 별도의 데몬에서 파일시스템을 관리

#### GlusterFS

gluster사에서 만든 파일시스템으로 확장이 가능한 NAS 파일시스템. 
gluster사에 의해 개발되었으나 2011년에 레드햇에 인수되었다.

#### FAT

플로피 디스크에 사용하기 위해 1977년에 처음 설계, DOS 와 Windows 9X 시대의 하드디스크에 20년 동안 보편적으로 사용
안정성 및 확장성은 제공하지 않음

#### NTFS (New Technology File System)

윈도우NT계열 운영체제의 파일시스.
FAT를 대체, 메타데이터의 지원, 고급 데이터 구조의 사용으로 인한 성능 개선, 신뢰성, 추가 확장기능

#### HPFS (High Performance System)

OS/2 운영체제를 위해 만들어진 파일시스템.
FAT 파일시스템의 한계를 개선

#### GPFS (General Parallel File System) = IBM Spectrum Scale

파일을 각각 1MB 미만의 사이즈로 구성된 블록으로 분할하여 여러 클러스터 노드에 분산
클러스터 파일 시스템으로 불리고 고성능 공유 파일시스템
인터페이스를 사용하여 공유 파일에 즉시 액세스
다수의 노드가 동일한 파일에 동시에 액세스할 수 있다

#### FUSE (Filesystem in Userspace)

파일시스템을 커널 코드를 편집하지 않고 유저 레벨에서 쉽게 제작할 수 있도록 도와주는 Linux 기법.


- - -
참고
https://www.slideshare.net/sprdd/glusterfs-v20-26158586
http://www.zdnet.co.kr/view/?no=00000039135642
https://m.blog.naver.com/PostView.nhn?blogId=minhyupp&logNo=220200358355&proxyReferer=https%3A%2F%2Fwww.google.com%2F
wikipedia
