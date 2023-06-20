#!/bin/bash

# 사전작업 : script 실행할곳에
# wget http://downloads.sourceforge.net/project/winexe/winexe-1.00.tar.gz     #현재 소스포지 점검
# or download : https://sourceforge.net/projects/winexe/
# tar xzvf winexe-1.00.tar.gz
# cd winexe-1.00/source4/
# ./autogen.sh
# ./ configure
# make

# usage : ./winexe -U win_id //ip "command"



winexe -U windows_id-1%passwd //192.168.0.121 "net use \\22.22.2.22\share1 /user:user passwd"
winexe -U windows_id-2%passwd //192.168.0.122 "net use \\22.22.2.22\share2 /user:user passwd"
winexe -U windows_id-3%passwd //192.168.0.123 "net use \\22.22.2.23\share3 /user:user passwd"
winexe -U windows_id-4%passwd //192.168.0.124 "net use \\22.22.2.23\share4 /user:user passwd"
winexe -U windows_id-5%passwd //192.168.0.125 "net use \\22.22.2.24\share5 /user:user passwd"
winexe -U windows_id-6%passwd //192.168.0.126 "net use \\22.22.2.24\share6 /user:user passwd"
winexe -U windows_id-7%passwd //192.168.0.127 "net use \\22.22.2.25\share7 /user:user passwd"
winexe -U windows_id-8%passwd //192.168.0.128 "net use \\22.22.2.25\share8 /user:user passwd"
