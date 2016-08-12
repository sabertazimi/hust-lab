
* [ICS 2015 Programming Assignment](#ics-2015-programming-assignment)
	* [Notes](#notes)
		* [Basic](#basic)
			* [Set up](#set-up)
			* [Basic Tools](#basic-tools)
		* [PA 1 - Simple debugger notes](#pa-1---simple-debugger-notes)
			* [Useful function](#useful-function)
			* [Basic idea](#basic-idea)
				* [ String manipulation algorithms](#-string-manipulation-algorithms)
				* [Workflow](#workflow)
	* [Samples](#samples)
	* [License](#license)
	* [Contact](#contact)

# ICS 2015 Programming Assignment

[![Author](https://img.shields.io/badge/author-sabertazimi-lightgrey.svg)](https://github.com/sabertazimi)
[![Stable](https://img.shields.io/badge/stability-stable-brightgreen.svg)](https://github.com/sabertazimi/os-nemu)
[![Lab](https://img.shields.io/badge/lab-os-006b75.svg)](https://github.com/sabertazimi/os-nemu)
[![MIT](https://img.shields.io/badge/license-mit-brightgreen.svg)](https://raw.githubusercontent.com/sabertazimi/os-nemu/master/LICENSE)

## Notes

### Basic

#### Set up

-   install dependencies

```shell
git clone https://github.com/nju-ics/ics2015
sudo apt-get install libreadline-dev build-essential gcc-doc gdb git time
```

-   remove git commit tracker

```shell
rm -fr config/Makefile.git
```

#### Basic Tools

```shell
make clean
make gdb
make cpp
make clean-cpp
make run
make submit
```

### PA 1 - Simple debugger notes

#### Useful function

-   man readline
-   man strtok
-   man str*
-   man sscanf

#### Basic idea

#####  String manipulation algorithms

-   正则表达式
-   词法解析
-   strtok
-   sscanf
-   str*

##### Workflow

make tokens -> build token tree by priority -> recursive evaluation

## Samples

-   https://github.com/autumn-wind/ics2015
-   https://github.com/ensigma96/ics2015
-   https://github.com/nickjerry/PA

## License

MIT License Copyright (c) 2016 [sabertazimi](https://github.com)

## Contact

-   [![Email](https://img.shields.io/badge/mailto-sabertazimi-brightgreen.svg?style=flat-square)](mailto:sabertazimi@gmail.com)
-   [![GitHub](https://img.shields.io/badge/contact-github-000000.svg?style=flat-square)](https://github.com/sabertazimi)
-   [![Twitter](https://img.shields.io/badge/contact-twitter-blue.svg?style=flat-square)](https://twitter.com/sabertazimi)    
