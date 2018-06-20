#!/bin/bash
# OS check report csv script
# Author Zhang Yongqi
# Version 1.0 2018-02-25
# Support SLES 11.x

test -f /etc/SuSE-release 
if [ $? -eq 1 ];then
echo -e "This OS NOT SUSE Linux, exit!"
exit
fi

SUSEVERSION="`grep VERSION /etc/SuSE-release | awk '{print $3}'`"
SUSEPATCHLEVEL="`grep PATCHLEVEL /etc/SuSE-release | awk '{print $3}'`"

if [ $SUSEVERSION == 11 ];then
echo -e "Beginning SUSE 11 System Check Report...\n"

printf "%-30s %-40s\n" "Item;" "Results"
printf "%-30s %-40s\n" "Hostname;" "`hostname`"
printf "%-30s %-40s\n" "Production name;" "`/usr/sbin/dmidecode  | grep System -A 5  | egrep Product | awk -F": " '{print $2}'`"
printf "%-30s %-40s\n" "Serail number;" "`/usr/sbin/dmidecode  | grep System -A 5  | egrep Serial | awk -F": " '{print $2}'`"
printf "%-30s %-40s\n" "Operating System;" "SUSE Linux Enterprise Server ${SUSEVERSION}.${SUSEPATCHLEVEL} (x86_64)"  
printf "%-30s %-40s\n" "Kernel;" "`uname -srm`"
printf "%-30s %-40s\n" "Firewall_init_setup;" "`chkconfig SuSEfirewall2_init | awk '{print $2}'`;`chkconfig SuSEfirewall2_setup | awk '{print $2}'`"
printf "%-30s %-40s\n" "Kdump;" "`chkconfig boot.kdump | awk '{print $2}'`"
printf "%-30s %-40s\n" "Memory total/used/free;" "`free -m |grep Mem: | awk '{print $2"MB", $3"MB", $4"MB"}'`"
printf "%-30s %-40s\n" "Swap total/used/free;" "`free -m |grep Swap: | awk '{print $2"MB", $3"MB", $4"MB"}'`"
printf "%-30s %-40s\n" "Uptime;" "`uptime | awk -F"up " '{print $2}' | awk -F, '{print $1}'`"
printf "%-30s %-40s\n" "Load average;" "`uptime | awk -F"average: " '{print $2}'`"
printf "%-30s %-40s\n" "CPU counts;" "`grep processor /proc/cpuinfo | wc -l`"
printf "%-30s %-40s\n" "CPU usage last3 average;" "`top n 3 b | grep 'Cpu(s)' | awk -F, '{print $1, $2, $4}' | awk 'NR==3{print}'`"
printf "%-30s %-40s\n" "Default target;" "`runlevel`"
printf "%-30s %-40s\n" "Max open files;" "`ulimit -n`"
printf "%-30s %-40s\n" "Max user process;" "`ulimit -u`"
printf "%-30s %-40s\n" "RPM counts;" "`rpm -qa|wc -l`"
printf "%-30s %-40s\n" "Process counts;" "`ps -ef|wc -l`"
printf "%-30s %-40s\n" "Dmesg error counts;" "`dmesg | egrep -i "error" | wc -l`"
printf "%-30s %-40s\n" "Dmesg fail counts;" "`dmesg | egrep -i "fail|failed" | wc -l`"
printf "%-30s %-40s\n" "Syslog error counts;" "`egrep -i "error" /var/log/messages | wc -l`"
printf "%-30s %-40s\n" "Syslog fail counts;" "`egrep -i "fail" /var/log/messages | wc -l`"
printf "%-30s %-40s\n" "Syslog segfault counts;" "`egrep -i "segfault" /var/log/messages | wc -l`"
printf "%-30s %-40s\n" "Syslog oops counts;" "`egrep -i "oops" /var/log/messages | wc -l`"
printf "%-30s %-40s\n" "Syslog kernel panic counts;" "`egrep -i "kernel panic" /var/log/messages | wc -l`"
printf "%-30s %-40s\n" "Syslog hardware error counts;" "`egrep -i "hardware error" /var/log/messages | wc -l`"
printf "%-30s %-40s\n" "Syslog bug soft lockup counts;" "`egrep -i "bug: soft lockup" /var/log/messages | wc -l`"
printf "%-30s %-40s\n" "Syslog bug unable handle counts;" "`egrep -i "bug: unable to handle kernel paging " /var/log/messages | wc -l`"
printf "%-30s %-40s\n" "Syslog call trace counts;" "`egrep -i "call trace" /var/log/messages | wc -l`"
printf "%-30s %-40s\n" "Syslog out of memory counts;" "`egrep -i "out of memory" /var/log/messages | wc -l`"
printf "%-30s %-40s\n" "Syslog oom killer counts;" "`egrep -i "oom-killer" /var/log/messages | wc -l`"
printf "%-30s %-40s\n" "Filesystem Used than 80%;" "`df -Th | egrep -v "tmpfs|iso" | sed -n '2,$'p | awk 'NF==1{t=$1;getline;$1=t " " $1}1' | gawk '{if ($6>=80) print}' | tr "\n" " "`"

elif [ $SUSEVERSION == 12 ];then
/bin/sh sles12-system-check-report-csv.sh 
fi
