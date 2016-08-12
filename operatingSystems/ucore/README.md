
* [Notes for ucore os lab](#notes-for-ucore-os-lab)
	* [Set up](#set-up)
	* [Contact](#contact)

# Notes for ucore os lab

## Set up

```shell
$ sudo apt-get install meld qemu
$ sudo apt-get doxygen doxygen-gui graphviz
```

### doxygen

在代码根目录:

```shell
$ doxygen -g
$ cim Doxyfile
```

```config
OPTIMIZE_OUTPUT_FOR_C
OPTIMIZE_OUTPUT_JAVA
OPTIMIZE_FOR_FORTRAN
OPTIMIZE_OUTPUT_VHDL

GENERATE_HTML
GENERATE_LATEX
GENERATE_RTF
GENERATE_XML
GENERATE_DOCBOOK
GENERATE_MAN

HAVE_DOT YES
DOT_NUM_THREADS 4
```

```shell
doxygen
```


-   MIPS emulator

```shell
$ sudo apt-get install spim
```

## Contact

-   [![Email](https://img.shields.io/badge/mailto-sabertazimi-brightgreen.svg?style=flat-square)](mailto:sabertazimi@gmail.com)
-   [![GitHub](https://img.shields.io/badge/contact-github-000000.svg?style=flat-square)](https://github.com/sabertazimi)
-   [![Twitter](https://img.shields.io/badge/contact-twitter-blue.svg?style=flat-square)](https://twitter.com/sabertazimi)    
