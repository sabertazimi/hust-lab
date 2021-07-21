# dinux

[![Author](https://img.shields.io/badge/author-sabertaz-lightgrey?style=for-the-badge)](https://github.com/sabertazimi)
[![LICENSE](https://img.shields.io/github/license/sabertazimi/dinux?style=for-the-badge)](https://raw.githubusercontent.com/sabertazimi/dinux/master/LICENSE)

```sh
     _ _
  __| (_)_ __  _   ___  __
 / _` | | '_ \| | | \ \/ /
| (_| | | | | | |_| |>  <
 \__,_|_|_| |_|\__,_/_/\_\
```

A toy operating system

## Installation

```sh
$ sudo apt install libc6-dev-i386 build-essential
$ sudo apt install nasm qemu bochs
```

```sh
$ wget http://alpha.gnu.org/gnu/grub/grub-0.97-i386-pc.tar.gz
$ tar xzvf grub-0.97-i386-pc.tar.gz
$ dd if=/dev/zero of=floppy.img bs=512 count=2880
$ mkfs.vfat floppy.img
$ sudo mount floppy.img /mnt/dinux
$ sudo mkdir -p /mnt/dinux/boot/grub
$ sudo cp -fr grub-0.97-i386-pc/boot/grub/stage1 grub-0.97-i386-pc/boot/grub/stage2 /mnt/dinux/boot/grub
$ sudo vim /mnt/dinux/boot/grub/grub.conf
```

## Bootloader/Grub

利用现成的 bootloader - grub 可以不用编写 **A20开启** 与 **内核装载** 的代码, grub 将 kernel 加载进内核后, 整个计算机处于:

*   A20 开启
*   段/页机制关闭

## CGA/VGA Text Memory

通过向物理地址(最低 1MB) 0x8b000 写数据, 可实现简单的打印字符功能. 从 0x8b000 开始将其视为一个 元素为 2 字节数据, 大小为 25*80 的二维数组. 数组元素所包含信息如下所示:

*   (hi -> lo) 4 - 4 - 8: background_color - foreground_color - character_ascii

## TODO

* [] virtual memory management
* [] file system

## Thanks

*   hurlex
*   jamesmolloy

## License

MIT License Copyright (c) 2017 [sabertazimi](https://github.com/sabertazimi)

## Contact

[![Email](https://img.shields.io/badge/-Gmail-ea4335?style=for-the-badge&logo=gmail&logoColor=white)](mailto:sabertazimi@gmail.com)
[![Twitter](https://img.shields.io/badge/-Twitter-1da1f2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/sabertazimi)
[![GitHub](https://img.shields.io/badge/-GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/sabertazimi)
