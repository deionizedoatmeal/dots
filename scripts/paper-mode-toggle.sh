#!/bin/bash
# by ian k. bania 
# feb '20


#grepstuff=$(i3-msg -t get_tree | grep -oP 'gaps":{"inner":0,"outer":0,"top":0,"right":.{0,3}' | tail -1 | grep -o '.\{3\}$')
#grepstuff=$()
#grepstuff=$(i3-msg -t get_tree | grep -oP '750' | tail -1)
#grepstuff=$(i3-msg -t get_tree | grep -oP '.{0,250}"focused":true' | grep -oP 'right.{0,5}' | grep -o '.\{3\}$')
#GREPSTUFF=$(i3-msg -t get_tree | grep -oP '.{0,1500}"focused":true' | grep -oP 'gaps.{0,65}' | grep -oP '"right":.{0,3}' | cut -c 9-9)


I3MSG=$(i3-msg -t get_tree)
DELIM='"focused":true'
#echo ${DELIM}
FOCUSED=${I3MSG%%${DELIM}*}
#echo ${FOCUSED}
GAPS=${FOCUSED##*gaps}
#echo ${GAPS}
DELIM='"right":'
#echo ${DELIM}
RIGHT=${GAPS##*${DELIM}}
#echo ${RIGHT}
RIGHTVALUE=${RIGHT%%,*}
#echo "-!--> *** ***"
#echo ${RIGHTVALUE}

if [[ ${RIGHTVALUE} -eq 0 ]]; then
    i3-msg gaps right current set $1;
    i3-msg gaps left current set $1;
    i3-msg gaps top current set $2;
    i3-msg gaps bottom current set $3;
#    i3-msg split v;
else
    i3-msg gaps right current set 0;
    i3-msg gaps left current set 0;
    i3-msg gaps top current set 35;
    i3-msg gaps bottom current set 0;
#    i3-msg split h;
fi
