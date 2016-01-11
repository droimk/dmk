#!/bin/bash 
################################################################################
#huangjun @ 2015/09/14~21
# v01
################################################################################
args=($@)
#base project
bproject=${args[0]}
#mtk base
mtkbproject=${args[1]}
#new project
nproject=${args[2]}
#arch
arch=${args[3]}
#company name 
com_name=${args[4]}
#remove project flag
rm_flg=${args[5]}
#mtk platform
platform=mt6735

KERNEL_V=`find kernel*/ -maxdepth 1 -name Makefile | awk -F"/" '{print $1}'`
bsp_path_default=bootable/bootloader
preloader_custom_path=$bsp_path_default/preloader/custom
lk_root_path=$bsp_path_default/lk
kernel_arch_path=$KERNEL_V/arch/$arch
kernel_mach_path=$KERNEL_V/drivers/misc/mediatek/mach/$platform
vendor_custom_path=vendor/mediatek/proprietary/custom
company_path=device/$com_name
trustzone_path=vendor/mediatek/proprietary/trustzone/project


function itor()
{
	local path_arr=($bsp_path_default vendor/mediatek/proprietary/bootable/bootloader)
	for p in ${path_arr[@]};do
		preloader_custom_path=$p/preloader/custom
		lk_root_path=$p/lk
		`eval $1` && return
	done
	echo "can't find any path of bootable"
}
function zone_itor()
{
	local path_zone=($trustzone_path vendor/mediatek/proprietary/trustzone/custom/build/project)
	for p in ${path_zone[@]};do
		trustzone_path=$p
		`eval $1` && return
	done
	echo "can't find any path of trustzone"
}

function process()
{
	local j=
	trap 'exit' 1 2 3 15
	stty -echo >/dev/null 2>&1
	while true
	do
		for j  in  '-' '\\' '|' '/'
		do
			tput  sc
			echo -ne  "Please waiting ... $j"
			sleep 0.1
			tput rc
		done
	done
	stty echo
}

function do_clone_action()
{
	#clone preloader
	itor '[ -d $preloader_custom_path/$bproject ]'
	zone_itor '[ -f $trustzone_path/$bproject.mk ]'
	cp -r $preloader_custom_path/$bproject $preloader_custom_path/$nproject && \
	mv $preloader_custom_path/$nproject/$bproject.mk $preloader_custom_path/$nproject/$nproject.mk  &&\
	sed -i s/$bproject/$nproject/g $preloader_custom_path/$nproject/$nproject.mk

	#clone lk

	cp $lk_root_path/project/$bproject.mk $lk_root_path/project/$nproject.mk && \
	cp -r $lk_root_path/target/$bproject $lk_root_path/target/$nproject && \
	sed -i s/$bproject/$nproject/g $lk_root_path/project/$nproject.mk && \
	sed -i s/$bproject/$nproject/g $lk_root_path/target/$nproject/include/target/cust_usb.h && \

	#clone kernel

	cp -r $kernel_mach_path/$bproject $kernel_mach_path/$nproject  && \
	cp $kernel_arch_path/boot/dts/$bproject.dts $kernel_arch_path/boot/dts/$nproject.dts && \
	cp $kernel_arch_path/configs/${bproject}_debug_defconfig $kernel_arch_path/configs/${nproject}_debug_defconfig && \
	cp $kernel_arch_path/configs/${bproject}_defconfig $kernel_arch_path/configs/${nproject}_defconfig && \
	sed -i s/$bproject/$nproject/g $kernel_arch_path/configs/${nproject}_debug_defconfig && \
	sed -i s/$bproject/$nproject/g $kernel_arch_path/configs/${nproject}_defconfig && \

	#clone android

	cp -r $company_path/$bproject $company_path/$nproject  && \
	mv $company_path/$nproject/full_$bproject.mk $company_path/$nproject/full_$nproject.mk && \
	sed -i s/$bproject/$nproject/g $company_path/$nproject/AndroidProducts.mk && \
	sed -i s/$bproject/$nproject/g $company_path/$nproject/BoardConfig.mk && \
	sed -i s/$bproject/$nproject/g $company_path/$nproject/device.mk && \
	sed -i s/$bproject/$nproject/g $company_path/$nproject/full_$nproject.mk && \
	sed -i s/$bproject/$nproject/g $company_path/$nproject/vendorsetup.sh && \


	cp -r $vendor_custom_path/$bproject $vendor_custom_path/$nproject && \
	sed -i s/$bproject/$nproject/g $vendor_custom_path/$nproject/Android.mk


	cp -r $trustzone_path/$bproject.mk $trustzone_path/$nproject.mk

	cd vendor/$com_name/libs > /dev/null
	ln -sf $mtkbproject $nproject
	cd - > /dev/null
}

function do_remove_action()
{
	rm -rf $preloader_custom_path/$nproject $lk_root_path/project/$nproject.mk $lk_root_path/target/$nproject \
		$kernel_mach_path/$nproject $kernel_arch_path/boot/dts/$nproject.dts \
		$kernel_arch_path/configs/${nproject}_debug_defconfig $kernel_arch_path/configs/${nproject}_defconfig \
		$company_path/$nproject $vendor_custom_path/$nproject $trustzone_path/$nproject.mk 
	rm -f vendor/$com_name/libs/$nproject > /dev/null
	local vp=$(echo `cat droi_src/config/project.db | grep "$nproject |" |awk -F"|" '{print $2}'`)
	if [ -d "droi_src/project/$vp" ];then
		rm -rf droi_src/project/$vp
	fi
}

function do_copy_vendor()
{
	local bvp=$(echo `cat droi_src/config/project.db | grep "$bproject |" |awk -F"|" '{print $2}'`)
	local nvp=$DROI_PCBA_PRODUCT
	if [ ! -z "$bvp" ];then 
		cp -rf droi_src/project/$bvp droi_src/project/$nvp
	fi
}

function main()
{
	local ret=1
	
	if [ ${#args[@]} -lt 5 ];then
		echo "clone_project.sh Args lost!!!!"
		exit "1"
	fi
	process &
	bg_pid=$!
	rm -f clperr.log

	if [ -z "$rm_flg" ];then
		do_clone_action  > clperr.log 2>&1
		do_copy_vendor
	else
		do_remove_action > clperr.log 2>&1
	fi	

	if [ -z "`cat clperr.log`" ];then
		ret=0
	fi

	kill -15 $bg_pid
	exit "$ret"
}
#0 success
#1 fail
echo "C/R args:[${args[@]}]"
main







