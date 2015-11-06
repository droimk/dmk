################################################################################
#huangjun @ 2015/09/14
# v01
################################################################################

#
#cp current files to target dir/files
#
define copy-files-with-cp
$(hide) mkdir -p $@
$(hide) cp -ruf  $</* $@
$(hide) rm -f $@/droi.mk
endef

define copy-file-with-cp
$(hide) cp -uf  $< $@
endef

define copy-files-with-cp-fc
$(hide) mkdir -p $@
$(hide) cp -rf  $</* $@
$(hide) rm -f $@/droi.mk
endef

define copy-file-with-cp-fc
$(hide) cp -f  $< $@
endef

DEPEND_ON_DROI_MODULE := ramdisk factory_ramdisk \
	userdataimage cacheimage vendorimage bootimage systemimage preloader pl lk  \
	kernel files systemimage apps_only target-native target-java

ALL_DROI_MODULE :=$(strip $(ALL_DROI_MODULE))
ALL_DROI_TARGET_PATH :=

DROI_TOP := droi_src
DROI_BUILD := $(DROI_TOP)/build
DROI_KERNEL_CONFIG_PATH := kernel-3.10/arch/arm64/configs
DROI_PRODUCT:=$(shell echo $(TARGET_PRODUCT) | sed s/full_//g)

DROI_ACTION_CFG := out/target/product/$(DROI_PRODUCT)/.droi_module.cfg
