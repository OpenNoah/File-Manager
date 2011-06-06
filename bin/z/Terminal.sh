#!/bin/sh
color='\E[1;31m' ; about='\E[0;37m' ; end='\E[0m'
declare -a inp=("'\E[1;34mEN ' '\E[1;33mCH '")
show='************' ; stty erase '^?' ; clear
if [ "$1" = "EN" ] ; then cmd='e' ; ce=0
  echo -e "$color$show 英  文  命  令  输  入 $show$end"
else cmd='r' ; ce=1
  echo -e "$color$show 中  文  命  令  输  入 $show$end"
fi
how="echo -e $about $about 输入 EN 切换到英文, CH 切换到中文, quit 退出$end"
$how
until [ "$cdin" = "quit" ] ; do
  echo -en "${inp[ce]}# $end" ; read -$cmd cdin
  case "$cdin" in
  "EN" ) cmd="e" ; ce=0
    echo -e "$color$show 英  文  命  令  输  入 $show$end" ; $how ;;
  "CH" ) cmd="r" ; ce=1
    echo -e "$color$show 中  文  命  令  输  入 $show$end" ; $how ;;
  "quit" )
    echo -e "$color$show程序退出$show$end" ;;
  * ) $cdin ;;
  esac
done
exit 0
