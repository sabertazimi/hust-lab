#! /bin/bash
#
# kernel.sh
# Copyright (C) 2017 sabertazimi <sabertazimi@avalon>
#
# Distributed under terms of the MIT license.
#

# exec under /usr/src

# su root
# wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.4.31.tar.gz
# tar -zxvf linux-4.4.31.tar.gz
# cd linux-4.4.31/

apt-get install libncurses5-dev
make mrproper           # 清除旧的编译内容
make menuconfig         # 编译新内核的配置文件
make bzImage            # 生成新的内核镜像
make modules            # 编译模块
make modules_install    # 安装模块
make install            # 安装内核

# update-grub             # 更新引导文件
# reboot                  # 重新启动

