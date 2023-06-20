#!/bin/bash

vg_restore(){
    # vgextend restore
    echo "functioan call"
    trash=`vgextend --restoremissing ${vg_name[$1]} ${pv_name[$1]}`
}

# missing pv check
device_arr=( `pvs |grep dev|awk '{print $1}'` )
pv_name=()
vg_name=()

for i in ${device_arr[*]}
do
    excute_ret=`pvs $i |grep dev|awk '{print $4}'|grep m`
    if [ x$excute_ret == x ]; then
        echo "here is null"
    else
        echo "not null equal missing"
        pv_name+=(`pvs $i|grep dev|awk '{print $1}'`)
        vg_name+=(`pvs $i|grep dev|awk '{print $2}'`)
    fi
done

#pvck 
echo "pvck test"
l=0
for n in ${pv_name[*]}
do
    trash=`pvck $n`
    if [ $? == 0 ]; then
       vg_restore "$l"
       l=$(($l+1))
    fi
done

