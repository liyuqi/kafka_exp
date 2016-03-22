#!/usr/bin/env bash
#!/bin/sh


free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}'
top -bn1 | grep load | awk '{printf "CPU Load: %.2f\n", $(NF-2)}'

cpu_header=`sar -u| grep CPU`

sar -u | awk '{print $1$2$3$4$5$6$7$8$9}'

cpuusr=`/usr/bin/sar -u 1 3 |grep Average |awk '{print $3}'`
cpusys=`/usr/bin/sar -u 1 3 |grep Average |awk '{print $5}'`
echo $cpuusr
echo $cpusys


hd=sda
disk=/dev/$hd
#KBread_sec=`iostat -x $disk|grep $hd |awk '{print $8}'`
#KBwrite_sec=`iostat -x $disk|grep $hd |awk '{print $9}'`

#CPU, mem, swp, dr, dw, dwait, du, ni, no
CPU=top -bn1 | grep load | awk '{printf "%.2f", $(NF-2)}'
mem=`/usr/bin/free |grep Mem |awk '{print $3}'`
memp=`/usr/bin/free |grep Mem |awk '{printf "%.2f",$3/$2}'`
swap=`/usr/bin/free |grep Swap |awk '{print $3}'`
swp=`/usr/bin/free |grep Swap |awk '{printf $3}'`
hd=sda
disk=/dev/$hd
drKB=`iostat -x $hd|grep $hd |awk '{print $6}'`
dwKB=`iostat -x $hd|grep $hd |awk '{print $7}'`
dwait=`iostat -x $hd|grep $hd |awk '{print $10}'`
dutil=`iostat -x $hd|grep $hd |awk '{print $14}'`
echo "$drKB,$dwKB,$dwait,$dutil"

niKB=sar -n DEV 1 1| grep eth1|grep Average| awk '{print $5}'
noKB=sar -n DEV 1 1| grep eth1|grep Average| awk '{print $6}'
#noKB=sar -n DEV 1 1| grep eth1|grep Average| awk '{print $1","$2","$3","$4","$5","$6}'

echo "$CPU,$mem,$swap,$drKB,$dwKB,$dwait,$dutil,$niKB,$noKB"

Disk usage
cat /opt/mrtg/df.pl
#!/usr/bin/perl
# output(df -kl) looks like this:
# Filesystem 1k-blocks Used Available Use% Mounted on
# /dev/md0 95645100 30401312 64272080 33% /
# /dev/hde1 14119 1159 12231 9% /boot
#
# In which case, this script returns :
# 95659219
# 30402503
# when run.
foreach $filesystem (`df -kl | grep -v "Filesystem"`)
{
@df = split(/\s+/,$filesystem);
$total += $df[1];
$usage += $df[2];
}
print "$total\n";
print "$usage\n";
hostname
(3) DISK IO # cat /opt/mrtg/diskperf.sh

#!/bin/bash
# This script will monitor the KBread/sec &KBwriten/sec of Disk.
# Creater: CCC IT loren ext:2288 2005/8/3
# As sda ,sdb,sdc,sdd,hda.

# io_header=`iostat -x $disk | grep Device:|awk '{print $5","$6","$10","$14}'`

# disk=sda
hd=sda
disk=/dev/$hd
KBread_sec=`iostat -x $disk|grep $hd |awk '{print $8}'`
KBwrite_sec=`iostat -x $disk|grep $hd |awk '{print $9}'`
echo "$KBread_sec"
echo "$KBwrite_sec"
hostname
(4)MEMORY
cat /opt/mrtg/mem.sh
#!/bin/bash

# mem_header=`free | awk '{print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$12","$13","$14","$15}'`
# mem_header=`free | awk '{print $1","$2","$3}'`

# This script to monitor the mem usage.
totalmem=`/usr/bin/free |grep Mem |awk '{print $2}'`
usedmem=`/usr/bin/free |grep Mem |awk '{print $3}'`
echo "$totalmem"
echo "$usedmem"
(5)SWAP
cat /opt/mrtg/swap.sh
#!/bin/bash
# This script to monitor the swap usage.
totalswap=`/usr/bin/free |grep Swap |awk '{print $2}'`
usedswap=`/usr/bin/free |grep Swap |awk '{print $3}'`
echo "$totalswap"
echo "$usedswap"



#!/bin/bash
# check_xu.sh
# 0 * * * * /home/check_xu.sh

DAT="`date +%Y%m%d`"
HOUR="`date +%H`"
DIR="/home/oslog/host_${DAT}/${HOUR}"
DELAY=60
COUNT=60
# whether the responsible directory exist
if ! test -d ${DIR}
then
    /bin/mkdir -p ${DIR}
fi
# general check
export TERM=linux
/usr/bin/top -b -d ${DELAY} -n ${COUNT} > ${DIR}/top_${DAT}.log 2>&1 &
# cpu check
/usr/bin/sar -u ${DELAY} ${COUNT} > ${DIR}/cpu_${DAT}.log 2>&1 &
#/usr/bin/mpstat -P 0 ${DELAY} ${COUNT} > ${DIR}/cpu_0_${DAT}.log 2>&1 &
#/usr/bin/mpstat -P 1 ${DELAY} ${COUNT} > ${DIR}/cpu_1_${DAT}.log 2>&1 &
# memory check
/usr/bin/vmstat ${DELAY} ${COUNT} > ${DIR}/vmstat_${DAT}.log 2>&1 &
# I/O check
/usr/bin/iostat ${DELAY} ${COUNT} > ${DIR}/iostat_${DAT}.log 2>&1 &
# network check
/usr/bin/sar -n DEV ${DELAY} ${COUNT} > ${DIR}/net_${DAT}.log 2>&1 &
#/usr/bin/sar -n EDEV ${DELAY} ${COUNT} > ${DIR}/net_edev_${DAT}.log 2>&1 &


DATE=`date +%m/%d/%Y`
TIME=`date +%k:%m:%s`
TIMEOUT=`uptime`
VMOUT=`vmstat 1 2`
USERS=`echo $TIMEOUT | gawk '{print $4}'`
LOAD=`echo $TIMEOUT | gawk '{print $9}' | sed "s/,//'`
FREE=`echo $VMOUT | sed -n '/[0-9]/p' | sed -n '2p' | gawk '{print $4}'`
IDLE=`echo  $VMOUT | sed -n '/[0-9]/p' | sed -n '2p' |gawk '{print $15}'`
echo "$DATE,$TIME,$USERS,$LOAD,$FREE,$IDLE"
