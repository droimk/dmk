#!/bin/bash
function addmacro()
{
	local ALL_PCBA_MACRO="TYD_PROJECT TYD_PROJECT_CUSTOM"
	local KDEF=
	local project=`echo $1 |awk -F'-' '{print $2}' | sed s/d//`
	local filepath=`find  tyd  -name "$project"`
	for pcbamacro in $ALL_PCBA_MACRO;
	do
		local ac=`cat $filepath/ProjectConfig.mk | grep "\b$pcbamacro\b" | awk -F"=" '{print $2}'`
		KDEF+=" -D`echo $(echo $ac)`"
	done
	#export KDEFINE=$KDEF
	echo "$KDEF"
}
addmacro $@

