#!/bin/bash

pcs resource add vip1 ocf:heartbeat:IPaddr2 params ip="192.168.2.173" cidr_netmask="24" nic="ens5f0"
#윗라인이 우리 vip추가하는거 변형방법이라고 생각하면될듯
pcs resource add default_gw1 ocf:heartbeat:Route params destination="default" device="bond1" gateway="192.168.0.1"
group node_name vip1 default_gw1

