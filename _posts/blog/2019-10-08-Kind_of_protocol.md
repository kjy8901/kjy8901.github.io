---
layout:     post
title:      "Protocol"
date:       2019-10-08 14:01:00
author:     권 진영 (gc757489@gmail.com)
categories: blog
tags:       protocol
cover:      ""
---

## Protocol

#### SNMP (Simple Network Management protocol)
TCP/IP 기반의 네트워크에서 네트워크 사이의 각 호스트에서 정기적으로 여러가지 정보를 자동적으로 수집하여 네트워크 관리를 하기 위한 프로토콜
#### SMB (Server Message Block)
LAN이나 컴퓨터 간의 통신에서 데이터 송수신을 하기 위한 프로토콜
### SMB2
SMB1의 chattiness를 줄여 백개 이상의 명령을 19개로 감소 시킴으로 높은 지연성르 지닌 링크에 대한 성능이 향상됨
windows vista/ windows server 2008에 도입
여러 SMB2요청을 단일 네트워크 요청으로 전송가능(요청 복함)
높은 대기 시간에도 고속네트워크를 효율적으로 활용가능
클라이언트에서 폴더 및 파일의 로컬 복사본 유지함 (폴더 및 파일 속성 캐싱)
연결이 일시적으로 중단될 경우 SMB2연결을 사용하여 서버에 투명하게 재연결 가능
기존의 MD5를 HMAC SHA-256으로 대체
서버당 사용자, 공유 및 열린 파일 수 증가
### SMB2.1
클라이언트 oplock 임대모델
대용량 MTU 지원
클라이언트에 대한 에너지 효율성 향상
이전버전 SMB에 대한 지원
### SMB3
초기 이름은 SMB2.2였다.
windows 8, windows server 2012에 도입
SMB 멀티채널기능(세션당 다중 연결기능) 추가
가상화된 데이터 센터에서 SMB2 기능을 향상
#### CIFS (Common Internet File System)
SMB 파일 공유 프로토콜의 확장된 버전, 인터넷 표준 프로콜
* flexible connectivity : 단일 클라이언트에서 여러서버에 연결하거나 다중 클라이언트에서 단일 서버를 연결
* Resource access : 클라이언트가 동시에 타겟 서버에 여러 공유 자원에 액세스가능
* Locking and Caching : 파일 및 레코드 잠금, 데이터 캐시 기능 지원
* Security context : 클라이언트는 연결을 통해 하나또는 이상의 보안 컨텍스트를 만들어서 사용할 수 있음
* Unicode support : 유니코드 지원
#### samba
Windows 운영체제에서 Linux또는 UNIX 서버에 접속하여 파일이나 프린터를 공유하여 사용할 수 있도록 해 주는 소프트웨. SMB/CIFS 프로토콜을 다시 구현한 자유 소프트웨어

#### NFS (Network File System)
1984년 썬 마이크로 시스템즈가 개발한 프로토콜으로 클라이언트의 사용자가 네트워크상의 파일을 직접 연결된 스토리지에 접근하는 방식과 비슷한 방식으로 접근을 가능하게 해줌.
제한
* 오픈 아키텍쳐에 대한 지배력이 없다
* 리눅스 파일 시스템 특징이 보장되지 않는다
* 특별한 파일(디바이스 파일)에는 원격 접속이 이루어지지 않는다
* 다른 운영 체제에 대해 다른 버전간에 완벽한 호환이 되지 않는 경우가 있다.
### NFS-Ganesha

#### LDAP (Lightweight Directory Access Protocol)
TCP/IP 위에서 디렉터리 서비스를 조회하고 수정하는 응용 프로토콜이다.
#### SMTP (Simple Mail Transfer Protocol)
인테넛에서 이메일을 보내기 위해 이용되는 프로토콜. 포트번호 25.  
#### NDMP (Network Data Mangaement Protocol)
프로토콜 네트워크 부착 스토리지 간 데이터전송, 백업 서버 자체를 통해 데이터를 전송할 필요가 없으므로 속도가 향상되고 백업 서버에서 로드가 제거

- - -
참고
