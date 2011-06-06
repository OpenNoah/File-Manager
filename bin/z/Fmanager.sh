#!/bin/sh

#����
app='/opt/QtPalmtop/bin/z'
listfile='/tmp/ListSelect.tmp' ; null='/dev/null'
recycle='/mnt/UsrDisk/Recycle'
outfile='/tmp/DirFile.tmp' ; lstmp='/tmp/ls.tmp'
optbin='/opt/QtPalmtop/bin'
declare -a dir style click clickterms \
title=("�ļ����� ���ļ� ѡ���ļ� �����ļ�") bak \
clickbak clickmsg=("ѡ����� ȡ��ѡ��") \
clickshow=("'[ ]' '\E[94m[\E[31mX\E[94m]'") \
dirlink=(���ص����ļ��� ��������Ŀ¼) \
linkshow=([1]="��������Ŀ¼") clicknames \
tar=("��... ��... ��ѹ...") copy ok=("���")
xy="4 14 0 0" ; select=1
for ((n=1;n<=255;n++)) ; do
  ok[$n]="ʧ��"
done

#ת������
inc='\E[33;40m' ; comc='\E[31m' ; end='\E[0m'
declare -a color=("'\E[94m' '\E[92m' '\E[96m'\
 '\E[95m' '\E[31m' '\E[22;36m' '\E[92m'") linkp=("'' '\E[3;1H\E[2K'")

