#
# Makefile
# sabertazimi, 2017-03-01 08:45
#

DEVICE_NAME=dragondevice

ifneq ($(KERNELRELEASE),)
	obj-m := $(DEVICE_NAME).o
else
	KERNELDIR ?= /lib/modules/$(shell uname -r)/buildMAKE
	PWD := $(shell pwd)

default:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

install:
	sudo insmod $(DEVICE_NAME).o

uninstall:
	sudo rmmod $(DEVICE_NAME)

clean:
	rm -fr *.o *.ko .*.cmd *.mod.c .tmp_versions

# vim:ft=make
#
