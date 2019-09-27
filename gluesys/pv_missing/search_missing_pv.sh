#!/bin/bash

pv_status=`pvs|grep dev|awk '{print $4 }'|grep -`
#pv_status=`pvs|grep dev|awk '{print $4 }'`
#echo $pv_status"\n"
# 모니터는 대충 이렇게하고
