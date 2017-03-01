#! /bin/bash
#
# kernel.sh
# Copyright (C) 2017 sabertazimi <sabertazimi@avalon>
#
# Distributed under terms of the MIT license.
#

# exec under /usr/src

# cd /usr/src
# su root
# wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.4.31.tar.gz
# tar -zxvf linux-4.4.31.tar.gz
# cd linux-4.4.31/

apt-get install libncurses5-dev libssl-dev
make mrproper           # 清除旧的编译内容
make menuconfig         # 编译新内核的配置文件
make bzImage -j 4 && make modules -j 4 && make modules_install -j 4 && make install -j 4

# comments GRUB_HIDDEN_OUT = 0 out in /etc/default/grub
# update-grub             # 更新引导文件
# reboot                  # 重新启动

