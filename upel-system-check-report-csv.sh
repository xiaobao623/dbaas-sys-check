#!/bin/bash
# OS check report csv script
# Author Zhang Yongqi
# Version 1.0 2018-02-25
# Support UPEL 1.x CentOS 7.x RHEL 7.x

test -f /etc/centos-release 
if [ $? -eq 1 ];then
echo -e "This OS NOT CentOS Linux, exit!"
exit
fi

CENTOSVERSION="`cat /etc/centos-release | awk '{print $4}' | awk -F. '{print $1}'`"

if [ $CENTOSVERSION == 7 ];then
echo -e "Beginning CentOS 7 System Check Report...\n"

printf "%-30s %-40s\n" "Item;" "Results"
printf "%-30s %-40s\n" "Hostname;" "`hostname`"
printf "%-30s %-40s\n" "Icon name;" "`hostnamectl |grep "Icon name" | awk -F": " '{print $2}'`"
printf "%-30s %-40s\n" "Chassis;" "`hostnamectl |grep "Chassis" | awk -F": " '{print $2}'`"
printf "%-30s %-40s\n" "Virtualization;" "`hostnamectl |grep "Virtualization" | awk -F": " '{print $2}'`"
printf "%-30s %-40s\n" "Operating System;" "`hostnamectl |grep "Operating System" | awk -F": " '{print $2}'`"
printf "%-30s %-40s\n" "Kernel;" "`hostnamectl |grep "Kernel" | awk -F": " '{print $2}'`"
printf "%-30s %-40s\n" "SELinux;" "`getenforce`"
printf "%-30s %-40s\n" "Firewall;" "`systemctl is-enabled firewalld`"
printf "%-30s %-40s\n" "Kdump;" "`systemctl is-enabled kdump`"
printf "%-30s %-40s\n" "Memory total/used/free;" "`free -m |grep Mem: | awk '{print $2"MB", $3"MB", $4"MB"}'`"
printf "%-30s %-40s\n" "Swap total/used/free;" "`free -m |grep Swap: | awk '{print $2"MB", $3"MB", $4"MB"}'`"
printf "%-30s %-40s\n" "Uptime;" "`uptime | awk -F"up " '{print $2}' | awk -F, '{print $1}'`"
printf "%-30s %-40s\n" "Load average;" "`uptime | awk -F"average: " '{print $2}'`"
printf "%-30s %-40s\n" "CPU counts;" "`grep processor /proc/cpuinfo | wc -l`"
printf "%-30s %-40s\n" "CPU usage last3 average;" "`top n 3 b | grep 'Cpu(s)' | awk -F, '{print $1, $2, $4}' | awk 'NR==3{print}'`"
printf "%-30s %-40s\n" "Default target;" "`systemctl get-default`"
printf "%-30s %-40s\n" "Max open files;" "`ulimit -n`"
printf "%-30s %-40s\n" "Max user process;" "`ulimit -u`"
printf "%-30s %-40s\n" "RPM counts;" "`rpm -qa|wc -l`"
printf "%-30s %-40s\n" "Process counts;" "`ps -ef|wc -l`"
printf "%-30s %-40s\n" "Journal disk-usage;" "`journalctl --disk-usage | awk '{print $7}'`"
printf "%-30s %-40s\n" "Dmesg error counts;" "`journalctl -k | egrep -i "error" | wc -l`"
printf "%-30s %-40s\n" "Dmesg fail counts;" "`journalctl -k | egrep -i "fail|failed" | wc -l`"
printf "%-30s %-40s\n" "Syslog error counts;" "`journalctl -n500 | egrep -i "error" | wc -l`"
printf "%-30s %-40s\n" "Syslog fail counts;" "`journalctl -n500 | egrep -i "fail|failed" | wc -l`"
printf "%-30s %-40s\n" "Syslog segfault counts;" "`journalctl -n500 | egrep -i "segfault at" | wc -l`"
printf "%-30s %-40s\n" "Syslog oops counts;" "`journalctl -n500 | egrep -i "oops:" | wc -l`"
printf "%-30s %-40s\n" "Syslog kernel panic counts;" "`journalctl -n500 | egrep -i "kernel panic" | wc -l`"
printf "%-30s %-40s\n" "Syslog hardware error counts;" "`journalctl -n500 | egrep -i "hardware error" | wc -l`"
printf "%-30s %-40s\n" "Syslog bug soft lockup counts;" "`journalctl -n500 | egrep -i "bug: soft lockup" | wc -l`"
printf "%-30s %-40s\n" "Syslog bug unable handle counts;" "`journalctl -n500 | egrep -i "bug: unable to handle kernel paging" | wc -l`"
printf "%-30s %-40s\n" "Syslog call trace counts;" "`journalctl -n500 | egrep -i "call trace" | wc -l`"
printf "%-30s %-40s\n" "Syslog out of memory counts;" "`journalctl -n500 | egrep -i "out of memory" | wc -l`"
printf "%-30s %-40s\n" "Syslog oom killer counts;" "`journalctl -n500 | egrep -i "oom_killer" | wc -l`"
printf "%-30s %-40s\n" "Filesystem Used than 80%;" "`df -Th | egrep -v "tmpfs|iso" | sed -n '2,$'p | awk 'NF==1{t=$1;getline;$1=t " " $1}1' | gawk '{if ($6>=80) print}' | tr "\n" " "`"
fi
