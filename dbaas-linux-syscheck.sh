#!/bin/bash
# OS check report csv script
# Author Zhang Yongqi
# Version 1.0 2018-05-04
# Support UPEL 1.0, SLES 11.x, SLES 12.x

test -f /etc/SuSE-release 
if [ $? -eq 0 ];then 
  SUSEVERSION="`grep VERSION /etc/SuSE-release | awk '{print $3}'`"
  SUSEPATCHLEVEL="`grep PATCHLEVEL /etc/SuSE-release | awk '{print $3}'`"

  if [ $SUSEVERSION == 12 ];then
    echo -e "Beginning SUSE 12 System Check...\n"
    /bin/sh sles12-system-check-report-csv.sh
  elif [ $SUSEVERSION == 11 ];then
    echo -e "Beginning SUSE 11 System Check...\n"
    /bin/sh sles11-system-check-report-csv.sh
  fi
exit
fi

test -f /etc/upel-release
if [ $? -eq 0 ];then
  UPELVERSION="`cat /etc/upel-release | awk '{print $4}' | awk -F. '{print $1}'`"

  if [ ${UPELVERSION} == 1 ];then
    echo -e "Beginning UPEL 1  System Check...\n"
    /bin/sh upel-system-check-report-csv.sh
  fi
exit
fi

test -f /etc/centos-release 
if [ $? -eq 0 ];then
  CENTOSVERSION="`cat /etc/centos-release | awk '{print $4}' | awk -F. '{print $1}'`"

  if [ ${CENTOSVERSION} == 7 ];then
    echo -e "Beginning CentOS 7 System Check...\n"
    /bin/sh upel-system-check-report-csv.sh
  fi
exit
fi

echo "WARN: This OS none SUSE-12, UPEL-1 and CentOS-7 Linux, exit!"