#����
prog_find(){
  n=0 ; unset dir[@] ; ls -1a > "$lstmp"
  while read line ; do
    if [ "${click[n]}" = "" ] ; then click[$n]=0 ; fi
    prog_sure ; dir[$((n++))]="$line"
  done < "$lstmp"
  if [ "${dir[*]}" != "${bak[*]}" ] ; then
    prog_click_back
  fi
  for ((n=0;n<=${#dir[@]};n++)) ; do
    bak[$n]="${dir[n]}"
  done
  $app/List.sh "  ${title[open]}  "\
  "${PWD:((${#PWD}>36?-36:0))}" "" "0" "10" "$((select-1))"\
  "'..' `for ((n=2;n<${#dir[@]};n++)) ; do echo "'${clickshow[click[n]]}${color[style[n]]}${dir[n]}'" ; done`\
  '> $incĿ¼����...' '> $incѡ�������...' '> $inc������Ϣ' '> $inc�˳�'"
}
prog_sure(){
  if [ -d "$line" ] ; then style[n]=0
    if [ -h "$line" ] ; then style[n]=5 ; fi
  elif [ -h "$line" ] ; then style[n]=2
  elif [ -b "$line" ] ; then style[n]=3
  elif [ -c "$line" ] ; then style[n]=4
  else
    if [ "${line:(-7)}" = '.tar.gz' ] ; then style[n]=6
    else style[n]=1
    fi
  fi
}
prog_msgbox_dirmenu(){
  $app/Msgbox.sh "$xy" "Ŀ¼����"\
  "'��������...' '�½��ļ�(��)...' �������� ճ�� ���� ����"
  case "$?" in
  0 ) prog_msgbox_run ;;
  1 ) prog_msgbox_new ;;
  2 ) prog_link_make ;;
  3 ) prog_paste ;;
  4 ) prog_search ;;
  esac
}
prog_msgbox_run(){
  $app/Msgbox.sh "$xy" "��������"\
  "Ӣ������ �������� ȡ��"
  case "$?" in
  0 ) $app/Terminal.sh "EN" ;;
  1 ) $app/Terminal.sh "CH" ;;
  esac
}
prog_msgbox_new(){
  $app/Msgbox.sh "$xy" "'�½��ļ�(��)'"\
  "�½��ļ� �½��ļ��� ȡ��"
  case "$?" in
  0 ) prog_input "�½��ļ�" ; echo -n "" >> "$read" ;;
  1 ) prog_input "�½��ļ���" ; mkdir "$read" ;;
  esac
}
prog_link_make(){
  if [ "$mount" = "" ] ; then
    echo -e "$incû��ѡ������ԭ�ļ�!$end" ; return
  fi
  prog_input �������� ; ln -sn "$mount" "./$read"
  echo -e "$inc���Ӵ���${ok[$?]}!$end"
}
prog_input(){
  echo -e "\E[1m$inc$1 ����������: (���������ַ�ʱ�������)$end"
  read -r read
}
prog_paste(){
  if [ "${copy[0]}" = "" ] ; then
    echo -e "$inc�����������ļ�!$end"
    usleep 500000 ; return
  fi
  echo -e "$incճ����...$end"
  for ((n=1;n<${#copy[@]};n++)) ; do
    echo -e "$inc$n/$((${#copy[@]}-1)): ${copy[n]}$end"
    if [ "${copy[0]}" = 0 ] ; then mv "${copy[n]}" .
    else cp -rf "${copy[n]}" .
    fi
  done
}
prog_search(){
  echo -e "$inc�˹���δ���!$end"
}
prog_file(){
  pwd="$PWD/${dir[select]}" ; tmp="$1"
  if [ "$tmp" = 2 ] ; then tmp=0 ; fi
  echo -ne "${linkp[$1]}$3$end"
  $app/Msgbox.sh "$xy" "$2"\
  "'${clickmsg[click[select]]}' '����...' ${linkshow[$1]} ${tar[$1]} '����/����' '������' 'ɾ��...' '����'"
  case "$?" in
  0 ) click[$select]=$((click[select]==0)) ;;
  1 ) prog_file_msgbox_run ;;
  $((tmp+1)) ) cd "$(dirname "$(readlink "${dir[select]}")")" ; select=1 ;;
  $((tmp+2)) )
    if [ "$1" = 2 ] ; then prog_unpick
    else prog_file_open
    fi ;;
  $((tmp+3)) ) prog_mount ;;
  $((tmp+4)) ) prog_rename ;;
  $((tmp+5)) ) prog_delete ;;
  esac
}
prog_file_open(){
  $app/Msgbox.sh "$xy" "���ļ� ��ѡ��򿪷�ʽ:"\
  "'ŵ����Է' '�ҵ����' '��������' '������' '  ����  '"
  tmp=$?
  if [ "$tmp" = 4 ] ; then return ; fi
  echo -e "$inc��Ҫ��С��,��С�����޷��ָ�!$end"
  case $tmp in
  0 ) "$optbin/ebook" "$PWD/${dir[select]}" ;;
  1 ) "$optbin/photo" "$PWD/${dir[select]}" ;;
  2 ) "$optbin/konqueror" "$PWD/${dir[select]}" ;;
  3 ) prog_file_edit ;;
  esac
}
prog_file_msgbox_run(){
  $app/Msgbox.sh "$xy" "�����ļ�"\
  "�ڴ��ն����� 'qcop�ⲿ����' ȡ��"
  case "$?" in
  0 ) (${dir[select]}) ;;
  1 ) /opt/QtPalmtop/bin/qcop "QPE/System"\
  "xxExecute(QString)" "$pwd" ;;
  esac
}
prog_file_edit(){
  edit=0 ; ln -sn "${dir[select]}" "${dir[select]}.c"
  if [ $? != 0 ] ; then
    cp "${dir[select]}" "${dir[select]}.c" ; edit=1
  fi
  /opt/QtPalmtop/bin/programSalon "${dir[select]}.c"
  if [ $edit = 1 ] ; then mv "${dir[select]}.c" "${dir[select]}"
  else rm "${dir[select]}.c"
  fi
}
prog_mount(){
  mount="$pwd"
  echo -e "$inc$pwd�Ѵ���Ϊ����/����ԭ�ļ�!$end" ; sleep 1s
}
prog_delete(){
  $app/Msgbox.sh "$xy" "ɾ���ļ� 'ȷ��Ҫɾ��?'"\
  "ɾ��������վ ����ɾ�� ȡ��ɾ������"
  case "$?" in
  0 )
    rm -rf "$recycle/${dir[select]}" > "$null"
    mv "${dir[select]}" "$recycle" ; tmp="$?" ;;
  1 ) rm -rf "${dir[select]}" ; tmp="$?" ;;
  2 ) return ;;
  esac
  echo -e "$incɾ��${ok[tmp]}!$end" ; usleep 500000
}
prog_rename(){
  prog_input �������ļ�
  mv "${dir[select]}" "$read"
  echo -e "$inc������${ok[$?]}!$end" ; usleep 500000
}
prog_click_back(){
  clickbak=(${click[@]}) ; unset click[@]
  for ((n=0;n<=${#bak[@]};n++)) ; do
    if [ "${clickbak[n]}" = 1 ] ; then
      if [ "${bak[n]}" = "${dir[n]}" ] ; then
        click[$n]=1 ; continue
      fi
      for ((m=0;m<=${#dir[@]};m++)) ; do
        if [ "${bak[n]}" = "${dir[m]}" ] ; then
          click[$m]=1
        fi
      done
    fi
  done
}
prog_click(){
  clicknum=0 ; unset clickterms[@] ; unset clicknames[@]
  declare -a clickterms ; declare -a clicknames
  for ((n=0;n<=${#dir[@]};n++)) ; do
    if [ "${click[n]}" = 1 ] ; then
      clickterms[${#clickterms[@]}]="$PWD/${dir[n]}"
      clicknames[${#clicknames[@]}]="${dir[n]}"
      ((clicknum++))
    fi
  done
  if [ $clicknum = 0 ] ; then
    echo ; echo -e "$inc��ѡ����!$end"
    usleep 500000 ; return
  fi
  $app/Msgbox.sh "$xy" "ѡ������� ��ѡ��$clicknum��"\
  "���� ���� 'ɾ��...' '���...' '����'"
  case $? in
  0 ) prog_multicut ;;
  1 ) prog_multicopy ;;
  2 ) prog_multidelete ;;
  3 ) prog_pickup ;;
  esac
}
prog_click_clear(){
  unset clicktrems[@] clickname[@] click[@] ; clicknum=0
}
prog_multicut(){
  unset copy[@] ; copy[0]=0 ; prog_copy_data
  echo -e "$inc����: �Ѵ���$clicknum���ļ���������$end"
  usleep 500000
}
prog_multicopy(){
  unset copy[@] ; copy[0]=1 ; prog_copy_data
  echo -e "$inc����: �Ѵ���$clicknum���ļ���������$end"
  usleep 500000
}
prog_copy_data(){
  for ((n=0;n<${#clickterms[@]};n++)) ; do
    copy[${#copy[@]}]="${clickterms[n]}"
  done
}
prog_multidelete(){
  $app/Msgbox.sh "$xy" "ɾ���ļ� ��ѡ��$clicknum���ļ�"\
  "ɾ��������վ ����ɾ�� ȡ��ɾ������"
  tmp="$?"
  if [ $tmp = 2 ] ; then return ; fi
  echo -e "$inc����ɾ���ļ���...$end"
  for ((n=0;n<${#clickterms[@]};n++)) ; do
    echo -e "$inc$((n+1))/${#clickterms[@]}: ${clickterms[n]}$end"
    if [ $tmp = 0 ] ; then
      rm -rf "$recycle/`basename "${clickterms[n]}"`" > "$null"
      mv "${clickterms[n]}" "$recycle"
    else
      rm -rf "${clickterms[n]}"
    fi
  done
  unset click[@] ; select=1
}
prog_pickup(){
  $app/Msgbox.sh "$xy" "'����.tar.gzѹ���ļ�' '��ѡ��$clicknum��'"\
  "'ѹ������ǰĿ¼' 'ѹ�������ش���' 'ѹ�����洢��' 'ȡ��'"
  case $? in
  0 ) tardir="$PWD" ;;
  1 ) tardir="/mnt/UsrDisk" ;;
  2 ) tardir="/mnt/mmc" ;;
  3 ) return ;;
  esac
  prog_input "�ļ����"
  echo -e "$incѹ����$tardir/$read.tar.gz: ѹ����...$end"
  tar -czvf "$tardir/$read.tar.gz" -C "$PWD" ${clicknames[@]}
  echo -e "$incѹ��${ok[$?]}!$end"
}
prog_dir(){
  echo -e "${linkp[$1]}$3$end"
  $app/Msgbox.sh "$xy" "�ļ���$2"\
  "'����' ${linkshow[$1]} '${clickmsg[click[select]]}' '���ص����ļ���' '����/����' '������' 'ɾ��...' '����'"
  case $? in
  0 ) cd "${dir[select]}" ; prog_click_clear ; select=1 ;;
  $1 ) cd "`readlink "${dir[select]}"`" ; select=1 ;;
  $((1+$1)) ) click[$select]=$((click[select]==0)) ;;
  $((2+$1)) ) prog_mount_to ;;
  $((3+$1)) ) pwd="$PWD/${dir[select]}" ; prog_mount ;;
  $((4+$1)) ) prog_rename ;;
  $((5+$1)) ) prog_delete ;;
  esac
}
prog_mount_to(){
  if [ "$mount" = "" ] ; then
    echo -e "$incû��ѡ�����ԭ�ļ�!$end"
    usleep 500000 ; return
  fi
  umount -l "${dir[select]}" ; usleep 300000
  mount "$mount" "${dir[select]}"
  echo -e "$inc����${ok[$?]}!$end"
}
prog_unpick(){
  $app/Msgbox.sh "$xy" "��ѹ�ļ�"\
  "��ѹ����ǰĿ¼ ��ѹ�����ش��� ��ѹ���洢�� ��ѹ����Ŀ¼ ȡ��"
  case $? in
  0 ) tardir="$PWD" ;;
  1 ) tardir="/mnt/UsrDisk" ;;
  2 ) tardir="/mnt/mmc" ;;
  3 ) tardir="/" ;;
  4 ) return ;;
  esac
  tar -xzvf "${dir[select]}" -C "$tardir"
  echo -e "$inc��ѹ${ok[$?]}$end"
}

#��ʼ��
mkdir -p "$recycle"
initdir="$1"
power=1 ; open=0

#������
stty -echo ; stty erase '^?' ; cd "$initdir"
until [ "$quit" = 1 ] ; do
  prog_find ; select="$(($(<$listfile)+1))"
  case "$select" in
  1 ) cd .. ;;
  ${#dir[@]} ) prog_msgbox_dirmenu ;;
  $((${#dir[@]}+1)) ) prog_click ;;
  $((${#dir[@]}+2)) ) df -h
    echo -e "$inc�����������...$end" ; read -s ;;
  $((${#dir[@]}+3)) ) exit 1 ;;
  * )
    case "${style[select]}" in
    0 ) prog_dir 0 ;;
    1 ) prog_file 0 ��ͨ�ļ� ;;
    2 ) prog_file 1 �ļ����� "\E[2G$inc��ַ: `readlink "${dir[select]}"`" ;;
    5 ) prog_dir 1 ���� "\E[2G$inc��ַ: `readlink "${dir[select]}"`" ;;
    6 ) prog_file 2 ѹ���ļ� ;;
    esac ;;
  esac
done
echo $result > $outfile ; stty echo ; exit 0
