#!/bin/bash

pcs resource create rsc_pv_monitor ocf:anystor-e:pv_recover \
    meta migration-threshold=2 failure-timeout=60s stickiness=200 \
    --disable

pcs resource enable rsc_pv_monitor 
