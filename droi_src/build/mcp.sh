#!/bin/bash 

################################################################################
#huangjun @ 2015/11/02
# v01
################################################################################
function main()
{
	local dest=
	local dtmp=($@)
	local tmp=
	local tm=

	for tmp in ${dtmp[@]}
	do
		[ -f "$tmp" ] && dest=$tmp
	done

	[ -z "$dest" ] && return 1
	tm=`ls --full-time $dest | awk -F" " '{print $6,$7}'`
	cp $@
	if [ $? -eq 0 ] && [ ! -z "$tm" ];then
		touch --date="$tm" $dest
	fi
}

main $@
