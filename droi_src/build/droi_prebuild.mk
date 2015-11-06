################################################################################
#huangjun @ 2015/09/14
# v01
################################################################################
droi_build := $(DROI_MODULE)

ifeq ($(droi_build),)
droi_build := $(notdir $(LOCAL_PATH))
endif
droi_build := $(strip $(droi_build))

ifeq ($(DROI_SRC_FILE),)
build_src_files := $(LOCAL_PATH)
#force copy
$(shell touch $(build_src_files))
else
build_src_files := $(LOCAL_PATH)/$(DROI_SRC_FILE)
endif

ifeq ($(findstring $(droi_build),$(ALL_DROI_MODULE)),)
#ifeq ($(ALL_DROI_MODULE),)
#ALL_DROI_MODULE := $(droi_build)
#else
ALL_DROI_MODULE += $(droi_build)
#endif
else
droi_timestap:=$(shell date +%s)
ALL_DROI_MODULE += $(droi_build)-$(droi_timestap)
droi_build:=$(droi_build)-$(droi_timestap)
$(warning DROI_MODULE [$(droi_build)] exsit!!!!!! or found the same dirname)
endif

build_target_path := $(DROI_SRC_TARGET_PATH)
ifeq ($(build_target_path),)
$(error DROI_MODULE DROI_SRC_TARGET_PATH must't be null at $(LOCAL_PATH))
endif

build_check_var:=$(filter %$(build_target_path),$(ALL_DROI_TARGET_PATH))
ifneq ($(strip $(build_check_var)),) 
$(error DROI_MODULE target dir $(build_target_path) have been added at $(build_check_var))
endif

DROI_PWD_F:=$(filter $(shell pwd)/%,$(build_src_files) $(build_target_path))
ifneq ($(DROI_PWD_F),)
$(error DROI_MODULE Forbid using PWD path!!! Module at $(LOCAL_PATH))
endif

build_check_var:=$(filter out/%,$(build_target_path))
build_check_var+=$(filter ./out/%,$(build_target_path))
ifneq ($(strip $(build_check_var)),)
$(error DROI_MODULE $(build_check_var) Forbiding add out dir!!!!info [$(droi_build)]$(LOCAL_PATH):$(build_target_path))
endif

#mktarget:sourcedir:targetdir
ALL_DROI_TARGET_PATH += [$(droi_build)]$(LOCAL_PATH):$(build_target_path)
ALL_DROI_TARGET_PATH := $(strip $(ALL_DROI_TARGET_PATH))

#$(info $(droi_build):$(build_src_files):$(build_target_path))
$(droi_build):$(build_target_path)
$(build_target_path):$(build_src_files)
ifeq ($(DROI_FC),update)
	@echo '[Droicover] $< ====> $@'
ifeq ($(DROI_SRC_FILE),)
	$(copy-files-with-cp-fc)
else
	$(copy-file-with-cp-fc)
endif
else
	@echo '[Droicover] u $< ====> $@'
ifeq ($(DROI_SRC_FILE),)
	$(copy-files-with-cp)
else
	$(copy-file-with-cp)
endif
endif

droi_build:=
build_target_path:=
