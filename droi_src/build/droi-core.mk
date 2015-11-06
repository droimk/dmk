################################################################################
#huangjun @ 2015/09/14
# v01
################################################################################
DROI_CLEAR_VARS := $(DROI_BUILD)/droi_clear_vars.mk
DROI_PREBUILD := $(DROI_BUILD)/droi_prebuild.mk

-include $(DROI_BUILD)/droi_defintions.mk

#DROI_PRODUCT:=$(shell echo $(TARGET_PRODUCT) | sed s/full_//g)

ifeq ($(DROI_PCBA_PRODUCT),)
$(warning PCBA_CUSTOM not be defined)
endif

ifneq ($(DROI_PCBA_PRODUCT),)
DROI_PRODUCT_DIRS := $(TOP)/$(DROI_TOP)/project/$(DROI_PCBA_PRODUCT)
else
DROI_PRODUCT_DIRS :=
endif
DROI_COMMON_DIRS := $(TOP)/$(DROI_TOP)/common

$(info DROI_PRODUCT_DIRS : $(DROI_PRODUCT_DIRS))
$(info DROI_COMMON_DIRS : $(DROI_COMMON_DIRS))
$(info ============================================)

common_dir_macro :=$(strip $(subst ./droi_src/common/, ,$(shell find ${DROI_COMMON_DIRS}/*  -maxdepth 0 -type d)))
common_dir_mk:=$(foreach cdm,$(common_dir_macro),$(shell if [ ! -z ${${cdm}} ];then \
		build/tools/findleaves.py ${DROI_COMMON_DIRS}/${cdm}/${${cdm}} droi.mk;fi))

$(info DROI_MODULE include Start...)
ifneq ($(DROI_PCBA_PRODUCT),)
droi_subdir_mk := \
	$(shell build/tools/findleaves.py --prune=build --prune=config_mk $(DROI_PRODUCT_DIRS) droi.mk)
endif

droi_subdir_mk := ${common_dir_mk} ${droi_subdir_mk}
ifeq ($(DROI_FC),update)
$(foreach mk, $(droi_subdir_mk), $(info including $(mk) ...)$(eval include $(mk))$(shell touch `dirname $(mk)`/*))
else
$(foreach mk, $(droi_subdir_mk), $(info including $(mk) ...)$(eval include $(mk)))
endif
$(info DROI_MODULE include Done.)
ALL_DROI_MODULE:=$(sort $(ALL_DROI_MODULE))
#ALL_MODULES += droimk

.PHONY:droimk
droid droidcore all_modules:droimk
	@echo 'BUILD_DONE=y' > $(DROI_ACTION_CFG)
$(DEPEND_ON_DROI_MODULE):droimk
droimk:$(ALL_DROI_MODULE)
	@echo [$(ALL_DROI_MODULE)] Done.
#$(ALL_DROI_MODULE):
#	cp -rf droi/test hardware/test
#$(info ALL_DROI_MODULE=$(ALL_DROI_MODULE))

