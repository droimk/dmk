################################################################################
#huangjun @ 2015/09/15
# v01
################################################################################

-include ./droi_src/build/droi_defintions.mk

DROI_CMK_HOME := $(DROI_TOP)/project/$(DROI_PCBA_PRODUCT)/config_mk
-include $(DROI_CMK_HOME)/droi.mk

DROI_PWD_F:=$(filter $(shell pwd)/%,$(subst :, ,$(DROI_NEED_REPLACE_MK)))
ifneq ($(DROI_PWD_F),)
$(error DROI_MODULE_PRECOPY Forbid using PWD path!!! =>$(DROI_PWD_F))
endif

DROI_TEST_OUT_DIR:=$(filter out/%,$(subst :, ,$(DROI_NEED_REPLACE_MK)))
DROI_TEST_OUT_DIR+=$(filter ./out/%,$(subst :, ,$(DROI_NEED_REPLACE_MK)))
DROI_TEST_OUT_DIR:=$(strip $(DROI_TEST_OUT_DIR))

ifneq ($(DROI_TEST_OUT_DIR),)
$(error DROI_MODULE_PRECOPY Forbiding add out dir!!!!at [$(DROI_TEST_OUT_DIR)])
endif

KDEFINE=$(shell droi_src/build/exp_pcba_macro.sh $(DROI_PCBA_PRODUCT))
ifeq ($(DROI_FC),)
DROI_FC:=$(shell cat $(DROI_ACTION_CFG) 2>&1)
DROI_FC:=$(findstring BUILD_DONE=y,$(DROI_FC))
ifeq ($(DROI_FC),)
DROI_FC:=update
endif
endif
ifeq ($(DROI_FC),update)
droi_l_update:=-f
else
droi_l_update:=-uf
endif
DROI_SHELL_RET:=$(foreach rule,$(DROI_NEED_REPLACE_MK),$(info [DROI PRECOPY] $(droi_l_update)\
	$(DROI_CMK_HOME)/$(subst :, ====> ,$(rule)))\
	$(if $(findstring ProjectConfig.mk,$(rule)),$(shell droi_src/build/mcp.sh $(DROI_CMK_HOME)/$(subst :, ,$(rule))  2>&1),$(shell cp $(droi_l_update) $(DROI_CMK_HOME)/$(subst :, ,$(rule)) 2>&1)))
DROI_SHELL_RET:=$(strip $(DROI_SHELL_RET))
ifneq ($(DROI_SHELL_RET),)
$(error DROI_MODULE_PRECOPY $(DROI_SHELL_RET))
endif

$(info [DROI PRECOPY] Done.)
