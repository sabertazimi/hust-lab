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

2. follow centos wiki

```sh
$ rpm -i http://vault.centos.org/6.6/updates/Source/SPackages/kernel-2.6.32-504.30.3.el6.src.rpm 2>&1 | grep -v exist
$ mkdir -p ~/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
$ echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros
$ cd ~/rpmbuild/SPECS
$ rpmbuild -bp --target=$(uname -m) kernel.spec
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
 
