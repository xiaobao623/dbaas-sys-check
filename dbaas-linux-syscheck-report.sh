#!/bin/bash
# OS check report csv script
# Author Zhang Yongqi
# Version 1.0 2018-04-27
# Support UPEL 1.0, SLES 11.x, SLES 12.x


sles11_system_check_report_csv() {
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
}

sles12_system_check_report_csv() {
printf "%-30s %-40s\n" "Item;" "Results"
printf "%-30s %-40s\n" "Hostname;" "`hostname`"
printf "%-30s %-40s\n" "Icon name;" "`hostnamectl |grep "Icon name" | awk -F": " '{print $2}'`"
printf "%-30s %-40s\n" "Chassis;" "`hostnamectl |grep "Chassis" | awk -F": " '{print $2}'`"
printf "%-30s %-40s\n" "Virtualization;" "`hostnamectl |grep "Virtualization" | awk -F": " '{print $2}'`"
printf "%-30s %-40s\n" "Operating System;" "`hostnamectl |grep "Operating System" | awk -F": " '{print $2}'`"
printf "%-30s %-40s\n" "Kernel;" "`hostnamectl |grep "Kernel" | awk -F": " '{print $2}'`"
printf "%-30s %-40s\n" "Firewall;" "`systemctl is-enabled SuSEfirewall2`"
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
}

upel_system_check_report_csv() {
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
}

test -f /etc/SuSE-release 
if [ $? -eq 0 ];then 
  SUSEVERSION="`grep VERSION /etc/SuSE-release | awk '{print $3}'`"
  SUSEPATCHLEVEL="`grep PATCHLEVEL /etc/SuSE-release | awk '{print $3}'`"

  if [ $SUSEVERSION == 12 ];then
    echo -e "Beginning SUSE 12 System Check...\n"
    sles12_system_check_report_csv
  elif [ $SUSEVERSION == 11 ];then
    echo -e "Beginning SUSE 11 System Check...\n"
    sles11_system_check_report_csv
  fi
exit
fi

test -f /etc/upel-release
if [ $? -eq 0 ];then
  UPELVERSION="`cat /etc/upel-release | awk '{print $4}' | awk -F. '{print $1}'`"

  if [ ${UPELVERSION} == 1 ];then
    echo -e "Beginning UPEL 1  System Check...\n"
    upel_system_check_report_csv
  fi
exit
fi

test -f /etc/centos-release 
if [ $? -eq 0 ];then
  CENTOSVERSION="`cat /etc/centos-release | awk '{print $4}' | awk -F. '{print $1}'`"

  if [ ${CENTOSVERSION} == 7 ];then
    echo -e "Beginning CentOS 7 System Check...\n"
    upel_system_check_report_csv
  fi
exit
fi

echo "WARN: This OS none SUSE-12, UPEL-1 and CentOS-7 Linux, exit!"
