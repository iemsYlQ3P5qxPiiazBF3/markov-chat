#!/bin/bash
mkdir markov-chat 2>/dev/null
{ mv mrkfeed.awk markov-chat
mv mrkwords.sh markov-chat;} 2>/dev/null||{ [ ! -e markov-chat/mrkfeed.awk ]&&exit;[ ! -e markov-chat/mrkwords.sh ]&&exit;}
cd markov-chat
touch input.txt
quit(){
 echo
 read -erp "quit[y/N]: " yq
 case $yq in
  y|Y)
  exit
  ;;
 esac
}
trap quit SIGINT
while :;do
  read -erp "> " input
 if [ "$input" == "" ];then
  out="$(./mrkwords.sh model.mrkdb $1|tr '\n' ' ')"
  echo "$out"
  [ "$2" == "-e" ]&&echo "$out" >> input.txt
  [ "$2" == "-s" ]&&echo "$out"|espeak
  [ "$2" == "-es" ]||[ "$2" == "-se" ]&&{ echo "$out" >> input.txt; echo "$out"|espeak;}
  : '
    no.
    '
 else
  echo "$input" >> input.txt
  ./mrkfeed.awk < input.txt > model.mrkdb
  out="$(./mrkwords.sh model.mrkdb $1|tr '\n' ' ')"
  echo "$out"
  [ "$2" == "-e" ]&&echo "$out" >> input.txt
  [ "$2" == "-s" ]&&echo "$out"|espeak
  [ "$2" == "-es" ]||[ "$2" == "-se" ]&&{ echo "$out" >> input.txt; echo "$out"|espeak;}
 fi
done
