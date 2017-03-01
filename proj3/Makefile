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
	sudo rm -fr /usr/src/linux-headers-$(shell uname -r)/drivers/misc/$(DEVICE_NAME).c
	sudo cp -fr $(DEVICE_NAME).c /usr/src/linux-headers-$(shell uname -r)/drivers/misc
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules
endif

obj-m += $(DEVICE_NAME).o

install:
	sudo insmod $(DEVICE_NAME).ko

showdev:
	cat /proc/devices | grep $(DEVICE_NAME)
	ls -alh /dev/$(DEVICE_NAME)

showmsg:
	dmesg -c | grep Dragon

# mknod:
# mknod /dev/$(DEVICE_NAME) c $(DEVICE_NUM) 0

uninstall:
	sudo rm -fr /dev/$(DEVICE_NAME)
	sudo rmmod $(DEVICE_NAME)

clean:
	sudo rm -fr /dev/$(DEVICE_NAME)
	rm -fr *.o *.ko .*.cmd *.mod.c .tmp_versions modules.order Module.symvers

test:
	gcc -Wall -Wextra -o $(DEVICE_NAME)_test $(DEVICE_NAME)_test.c
	sudo ./$(DEVICE_NAME)_test

# vim:ft=make
#
