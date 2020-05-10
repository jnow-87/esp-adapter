#
# Copyright (C) 2020 Jan Nowotsch
# Author Jan Nowotsch	<jan.nowotsch@gmail.com>
#
# Released under the terms of the GNU GPL v2.0
#



bin-y := init.elf


init-y := main.o


init-cppflags := \
	-I$(loc_src_tree)


-include $(brickos_build)/sys/devicetree.make

init-ldlibs := \
	-L$(sysroot)/linker/$(CONFIG_ARCH)/ \
	-L$(sysroot)/linker/ \
	-T$(CONFIG_ARCH)_memory.lds \
	-Tapp_$(CONFIG_ARCH).lds \
	-Wl,--section-start=.text=$(DEVTREE_APP_FLASH_BASE) \
	-Wl,--section-start=.data=$(DEVTREE_APP_DATA_BASE) \
	-lsys \
	-lgcc


# ensure init is rebuild if libsys is updated
init-y += $(brickos_libsys)
