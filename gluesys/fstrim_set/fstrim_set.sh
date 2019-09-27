#!/bin/bash

filename='/usr/lib/systemd/system/fstrim.timer'
cycle='OnCalendar=weekly' #weekly/daily

#perl -pi -e 's/OnCalendar=.*/${cycle}/g' $filename
sed -i 's/OnCalendar=.*/'"$cycle"'/g' $filename
systemctl enable fstrim.service
echo "fstrim.service enabled"
systemctl enable fstrim.timer
echo "fstrim.timer enabled"
systemctl start fstrim.timer
echo "fstrim.timer start"
