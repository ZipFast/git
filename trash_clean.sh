#!/bin/bash
useage()
{
	echo "usage: "
	echo "-n					清空文件"
	echo "-s <NUMNER>			输入最大允许文件大小"
	echo "-p <path>				输入文件路径"
	echo "-t <filetype>         输入文件类型，例如.txt .jpg .log等"
	echo "-d"
	echo "-m                   移动文件"
	echo "-v <TargetPath>		移动的目标文件夹"
	echo "-r 					移除文件"
	echo "-h					显示帮助提示"
	echo "-z					将当前目录文件夹打包"
	exit 1
}
ScriptName="trash_clean.sh"; 
useParam=true; 
nullit=false; 
buggerme=false; 
maxsize=600; 
SourcePath="";  
filetype="*.jpg"; 
movefile=false;  
destinationPath="/temp/"; 
removefile=false; 
zipIT=false; 
writedebug()
{
	if $buggerme ; then
		echo "$1"
	fi
}
donullit()
{
	echo "Empty file $1"
	cp /dev/null $1;
}

domoveit()
{
	echo "moving file from $1 to $2"
	mv $1 $2;
}
doremoveit()
{
	echo "removing file $1"
	rm -rf $1;
}
dozipit()
{
	echo "zipping file $1"
	bzip2 -9 $1;
	
}
removebackslash()
{
	SourcePath=${1%/};
}


if $useParam ; then
	if [[ $# -gt 0 ]] ; then
	while getopts "v:s:p:t:dnhmrz" opt; do
		case $opt in
			n) nullit=true;; 
			s) maxsize=$OPTARG;;  
			p) SourcePath=$OPTARG;; 
			t) filetype=$OPTARG;; 
			d) buggerme=true;;
			m) movefile=true;;
			v) destinationPath=$OPTARG;;
			r) removefile=true;;
			z) zipIT=true;;
			?) echo "Invalid option: -$OPTARG" >&2
			      exit 1;; 
			:)
			      echo "Option -$OPTARG requires an argument." >&2
			      exit 1
			      ;;
			h) useage;;
		esac
	done;
	else
		useage;
	fi
else
	if [[ -n "$SourcePath" ]] ; then
		echo "Source Directory - $SourcePath"
	else
		echo "Missing Hardcoded Source Directory!"
		exit 1
	fi
fi


writedebug "buggerme=$buggerme"
writedebug "nullit=$nullit"
writedebug "maxsize=$maxsize" 
writedebug "SourcePath=$SourcePath"
writedebug "FileType=$filetype"
writedebug "ZipIT=$zipIT"
writedebug "UseFriendlydu=$UseFriendlydu"
removebackslash $SourcePath;
Lookin="$SourcePath/$filetype"
if $nullit ; then
	movefile=false;
	removefile=false;
	zipIT=false;
elif $movefile ; then
	removefile=false;
	nullit=false;
	zipIT=false;
elif $removefile ; then
	movefile=false;
	nullit=false;
	zipIT=false;
elif $zipIT ; then
	movefile=false;
    nullit=false;
    removefile=false;
fi

for f in $Lookin; do
	a=$(du -ks $f | cut -f1)
	if [[ -n "$a" ]] ; then
		if (($a > $maxsize)); then
			if $nullit ; then
				donullit $f;
			elif $movefile ; then
				domoveit $f $destinationPath;
			elif $removefile ; then
				doremoveit $f;
			elif $zipIT ; then
				dozipit $f;
			else
				
				echo "BIGFILE! $f is $a KB"
				
			fi
		fi
	fi
done
