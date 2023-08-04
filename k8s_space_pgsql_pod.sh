#!/usr/bin/env bash

THRASHOLD=80
[ $# -gt 0 ] && THRASHOLD=$1

Alarm_log='~/alarm_log'
PGS=$(kubectl get po -A | grep -e Running, -e postgres | grep -wv -e backup -e default -e 'Evicted' | awk '{print $1 "," $2}' | xargs -n1)

printf "%-7s %-25s %7s %7s %7s %7s %-7s\n" "NS" "POD" "TOT" "USE" "AVAIL" "USE%" "ALARM(>$THRASHOLD%)" > $Alarm_log

for p in ${PGS[*]}; do

 NS=${p%,*}
 POD=${p#*,}

 for pod in ${POD[*]}; do
  DF=($(kubectl exec -t -n $NS $pod -- df -h | grep -e postgres -e pgsql | tr -s ' ' | xargs -n1))
  if [ ${#DF[*]} -gt 0 ]; then
   SIZE=${DF[1]}
   USED=${DF[2]}
   AVAIL=${DF[3]}
   PERCENT_USE=${DF[4]}
   PERCENT_USE_N=${PERCENT_USE%\%*}
   [ $PERCENT_USE_N -gt $THRASHOLD ] && ALARM="ALARM" || ALARM=""
   printf "%-7s %-25s %7s %7s %7s %7s %-7s\n" $NS $pod $SIZE $USED $AVAIL $PERCENT_USE $ALARM >> $Alarm_log
  else
   :   #echo "DF error!"
  fi
 done
done
