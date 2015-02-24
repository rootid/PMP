#!/bin/bash
#Monitor the process with the process name 
process_name=$1
[ $process_name ]  || process_name='java'
nsamples=1
sleeptime=0
pid=$(pidof ${process_name})
#pid=$(pidof mysqld)

for x in $(seq 1 $nsamples)
  do
    gdb -ex "set pagination 0" -ex "thread apply all bt" -batch -p $pid
    #(echo "set pagination 0"; 
    # echo "thread apply all bt"; 
    # echo "quit"; cat /dev/zero ) | gdb -p $(pidof Xorg)
    sleep $sleeptime
  done | \
awk '
  BEGIN { s = ""; } 
  /^Thread/ { print s; s = ""; } 
  /^\#/ { if (s != "" ) { s = s "," $4} else { s = $4 } } 
  END { print s }' | \
sort | uniq -c | sort -r -n -k 1,1
