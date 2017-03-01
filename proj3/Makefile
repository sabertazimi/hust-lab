#
# Makefile
# sabertazimi, 2017-03-01 08:45
#

DEVICE_NAME=dragondev

ifneq ($(KERNELRELEASE),)
	obj-m := $(DEVICE_NAME).o
else
	KERNELDIR ?= /lib/modules/$(shell uname -r)/build
	PWD := $(shell pwd)
default:
	sudo cp -fr $(DEVICE_NAME).c /usr/src/linux-headers-$(shell uname -r)/drivers/misc
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules
endif

obj-m += $(DEVICE_NAME).o

install:
	sudo insmod $(DEVICE_NAME).ko

showdev:
	cat /proc/devices | grep $(DEVICE_NAME)
	ls -alh /dev/$(DEVICE_NAME)

# mknod:
# mknod /dev/$(DEVICE_NAME) c $(DEVICE_NUM) 0

uninstall:
	sudo rmmod $(DEVICE_NAME)

clean:
	rm -fr *.o *.ko .*.cmd *.mod.c .tmp_versions modules.order Module.symvers
	sudo rm -fr /dev/$(DEVICE_NAME)

test:
	gcc -Wall -Wextra -o $(DEVICE_NAME)_test $(DEVICE_NAME)_test.c
	sudo ./$(DEVICE_NAME)_test

# vim:ft=make
#
