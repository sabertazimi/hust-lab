# Hust OS Final Project Notes

## Proj 1-2 : Multi-Process Qt Windows

### Set Up

```sh
$ sudo apt install ubuntu-sdk
```

### Environment

*   Ubutnu 16.04
*   Atom Editor v1.13.0
*   Qt 5.5.1
*   Qt Creator 3.5.1
*   FakeVim 3.5.1 Plugin
*   git 2.11.0

### Reference

*   [Qt Quick Tutorial](https://www.gitbook.com/book/wizardforcel/qt-beginning/details)

## Proj2 : Build Your Own Kernel

### ssh

```sh
$ ssh -p 29692 root@23.106.150.152
```

### build tools

#### basic

*   gcc --version
*   ld -v (binutils)
*   make --version
*   fdformat --version (util-linux)
*   depmod --version (module-init-tools)
*   tune2fs (e2fsprogs)
*   quota --version
*   udev
*   pccardctl --version (pcmciautils)

```sh
$ sudo yum install -y gcc binutils make util-linux module-init-tools e2fsprogs quota udev pcmciautils
```

#### centos

```sh
$ sudo yum install -y ncurses-devel hmaccalc zlib-devel binutils-devel elfutils-libelf-devel
$ sudo yum install -y rpm-build redhat-rpm-config asciidoc hmaccalc perl-ExtUtils-Embed xmlto
$ sudo yum install -y audit-libs-devel binutils-devel elfutils-devel elfutils-libelf-devel
$ sudo yum install -y newt-devel python-devel zlib-devel
```

### retrieving the kernel source

1. check os version and kernel version

```sh
$ cat /etc/redhat_release # centos 6.6
$ uname -a                # kernel-2.6.32
```

2. from kernel.org

```sh
$ wget https://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.32.27.tar.gz
```

3. follow centos wiki

```sh
$ rpm -i http://vault.centos.org/6.6/updates/Source/SPackages/kernel-2.6.32-504.30.3.el6.src.rpm 2>&1 | grep -v exist
$ mkdir -p ~/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
$ echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros
$ cd ~/rpmbuild/SPECS
$ rpmbuild -bp --target=$(uname -m) kernel.spec
```

4. follow ppt , Ubuntu 14.04 on VirtualBox

*   owing to above failure, current proceeding got speed up by writing kernel make shell script - kernel.sh

### add syscall

#### 2.x

*   kernel/sys.c
*   arch/x86/kernel/syscall_table_32.S
*   arch/x86/include/asm/unistd_32.h

#### 4.x

*   linux-4.x/arch/x86/entry/syscalls/syscall_64.tbl
*   linux-4.x/include/linux/syscalls.h

```sh
$ sudo mkdir linux-4.x/dragoncopy
$ sudo vi dragoncopy/dragoncopy.c
$ sudo vi dragoncopy/Makefile
```

```c
#include <linux/kernel.h>   // printk
#include <linux/syscalls.h>

asmlinkage long sys_dragoncopy(const char *src, const char *dst) {
    // copy file
    printk("Dragon copy file success.\n");

    // 0 for success
    return 0;
}
```

```makefile
obj-y := dragoncopy.o
```

```sh
$ sudo vi linux-4.x/Makefile
```

```makefile
core-y := usr/ dragoncopy/
```

```sh
$ (sudo) make bzImage -j 4 && make modules -j 4 && make modules_install -j 4 && make install -j 4 && update-grub
$ (sudo) reboot
```

```c
// test for dragoncopy
#include <unistd.h>

int main(void) {
    syscall(syscall_number, arg0, arg1, ...);
    return 0;
}
```

### build and install kernel

```sh
# make mrproper  // 清理以前的编译痕迹
# make clean
# cp /boot/config-`uname -r` .config  // 设置内核编译选项
# make menuconfig  // 执行该命令需要ncurses库
# make bzImage  // 编辑内核压缩镜像
# make modules  // 编辑内核模块
# make modules_install  // 安装内核模块
# make install  // 安装内核
# reboot
```

### test

```c
#include <stdio.h>

int main(void) {
    syscall(338, 1);
    return 0;
}
```

```sh
$ gcc -o syscall_test syscall_test.c
$ ./syscall_test
$ dmesg -c
```

### kernel config

```sh
$ cp ~/rpmbuild/BUILD/kernel-*/linux-*/configs/* ~/rpmbuild/SOURCES/
```

### kernel spec

```sh
$ cd ~/rpmbuild/SPECS
$ cp kernel.spec kernel.spec.distro
$ vi kernel.spec
```

### compile kernel

```sh
$ rpmbuild --without kabichk -bb --target=`uname -m` kernel.spec 2> build-err.log | tee build-out.log 
```

### install kernel

```sh
$ cd ~/rpmbuild/RPMS/`uname -m`/
$ su
# yum localinstall kernel-*.rpm
```

### change kernel

如果你想加入任何内核的修正，请于现在复制它们到你的 ~/rpmbuild/SOURCES/ 目录内

### Reference

*   Linux Kernel in a Nutshell
*   [Centos Wiki](https://wiki.centos.org/zh/HowTos/Custom_Kernel)
*   [Ubuntu Wiki](https://wiki.ubuntu.com/Kernel/BuildYourOwnKernel)
*   [3.8.x Syscall Video](https://www.youtube.com/watch?v=5rr_VoQCOgE)
*   [Build Kernel](https://medium.freecodecamp.com/building-and-installing-the-latest-linux-kernel-from-source-6d8df5345980#.785wm13ax)
*   [Add Syscall](https://medium.com/@ssreehari/implementing-a-system-call-in-linux-kernel-4-7-1-6f98250a8c38#.adur4b62w)
 
## Proj3 - Device Driver

*   file_operatons - open, release, read, write
*   module_init/module_exit
*   insnod/rmnod
*   mknod

### Makefile

```sh
$ make
$ make install
$ make showdev
$ sudo mknod /dev/$(DEVICE_NAME) c $(DEVICE_NUM) 0
```

