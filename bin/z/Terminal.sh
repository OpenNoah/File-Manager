#!/bin/sh
color='\E[1;31m' ; about='\E[0;37m' ; end='\E[0m'
declare -a inp=("'\E[1;34mEN ' '\E[1;33mCH '")
show='************' ; stty erase '^?' ; clear
if [ "$1" = "EN" ] ; then cmd='e' ; ce=0
  echo -e "$color$show Ӣ  ��  ��  ��  ��  �� $show$end"
else cmd='r' ; ce=1
  echo -e "$color$show ��  ��  ��  ��  ��  �� $show$end"
fi
how="echo -e $about $about ���� EN �л���Ӣ��, CH �л�������, quit �˳�$end"
$how
until [ "$cdin" = "quit" ] ; do
  echo -en "${inp[ce]}# $end" ; read -$cmd cdin
  case "$cdin" in
  "EN" ) cmd="e" ; ce=0
    echo -e "$color$show Ӣ  ��  ��  ��  ��  �� $show$end" ; $how ;;
  "CH" ) cmd="r" ; ce=1
    echo -e "$color$show ��  ��  ��  ��  ��  �� $show$end" ; $how ;;
  "quit" )
    echo -e "$color$show�����˳�$show$end" ;;
  * ) $cdin ;;
  esac
done
exit 0
