#!/bin/bash
grep "joined the game" ../logs/latest.log > join.log
grep "left the game" ../logs/latest.log > left.log
JOINTIME=$(grep -o '[0-2][0-9]:[0-5][0-9]:[0-5][0-9]' join.log)
grep -Po '([0-2][0-9]:[0-5][0-9]:[0-5][0-9]|\w*(?= joined))' join.log > userjoindata.log
grep -Po '([0-2][0-9]:[0-5][0-9]:[0-5][0-9]|\w*(?= left))' left.log > userleftdata.log
USERS=()
TIMES=()
ACTIONS=()
RESULTS=()
while read p; do
  [[ "$p" =~ [0-2][0-9]:[0-5][0-9]:[0-5][0-9] ]] && TIMES+=("${p//:/}")
  if ! [[ "$p" =~ [0-2][0-9]:[0-5][0-9]:[0-5][0-9] ]]; then
    USERS+=("$p")
    ACTIONS+=("join")
  fi
done < userjoindata.log

while read p; do
  [[ "$p" =~ [0-2][0-9]:[0-5][0-9]:[0-5][0-9] ]] && TIMES+=("${p//:/}")
  if ! [[ "$p" =~ [0-2][0-9]:[0-5][0-9]:[0-5][0-9] ]]; then
    USERS+=("$p")
    ACTIONS+=("left")
  fi
done < userleftdata.log

USERINDEX=0
for i in "${USERS[@]}"
do
  ACTION="${ACTIONS[$USERINDEX]}"
  TIME="${TIMES[$USERINDEX]}"
  TIMEINDEX=0
  HIGHTIME=0
  HIGHTIMEINDEX=0
  for j in "${TIMES[@]}"
  do
    if (($j > $HIGHTIME)); then
      HIGHTIME=$j
      HIGHTIMEINDEX=$TIMEINDEX
    fi
    TIMEINDEX=$((TIMEINDEX + 1))
  done
  if [[ ! " ${RESULTS[@]} " =~ " ${i} ${ACTIONS[$HIGHTIMEINDEX]} " ]]; then
    RESULTS+=(" ${i} ${ACTIONS[$HIGHTIMEINDEX]} ")
    echo " ${i} ${ACTIONS[$HIGHTIMEINDEX]} " >> whosonline.log
  fi
  USERINDEX=$((USERINDEX + 1))
done

aws s3 --region us-east-2 cp whosonline.log s3://ethan-miller-minecraft-backup/logs/whosonline.log