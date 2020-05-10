#
# Copyright (C) 2016 Jan Nowotsch
# Author Jan Nowotsch	<jan.nowotsch@gmail.com>
#
# Released under the terms of the GNU GPL v2.0
#



################
###   init   ###
################

####
## build system config
####


# build system variables
scripts_dir := scripts/build
project_type := c
config := .config
config_tree := scripts/config
use_config_sys := y
config_ftype := Pconfig
githooks_tree := .githooks

# source- and build-tree
default_build_tree := build
src_dirs := main/

# brickos dependencies
brickos_root := brickos
brickos_build := $(brickos_root)/recent
sysroot := $(brickos_build)/sysroot

brickos_kernel := $(sysroot)/kimg.elf
brickos_libsys := $(sysroot)/lib/libsys.a


####
## include build system Makefile
####

include $(scripts_dir)/Makefile.inc


####
## flags
####

cflags := \
	$(CFLAGS) \
	$(CONFIG_CFLAGS) \
	$(cflags) \
	-Wall \
	-Wextra \
	-Wshadow \
	-Wno-unused-parameter \
	-Wno-unused-label \
	-Wno-unknown-pragmas \
	-nostdinc \
	-fno-builtin \
	-fshort-enums \
	-flto

cxxflags := \
	$(CXXFLAGS) \
	$(CONFIG_CXXFLAGS) \
	$(cxxflags) \
	-Wall \
	-Wextra \
	-Wshadow \
	-Wno-unused-parameter \
	-Wno-unused-label \
	-Wno-unknown-pragmas \
	-nostdinc \
	-fno-builtin \
	-fshort-enums \
	-flto

cppflags := \
	$(CPPFLAGS) \
	$(CONFIG_CPPFLAGS) \
	$(cppflags) \
	-std=gnu99 \
	-I"$(sysroot)/usr/include/" \
	-I"$(sysroot)/usr/include/lib" \
	-I"$(build_tree)/" \
	-DBUILD_ARCH_HEADER="$(CONFIG_ARCH_HEADER)"

ldlibs := \
	$(LDLIBS) \
	$(CONFIG_LDLIBS) \
	$(ldlibs) \
	-nostartfiles \
	-nostdlib \
	-static \
	-L$(sysroot)/lib/

ldflags := \
	$(LDFLAGS) \
	$(CONFIG_LDFLAGS) \
	$(ldflags)

asflags := \
	$(ASFLAGS) \
	$(CONFIG_ASFLAGS) \
	$(asflags)

archflags := \
	$(ARCHFLAGS) \
	$(CONFIG_ARCHFLAGS) \
	$(archflags)


####
## arch-dependent include
####

include Makefile.$(CONFIG_ARCH)


###################
###   targets   ###
###################

####
## main
####

.PHONY: all
ifeq ($(CONFIG_BUILD_DEBUG),y)
  cflags += -g
  cxxflags += -g
  asflags += -g
  ldlibs += -g
endif

all: $(lib) $(hostlib) $(bin) $(hostbin)


####
## brickos
####

brickos_config := $(brickos_root)/.config
brickos_dev_tree := $(brickos_root)/custom.dts


$(brickos_config): $(CONFIG_BRICKOS_CONFIG)
	$(echo) updating brickos configuration
	$(cp) $(CONFIG_BRICKOS_CONFIG) $@

$(brickos_dev_tree): $(CONFIG_DEVICE_TREE)
	$(echo) updating brickos device tree
	$(cp) $(CONFIG_DEVICE_TREE) $@

.PHONY: brickos
brickos: $(brickos_config) $(brickos_dev_tree)
	$(echo) building brickos
	@make -C brickos sysroot

# ensure brickos is build as prerequisite
prepare_deps: brickos


####
## cleanup
####

.PHONY: clean
clean:
	$(rm) $(filter-out $(patsubst %/,%,$(dir $(build_tree)/$(scripts_dir))),$(wildcard $(build_tree)/*))
	$(rm) $(brickos_config) $(brickos_dev_tree)
	@make -C brickos clean

.PHONY: distclean
distclean: clean
	$(rm) $(config) $(config).old $(build_tree)
	@make -C brickos distclean
