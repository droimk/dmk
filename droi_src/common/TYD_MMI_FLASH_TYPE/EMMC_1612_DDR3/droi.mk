################################################################################
#huangjun @ 2015/09/14
# v01
################################################################################
LOCAL_PATH:= $(call my-dir)

include $(DROI_CLEAR_VARS)
DROI_MODULE := custom_MemoryDevice_h 
DROI_SRC_FILE := custom_MemoryDevice.h
DROI_SRC_TARGET_PATH := bootable/bootloader/preloader/custom/$(DROI_PRODUCT)/inc/custom_MemoryDevice.h 
include $(DROI_PREBUILD)
