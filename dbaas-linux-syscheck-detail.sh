#!/bin/bash
# OS check and report script
# Author Zhang Yongqi
# Version 1.0 2018-06-20
# Support UPEL 1.0, SLES 11.x, SLES 12.x

sles11_system_check_detail_csv() {
printf "%-30s %-40s\n" "Item;" "Results" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Hostname;" "`hostname`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Production name;" "`/usr/sbin/dmidecode  | grep System -A 5  | egrep Product | awk -F": " '{print $2}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Serail number;" "`/usr/sbin/dmidecode  | grep System -A 5  | egrep Serial | awk -F": " '{print $2}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Operating System;" "SUSE Linux Enterprise Server ${SUSEVERSION}.${SUSEPATCHLEVEL} (x86_64)" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Kernel;" "`uname -srm`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Firewall_init;" "`chkconfig SuSEfirewall2_init | awk '{print $2}'`;`chkconfig SuSEfirewall2_setup | awk '{print $2}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Kdump;" "`chkconfig boot.kdump | awk '{print $2}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Memory total/used/free;" "`free -m |grep Mem: | awk '{print $2"MB", $3"MB", $4"MB"}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Swap total/used/free;" "`free -m |grep Swap: | awk '{print $2"MB", $3"MB", $4"MB"}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Uptime;" "`uptime | awk -F"up " '{print $2}' | awk -F, '{print $1}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Load average;" "`uptime | awk -F"average: " '{print $2}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "CPU counts;" "`grep processor /proc/cpuinfo | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "CPU usage last3 average;" "`top n 3 b | grep 'Cpu(s)' | awk -F, '{print $1, $2, $4}' | awk 'NR==3{print}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Runlevl;" "`runlevel`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Max open files;" "`ulimit -n`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Max user process;" "`ulimit -u`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "RPM counts;" "`rpm -qa|wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Process counts;" "`ps -ef|wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Dmesg error counts;" "`dmesg | egrep -i "error" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Dmesg fail counts;" "`dmesg | egrep -i "fail|failed" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog error counts;" "`egrep -i "error" /var/log/messages | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog fail counts;" "`egrep -i "fail" /var/log/messages | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog segfault counts;" "`egrep -i "segfault" /var/log/messages | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog oops counts;" "`egrep -i "oops" /var/log/messages | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog kernel panic counts;" "`egrep -i "kernel panic" /var/log/messages | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog hardware error counts;" "`egrep -i "hardware error" /var/log/messages | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog bug soft lockup counts;" "`egrep -i "bug: soft lockup" /var/log/messages | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog bug unable handle counts;" "`egrep -i "bug: unable to handle kernel paging " /var/log/messages | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog call trace counts;" "`egrep -i "call trace" /var/log/messages | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog out of memory counts;" "`egrep -i "out of memory" /var/log/messages | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog oom killer counts;" "`egrep -i "oom-killer" /var/log/messages | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Filesystem Used than 80%;" "`df -Th | egrep -v "tmpfs|iso" | sed -n '2,$'p | awk 'NF==1{t=$1;getline;$1=t " " $1}1' | gawk '{if ($6>=80) print}' | tr "\n" " "`" >>$CHECK_RESULT

# Check Dmesg error and fault
echo -e "\n==== Check error in Dmesg ====\n" >>$CHECK_RESULT
dmesg | egrep -i "error" >>$CHECK_RESULT
echo -e "\n==== Check fail in Dmesg ====\n" >>$CHECK_RESULT
dmesg | egrep -i "fail|failed" >>$CHECK_RESULT
echo -e "\n==== Check warn in Dmesg ====\n" >>$CHECK_RESULT
dmesg | egrep -i "warn" >>$CHECK_RESULT

# Check Journal latest ${LINES} lines error and fault
echo -e "\n==== Check error in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
tail -n${LINES} /var/log/messages | egrep -i "error" >>$CHECK_RESULT
echo -e "\n==== Check fail in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
tail -n${LINES} /var/log/messages | egrep -i "fail|failed" >>$CHECK_RESULT
echo -e "\n==== Check segfault in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
tail -n${LINES} /var/log/messages | egrep -i "segfault at" >>$CHECK_RESULT
echo -e "\n==== Check oops in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
tail -n${LINES} /var/log/messages | egrep -i "oops:" >>$CHECK_RESULT
echo -e "\n==== Check kernel panic in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
tail -n${LINES} /var/log/messages | egrep -i "kernel panic" >>$CHECK_RESULT
echo -e "\n==== Check hardware error in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
tail -n${LINES} /var/log/messages | egrep -i "hardware error" >>$CHECK_RESULT
echo -e "\n==== Check bug: soft lockup in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
tail -n${LINES} /var/log/messages | egrep -i "bug: soft lockup" >>$CHECK_RESULT
echo -e "\n==== Check bug: unable to handle kernel paging in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
tail -n${LINES} /var/log/messages | egrep -i "bug: unable to handle kernel paging" >>$CHECK_RESULT
echo -e "\n==== Check call trace in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
tail -n${LINES} /var/log/messages | egrep -i "call trace" >>$CHECK_RESULT
echo -e "\n==== Check out of memory in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
tail -n${LINES} /var/log/messages | egrep -i "out of memory" >>$CHECK_RESULT
echo -e "\n==== Check oom_killer in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
tail -n${LINES} /var/log/messages | egrep -i "oom_killer" >>$CHECK_RESULT
echo -e "\n==== Check warn in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
tail -n${LINES} /var/log/messages | egrep -i "warn" >>$CHECK_RESULT

echo -e "\n==========================================================\n" >>$CHECK_RESULT
echo -e "[System Health Check Detail]" >>$CHECK_RESULT

# Check OS version
echo -e "\n==== OS version ====\n" >>$CHECK_RESULT
cat /etc/SuSE-release >>$CHECK_RESULT

#Check IP
echo -e "\n==== IP addresses ====\n" >>$CHECK_RESULT
#ip a >>$CHECK_RESULT

# Check OS uptime
echo -e "\n==== Uptime ====\n" >>$CHECK_RESULT
uptime >>$CHECK_RESULT

# Check CPU
echo -e "\n==== CPU counts ====\n" >>$CHECK_RESULT
echo -e "`grep processor /proc/cpuinfo`"  >>$CHECK_RESULT

# Check CPU usage
echo -e "\n==== CPU usage ====\n" >>$CHECK_RESULT
echo -e "`top n 3 b | grep 'Cpu(s)'`" >>$CHECK_RESULT

# Check OS performance
echo -e "\n==== Top 10 CPU Usage ====\n"  >>$CHECK_RESULT
#ps auxw|head -1;ps auxw|sort -rn -k3|head -10
ps auxw|head -1 >>$CHECK_RESULT
ps auxw|sort -rn -k3|head -10|grep -v "^USER"  >>$CHECK_RESULT

echo -e "\n==== Top 10 Real Memory Usage ====\n"  >>$CHECK_RESULT
#ps auxw|head -1;ps auxw|sort -rn -k4|head -10
ps auxw|head -1 >>$CHECK_RESULT
ps auxw|sort -rn -k4|head -10  >>$CHECK_RESULT

echo -e "\n==== Top 10 Virtual Memeory Usage ====\n"  >>$CHECK_RESULT
#ps auxw|head -1;ps auxw|sort -rn -k5|head -10
ps auxw|head -1 >>$CHECK_RESULT
ps auxw|sort -rn -k5|head -10  >>$CHECK_RESULT

# Check CPU stat
echo -e "\n==== CPU stat ====\n" >>$CHECK_RESULT
test -f /usr/bin/iostat && iostat -c  >>$CHECK_RESULT

# Check iostat
echo -e "\n==== IO stat ====\n" >>$CHECK_RESULT
test -f /usr/bin/iostat && iostat 5 3  >>$CHECK_RESULT

# Check vmstat
echo -e "\n==== VM stat ====\n" >>$CHECK_RESULT
test -f /usr/bin/vmstat && vmstat 5 3  >>$CHECK_RESULT

# Check mpstat
echo -e "\n==== MP stat ====\n" >>$CHECK_RESULT
test -f /usr/bin/mpstat && mpstat 5 3  >>$CHECK_RESULT

# Check pidstat
echo -e "\n==== PID stat ====\n" >>$CHECK_RESULT
test -f /usr/bin/pidstat && pidstat  >>$CHECK_RESULT

# Check RPM counts
echo -e "\n==== RPM counts ====\n" >>$CHECK_RESULT
rpm -qa | wc -l >>$CHECK_RESULT

# Check Default target
echo -e "\n==== RPM counts ====\n" >>$CHECK_RESULT
runlevel >>$CHECK_RESULT

# Check Filesystem
echo -e "\n==== Filesystem ====\n" >>$CHECK_RESULT
df -Th >>$CHECK_RESULT

echo -e "\n==== Filesystem inode ====\n" >>$CHECK_RESULT
df -ih >>$CHECK_RESULT

# Check Memory
echo -e "\n==== Memory ====\n" >>$CHECK_RESULT
free -m >>$CHECK_RESULT

# Check Zombies
echo -e "\n==== Zombies ====\n" >>$CHECK_RESULT
ps -ef|grep defunct | grep -v grep >>$CHECK_RESULT

# Check Firewall
echo -e "\n==== Firewall ====\n" >>$CHECK_RESULT
chkconfig SuSEfirewall2_init >>$CHECK_RESULT
chkconfig SuSEfirewall2_setup >>$CHECK_RESULT

# Check Kdump
echo -e "\n==== Kdump ====\n" >>$CHECK_RESULT
chkconfig boot.kdump >>$CHECK_RESULT

# Check Services
echo -e "\n==== Service ====\n" >>$CHECK_RESULT
chkconfig --list --all >>$CHECK_RESULT

# Check Ulimits
echo -e "\n==== ulimits.conf ====\n" >>$CHECK_RESULT
egrep -v "#|^$" /etc/security/limits.conf >>$CHECK_RESULT
echo -e "\n==== ulimits.d/*.conf ====\n" >>$CHECK_RESULT
test  -d "/etc/security/limits.d/" && ls /etc/security/limits.d/*.conf >>$CHECK_RESULT
test  -d "/etc/security/limits.d/" && grep -v "#" /etc/security/limits.d/*.conf >>$CHECK_RESULT
echo -e "\n==== Ulimits ====\n" >>$CHECK_RESULT
ulimit -a >>$CHECK_RESULT

# Check Processes
echo -e "\n==== Processes ====\n" >>$CHECK_RESULT
ps -e f |egrep -v '\[' >>$CHECK_RESULT

# Check Top
echo -e "\n==== Top ====\n" >>$CHECK_RESULT
top n 1 b >>$CHECK_RESULT

# Check RPM list
echo -e "\n==== RPM list ====\n" >>$CHECK_RESULT
rpm -qa | sort >>$CHECK_RESULT

# Check Dmesg
echo -e "\n==== Dmesg ====\n" >>$CHECK_RESULT
dmesg >>$CHECK_RESULT

# Check Journal latest ${LINES} lines
echo -e "\n==== Check latest ${LINES} lines message ====\n" >>$CHECK_RESULT
tail -n${LINES} /var/log/messages >>$CHECK_RESULT

# Check finished
echo -e "\n==== OS Check finished ====\n" >>$CHECK_RESULT

cd $REPORT_DIR/ && tar zcf `hostname`-$REPORT_TYPE-$DATE.tgz $REPORT_TYPE/

echo -e "System check report file:
    $REPORT_DIR/`hostname`-$REPORT_TYPE-$DATE.tgz
Please download and send this file to BSG support team."
}

sles12_system_check_detail_csv() {
printf "%-30s %-40s\n" "Item;" "Results" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Hostname;" "`hostname`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Icon name;" "`hostnamectl |grep "Icon name" | awk -F": " '{print $2}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Chassis;" "`hostnamectl |grep "Chassis" | awk -F": " '{print $2}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Virtualization;" "`hostnamectl |grep "Virtualization" | awk -F": " '{print $2}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Operating System;" "`hostnamectl |grep "Operating System" | awk -F": " '{print $2}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Kernel;" "`hostnamectl |grep "Kernel" | awk -F": " '{print $2}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Firewall;" "`systemctl is-enabled SuSEfirewall2`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Kdump;" "`systemctl is-enabled kdump`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Memory total/used/free;" "`free -m |grep Mem: | awk '{print $2"MB", $3"MB", $4"MB"}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Swap total/used/free;" "`free -m |grep Swap: | awk '{print $2"MB", $3"MB", $4"MB"}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Uptime;" "`uptime | awk -F"up " '{print $2}' | awk -F, '{print $1}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Load average;" "`uptime | awk -F"average: " '{print $2}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "CPU counts;" "`grep processor /proc/cpuinfo | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "CPU usage last3 average;" "`top n 3 b | grep 'Cpu(s)' | awk -F, '{print $1, $2, $4}' | awk 'NR==3{print}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Default target;" "`systemctl get-default`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Max open files;" "`ulimit -n`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Max user process;" "`ulimit -u`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "RPM counts;" "`rpm -qa|wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Process counts;" "`ps -ef|wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Journal disk-usage;" "`journalctl --disk-usage | awk '{print $7}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Dmesg error counts;" "`journalctl -k | egrep -i "error" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Dmesg fail counts;" "`journalctl -k | egrep -i "fail|failed" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog error counts;" "`journalctl -n${LINES} | egrep -i "error" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog fail counts;" "`journalctl -n${LINES} | egrep -i "fail|failed" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog segfault counts;" "`journalctl -n${LINES} | egrep -i "segfault at" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog oops counts;" "`journalctl -n${LINES} | egrep -i "oops:" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog kernel panic counts;" "`journalctl -n${LINES} | egrep -i "kernel panic" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog hardware error counts;" "`journalctl -n${LINES} | egrep -i "hardware error" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog bug soft lockup counts;" "`journalctl -n${LINES} | egrep -i "bug: soft lockup" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog bug unable handle counts;" "`journalctl -n${LINES} | egrep -i "bug: unable to handle kernel paging" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog call trace counts;" "`journalctl -n${LINES} | egrep -i "call trace" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog out of memory counts;" "`journalctl -n${LINES} | egrep -i "out of memory" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog oom killer counts;" "`journalctl -n${LINES} | egrep -i "oom_killer" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Filesystem Used than 80%;" "`df -Th | egrep -v "tmpfs|iso" | sed -n '2,$'p | awk 'NF==1{t=$1;getline;$1=t " " $1}1' | gawk '{if ($6>=80) print}' | tr "\n" " "`" >>$CHECK_RESULT

# Check Dmesg error and fault
echo -e "\n==== Check error in Dmesg ====\n" >>$CHECK_RESULT
journalctl -k | egrep -i "error" >>$CHECK_RESULT
echo -e "\n==== Check fail in Dmesg ====\n" >>$CHECK_RESULT
journalctl -k | egrep -i "fail|failed" >>$CHECK_RESULT
echo -e "\n==== Check warn in Dmesg ====\n" >>$CHECK_RESULT
journalctl -k | egrep -i "warn" >>$CHECK_RESULT

# Check Journal latest ${LINES} lines error and fault
echo -e "\n==== Check error in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "error" >>$CHECK_RESULT
echo -e "\n==== Check fail in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "fail|failed" >>$CHECK_RESULT
echo -e "\n==== Check segfault in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "segfault at" >>$CHECK_RESULT
echo -e "\n==== Check oops in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "oops:" >>$CHECK_RESULT
echo -e "\n==== Check kernel panic in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "kernel panic" >>$CHECK_RESULT
echo -e "\n==== Check hardware error in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "hardware error" >>$CHECK_RESULT
echo -e "\n==== Check bug: soft lockup in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "bug: soft lockup" >>$CHECK_RESULT
echo -e "\n==== Check bug: unable to handle kernel paging in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "bug: unable to handle kernel paging" >>$CHECK_RESULT
echo -e "\n==== Check call trace in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "call trace" >>$CHECK_RESULT
echo -e "\n==== Check out of memory in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "out of memory" >>$CHECK_RESULT
echo -e "\n==== Check oom_killer in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "oom_killer" >>$CHECK_RESULT
echo -e "\n==== Check warn in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "warn" >>$CHECK_RESULT

echo -e "\n==========================================================\n" >>$CHECK_RESULT
echo -e "[System Health Check Detail]" >>$CHECK_RESULT

# Check hostnamectl
echo -e "\n==== Hostnamectl ====\n" >>$CHECK_RESULT
hostnamectl >>$CHECK_RESULT

# Check OS version
echo -e "\n==== OS version ====\n" >>$CHECK_RESULT
cat /etc/SuSE-release >>$CHECK_RESULT

#Check IP
echo -e "\n==== IP addresses ====\n" >>$CHECK_RESULT
#ip a >>$CHECK_RESULT

# Check OS uptime
echo -e "\n==== Uptime ====\n" >>$CHECK_RESULT
uptime >>$CHECK_RESULT

# Check CPU
echo -e "\n==== CPU counts ====\n" >>$CHECK_RESULT
echo -e "`grep processor /proc/cpuinfo`"  >>$CHECK_RESULT

# Check CPU usage
echo -e "\n==== CPU usage ====\n" >>$CHECK_RESULT
echo -e "`top n 3 b | grep 'Cpu(s)'`" >>$CHECK_RESULT

# Check OS performance
echo -e "\n==== Top 10 CPU Usage ====\n"  >>$CHECK_RESULT
#ps auxw|head -1;ps auxw|sort -rn -k3|head -10
ps auxw|head -1 >>$CHECK_RESULT
ps auxw|sort -rn -k3|head -10|grep -v "^USER"  >>$CHECK_RESULT

echo -e "\n==== Top 10 Real Memory Usage ====\n"  >>$CHECK_RESULT
#ps auxw|head -1;ps auxw|sort -rn -k4|head -10
ps auxw|head -1 >>$CHECK_RESULT
ps auxw|sort -rn -k4|head -10  >>$CHECK_RESULT

echo -e "\n==== Top 10 Virtual Memeory Usage ====\n"  >>$CHECK_RESULT
#ps auxw|head -1;ps auxw|sort -rn -k5|head -10
ps auxw|head -1 >>$CHECK_RESULT
ps auxw|sort -rn -k5|head -10  >>$CHECK_RESULT

# Check CPU stat
echo -e "\n==== CPU stat ====\n" >>$CHECK_RESULT
test -f /usr/bin/iostat && iostat -c  >>$CHECK_RESULT

# Check iostat
echo -e "\n==== IO stat ====\n" >>$CHECK_RESULT
test -f /usr/bin/iostat && iostat 5 3  >>$CHECK_RESULT

# Check vmstat
echo -e "\n==== VM stat ====\n" >>$CHECK_RESULT
test -f /usr/bin/vmstat && vmstat 5 3  >>$CHECK_RESULT

# Check mpstat
echo -e "\n==== MP stat ====\n" >>$CHECK_RESULT
test -f /usr/bin/mpstat && mpstat 5 3  >>$CHECK_RESULT

# Check pidstat
echo -e "\n==== PID stat ====\n" >>$CHECK_RESULT
test -f /usr/bin/pidstat && pidstat  >>$CHECK_RESULT

# Check RPM counts
echo -e "\n==== RPM counts ====\n" >>$CHECK_RESULT
rpm -qa | wc -l >>$CHECK_RESULT

# Check Default target
echo -e "\n==== RPM counts ====\n" >>$CHECK_RESULT
systemctl get-default >>$CHECK_RESULT

# Check Filesystem
echo -e "\n==== Filesystem ====\n" >>$CHECK_RESULT
df -Th >>$CHECK_RESULT

echo -e "\n==== Filesystem inode ====\n" >>$CHECK_RESULT
df -ih >>$CHECK_RESULT

# Check Memory
echo -e "\n==== Memory ====\n" >>$CHECK_RESULT
free -m >>$CHECK_RESULT

# Check Zombies
echo -e "\n==== Zombies ====\n" >>$CHECK_RESULT
ps -ef|grep defunct | grep -v grep >>$CHECK_RESULT

# Check Firewall
echo -e "\n==== Firewall ====\n" >>$CHECK_RESULT
systemctl status SuSEfirewall2 >>$CHECK_RESULT

# Check Kdump
echo -e "\n==== Kdump ====\n" >>$CHECK_RESULT
systemctl status kdump >>$CHECK_RESULT

# Check Services
echo -e "\n==== Service ====\n" >>$CHECK_RESULT
systemctl list-units --type service >>$CHECK_RESULT

# Check Ulimits
echo -e "\n==== ulimits.conf ====\n" >>$CHECK_RESULT
egrep -v "#|^$" /etc/security/limits.conf >>$CHECK_RESULT
echo -e "\n==== ulimits.d/*.conf ====\n" >>$CHECK_RESULT
test  -d "/etc/security/limits.d/" && ls /etc/security/limits.d/*.conf >>$CHECK_RESULT
test  -d "/etc/security/limits.d/" && grep -v "#" /etc/security/limits.d/*.conf >>$CHECK_RESULT
echo -e "\n==== Ulimits ====\n" >>$CHECK_RESULT
ulimit -a >>$CHECK_RESULT

# Check Processes
echo -e "\n==== Processes ====\n" >>$CHECK_RESULT
ps -e f |egrep -v '\[' >>$CHECK_RESULT

# Check Journal disk-usage
echo -e "\n==== Journal disk-usage ====\n" >>$CHECK_RESULT
journalctl --disk-usage >>$CHECK_RESULT

# Check Top
echo -e "\n==== Top ====\n" >>$CHECK_RESULT
top n 1 b >>$CHECK_RESULT

# Check RPM list
echo -e "\n==== RPM list ====\n" >>$CHECK_RESULT
rpm -qa | sort >>$CHECK_RESULT

# Check Dmesg
echo -e "\n==== Dmesg ====\n" >>$CHECK_RESULT
dmesg >>$CHECK_RESULT

# Check Journal latest ${LINES} lines
echo -e "\n==== Check latest ${LINES} lines message ====\n" >>$CHECK_RESULT
tail -n${LINES} /var/log/messages >>$CHECK_RESULT

# Check finished
echo -e "\n==== OS Check finished ====\n" >>$CHECK_RESULT

cd $REPORT_DIR/ && tar zcf `hostname`-$REPORT_TYPE-$DATE.tgz $REPORT_TYPE/

echo -e "System check report file:
    $REPORT_DIR/`hostname`-$REPORT_TYPE-$DATE.tgz
Please download and send this file to BSG support team."
}

upel_system_check_detail_csv() {
printf "%-30s %-40s\n" "Item;" "Results" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Hostname;" "`hostname`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Icon name;" "`hostnamectl |grep "Icon name" | awk -F": " '{print $2}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Chassis;" "`hostnamectl |grep "Chassis" | awk -F": " '{print $2}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Virtualization;" "`hostnamectl |grep "Virtualization" | awk -F": " '{print $2}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Operating System;" "`hostnamectl |grep "Operating System" | awk -F": " '{print $2}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Kernel;" "`hostnamectl |grep "Kernel" | awk -F": " '{print $2}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "SELinux;" "`getenforce`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Firewall;" "`systemctl is-enabled firewalld`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Kdump;" "`systemctl is-enabled kdump`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Memory total/used/free;" "`free -m |grep Mem: | awk '{print $2"MB", $3"MB", $4"MB"}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Swap total/used/free;" "`free -m |grep Swap: | awk '{print $2"MB", $3"MB", $4"MB"}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Uptime;" "`uptime | awk -F"up " '{print $2}' | awk -F, '{print $1}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Load average;" "`uptime | awk -F"average: " '{print $2}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "CPU counts;" "`grep processor /proc/cpuinfo | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "CPU usage last 3 average;" "`top n 3 b | grep 'Cpu(s)' | awk -F, '{print $1, $2, $4}' | awk 'NR==3{print}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Default target;" "`systemctl get-default`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Max open files;" "`ulimit -n`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Max user process;" "`ulimit -u`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "RPM counts;" "`rpm -qa|wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Process counts;" "`ps -ef|wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Journal disk-usage;" "`journalctl --disk-usage | awk '{print $7}'`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Dmesg error counts;" "`journalctl -k | egrep -i "error" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Dmesg fail counts;" "`journalctl -k | egrep -i "fail" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog error counts;" "`journalctl -n${LINES} | egrep -i "error" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog fail counts;" "`journalctl -n${LINES} | egrep -i "fail|failed" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog segfault counts;" "`journalctl -n${LINES} | egrep -i "segfault at" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog oops counts;" "`journalctl -n${LINES} | egrep -i "oops:" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog kernel panic counts;" "`journalctl -n${LINES} | egrep -i "kernel panic" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog hardware error counts;" "`journalctl -n${LINES} | egrep -i "hardware error" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog bug soft lockup counts;" "`journalctl -n${LINES} | egrep -i "bug: soft lockup" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog bug unable handle counts;" "`journalctl -n${LINES} | egrep -i "bug: unable to handle kernel paging" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog call trace counts;" "`journalctl -n${LINES} | egrep -i "call trace" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog out of memory counts;" "`journalctl -n${LINES} | egrep -i "out of memory" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Syslog oom killer counts;" "`journalctl -n${LINES} | egrep -i "oom_killer" | wc -l`" >>$CHECK_RESULT
printf "%-30s %-40s\n" "Filesystem Used than 80%;" "`df -Th | egrep -v "tmpfs|iso" | sed -n '2,$'p | awk 'NF==1{t=$1;getline;$1=t " " $1}1' | gawk '{if ($6>=80) print}' | tr "\n" " "`" >>$CHECK_RESULT

# Check Dmesg error and fault
echo -e "\n==== Check error in Dmesg ====\n" >>$CHECK_RESULT
journalctl -k | egrep -i "error" >>$CHECK_RESULT
echo -e "\n==== Check fail in Dmesg ====\n" >>$CHECK_RESULT
journalctl -k | egrep -i "fail|failed" >>$CHECK_RESULT
echo -e "\n==== Check warn in Dmesg ====\n" >>$CHECK_RESULT
journalctl -k | egrep -i "warn" >>$CHECK_RESULT

# Check Journal latest ${LINES} lines error and fault
echo -e "\n==== Check error in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "error" >>$CHECK_RESULT
echo -e "\n==== Check fail in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "fail|failed" >>$CHECK_RESULT
echo -e "\n==== Check segfault in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "segfault at" >>$CHECK_RESULT
echo -e "\n==== Check oops in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "oops:" >>$CHECK_RESULT
echo -e "\n==== Check kernel panic in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "kernel panic" >>$CHECK_RESULT
echo -e "\n==== Check hardware error in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "hardware error" >>$CHECK_RESULT
echo -e "\n==== Check bug: soft lockup in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "bug: soft lockup" >>$CHECK_RESULT
echo -e "\n==== Check bug: unable to handle kernel paging in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "bug: unable to handle kernel paging" >>$CHECK_RESULT
echo -e "\n==== Check call trace in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "call trace" >>$CHECK_RESULT
echo -e "\n==== Check out of memory in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "out of memory" >>$CHECK_RESULT
echo -e "\n==== Check oom_killer in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "oom_killer" >>$CHECK_RESULT
echo -e "\n==== Check warn in latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} | egrep -i "warn" >>$CHECK_RESULT

echo -e "\n==========================================================\n" >>$CHECK_RESULT
echo -e "[System Health Check Detail]" >>$CHECK_RESULT

# Check hostnamectl
echo -e "\n==== Hostnamectl ====\n" >>$CHECK_RESULT
hostnamectl >>$CHECK_RESULT

# Check OS version
echo -e "\n==== OS version ====\n" >>$CHECK_RESULT
cat /etc/redhat-release >>$CHECK_RESULT

#Check IP
echo -e "\n==== IP addresses ====\n" >>$CHECK_RESULT
#ip a >>$CHECK_RESULT

# Check OS uptime
echo -e "\n==== Uptime ====\n" >>$CHECK_RESULT
uptime >>$CHECK_RESULT

# Check CPU
echo -e "\n==== CPU counts ====\n" >>$CHECK_RESULT
echo -e "`grep processor /proc/cpuinfo`"  >>$CHECK_RESULT

# Check CPU usage
echo -e "\n==== CPU usage ====\n" >>$CHECK_RESULT
echo -e "`top n 3 b | grep 'Cpu(s)'`" >>$CHECK_RESULT

# Check OS performance
echo -e "\n==== Top 10 CPU Usage ====\n"  >>$CHECK_RESULT
#ps auxw|head -1;ps auxw|sort -rn -k3|head -10
ps auxw|head -1 >>$CHECK_RESULT
ps auxw|sort -rn -k3|head -10|grep -v "^USER"  >>$CHECK_RESULT

echo -e "\n==== Top 10 Real Memory Usage ====\n"  >>$CHECK_RESULT
#ps auxw|head -1;ps auxw|sort -rn -k4|head -10
ps auxw|head -1 >>$CHECK_RESULT
ps auxw|sort -rn -k4|head -10  >>$CHECK_RESULT

echo -e "\n==== Top 10 Virtual Memeory Usage ====\n"  >>$CHECK_RESULT
#ps auxw|head -1;ps auxw|sort -rn -k5|head -10
ps auxw|head -1 >>$CHECK_RESULT
ps auxw|sort -rn -k5|head -10  >>$CHECK_RESULT

# Check CPU stat
echo -e "\n==== CPU stat ====\n" >>$CHECK_RESULT
test -f /usr/bin/iostat && iostat -c  >>$CHECK_RESULT

# Check iostat
echo -e "\n==== IO stat ====\n" >>$CHECK_RESULT
test -f /usr/bin/iostat && iostat 5 3  >>$CHECK_RESULT

# Check vmstat
echo -e "\n==== VM stat ====\n" >>$CHECK_RESULT
test -f /usr/bin/vmstat && vmstat 5 3  >>$CHECK_RESULT

# Check mpstat
echo -e "\n==== MP stat ====\n" >>$CHECK_RESULT
test -f /usr/bin/mpstat && mpstat 5 3  >>$CHECK_RESULT

# Check pidstat
echo -e "\n==== PID stat ====\n" >>$CHECK_RESULT
test -f /usr/bin/pidstat && pidstat  >>$CHECK_RESULT

# Check RPM counts
echo -e "\n==== RPM counts ====\n" >>$CHECK_RESULT
rpm -qa | wc -l >>$CHECK_RESULT

# Check Default target
echo -e "\n==== RPM counts ====\n" >>$CHECK_RESULT
systemctl get-default >>$CHECK_RESULT

# Check Filesystem
echo -e "\n==== Filesystem ====\n" >>$CHECK_RESULT
df -Th >>$CHECK_RESULT

echo -e "\n==== Filesystem inode ====\n" >>$CHECK_RESULT
df -ih >>$CHECK_RESULT

# Check Memory
echo -e "\n==== Memory ====\n" >>$CHECK_RESULT
free -m >>$CHECK_RESULT

# Check Zombies
echo -e "\n==== Zombies ====\n" >>$CHECK_RESULT
ps -ef|grep defunct | grep -v grep >>$CHECK_RESULT

# Check SELinux
echo -e "\n==== SELinux ====\n" >>$CHECK_RESULT
getenforce >>$CHECK_RESULT

# Check Firewall
echo -e "\n==== Firewall ====\n" >>$CHECK_RESULT
systemctl status firewalld >>$CHECK_RESULT

# Check Kdump
echo -e "\n==== Kdump ====\n" >>$CHECK_RESULT
systemctl status kdump >>$CHECK_RESULT

# Check Services
echo -e "\n==== Service ====\n" >>$CHECK_RESULT
systemctl list-units --type service >>$CHECK_RESULT

# Check Ulimits
echo -e "\n==== ulimits.conf ====\n" >>$CHECK_RESULT
egrep -v "#|^$" /etc/security/limits.conf >>$CHECK_RESULT
echo -e "\n==== ulimits.d/*.conf ====\n" >>$CHECK_RESULT
ls /etc/security/limits.d/*.conf >>$CHECK_RESULT
grep -v "#" /etc/security/limits.d/*.conf >>$CHECK_RESULT
echo -e "\n==== Ulimits ====\n" >>$CHECK_RESULT
ulimit -a >>$CHECK_RESULT

# Check Processes
echo -e "\n==== Processes ====\n" >>$CHECK_RESULT
ps -e f |egrep -v '\[' >>$CHECK_RESULT

# Check Journal disk-usage
echo -e "\n==== Journal disk-usage ====\n" >>$CHECK_RESULT
journalctl --disk-usage >>$CHECK_RESULT

# Check Top
echo -e "\n==== Top ====\n" >>$CHECK_RESULT
top n 1 b >>$CHECK_RESULT

# Check RPM list
echo -e "\n==== RPM list ====\n" >>$CHECK_RESULT
rpm -qa | sort >>$CHECK_RESULT

# Check Dmesg
echo -e "\n==== Dmesg ====\n" >>$CHECK_RESULT
journalctl -k >>$CHECK_RESULT

# Check Journal latest ${LINES} lines
echo -e "\n==== Check latest ${LINES} lines message ====\n" >>$CHECK_RESULT
journalctl -n${LINES} >>$CHECK_RESULT

# Check finished
echo -e "\n==== OS Check finished ====\n" >>$CHECK_RESULT

cd $REPORT_DIR/ && tar zcf `hostname`-$REPORT_TYPE-$DATE.tgz $REPORT_TYPE/

echo -e "System check report file:
    $REPORT_DIR/`hostname`-$REPORT_TYPE-$DATE.tgz
Please download and send this file to BSG support team."
}

alias egrep='egrep --color=auto'
DATE=`date +%Y%m%d`
REPORT_TYPE="system"
REPORT_DIR="/tmp/check-reports"
HOSTNAME=`hostname`
LINES="2000"

test -d $REPORT_DIR/$REPORT_TYPE
if [ $? -eq 1 ]; then
mkdir -p $REPORT_DIR/$REPORT_TYPE
fi

CHECK_RESULT=$REPORT_DIR/$REPORT_TYPE/$HOSTNAME-$REPORT_TYPE-$DATE.log

echo -e "">$CHECK_RESULT
echo -e "==== Syetem health check on `hostname` at `date +%F\ %H:%M:%S` ====\n" >>$CHECK_RESULT
echo -e "[System Health Check Report]\n" >>$CHECK_RESULT

test -f /etc/SuSE-release
if [ $? -eq 0 ];then
  SUSEVERSION="`grep VERSION /etc/SuSE-release | awk '{print $3}'`"
  SUSEPATCHLEVEL="`grep PATCHLEVEL /etc/SuSE-release | awk '{print $3}'`"

  if [ $SUSEVERSION == 12 ];then
    echo -e "Beginning SUSE 12 System Check...\n"
    sles12_system_check_detail_csv
  elif [ $SUSEVERSION == 11 ];then
    echo -e "Beginning SUSE 11 System Check...\n"
    sles11_system_check_detail_csv
  fi
exit
fi

test -f /etc/upel-release
if [ $? -eq 0 ];then
  UPELVERSION="`cat /etc/upel-release | awk '{print $4}' | awk -F. '{print $1}'`"

  if [ ${UPELVERSION} == 1 ];then
    echo -e "Beginning UPEL 1  System Check...\n"
    upel_system_check_detail_csv
  fi
exit
fi

test -f /etc/centos-release
if [ $? -eq 0 ];then
  CENTOSVERSION="`cat /etc/centos-release | awk '{print $4}' | awk -F. '{print $1}'`"

  if [ ${CENTOSVERSION} == 7 ];then
    echo -e "Beginning CentOS 7 System Check...\n"
    upel_system_check_detail_csv
  fi
exit
fi

echo "WARN: This OS none SUSE-12, UPEL-1 and CentOS-7 Linux, exit!"
