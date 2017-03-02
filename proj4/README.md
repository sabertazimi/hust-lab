# electron-taskmanager

A task manager baed on Electron

## Installation

```sh
$ sudo apt install nodejs npm
$ sudo npm install -g cnpm
```
## Development

```sh
$ cnpm install
$ cnpm start
```

## /proc notes

```sh
$ whatis proc
# => proc (5) 进行信息伪文件系统

$ man 5 proc
# refer to /proc manual page
```

```sh
$ ps
# => 17465 zsh
```

* `/proc/[0-9]*` 为进程信息目录

> `/proc/233`

* `/proc/[0-9]*/cmdline` 为进程启动的命令行程序完整路径

```sh
$ cat /proc/17465/cmdline
# => /usr/bin/zsh
```

* `/proc/[0-9]*/stat` 进程状态信息, 被命令 ps(1) 使用

```sh
$ cat / proc/17465/stat
```

* `/proc/[0-9]*/statm`

```sh
$ getconf PAGE_SIZE
# => 4096
```

* `/proc/[0-9]*/io`

* `/proc/cpuinfo` CPU 信息

* `/proc/meminfo` 内存使用信息

* `/proc/stat` 内核及系统的统计数据

## License

MIT License Copyright (c) 2017 [sabertazimi](https://github.com/sabertazimi)

## Contact

* [![Email](https://img.shields.io/badge/mailto-sabertazimi-brightgreen.svg?style=flat-square)](mailto:sabertazimi@gmail.com)
* [![GitHub](https://img.shields.io/badge/contact-github-000000.svg?style=flat-square)](https://github.com/sabertazimi)
* [![Twitter](https://img.shields.io/badge/contact-twitter-blue.svg?style=flat-square)](https://twitter.com/sabertazimi)

