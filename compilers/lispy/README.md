# lispy

A simple lisp interpreter.

## Installation

```sh
$ sudo apt-get install libedit-dev
```

## Libs

目前有两种方式实现库函数:

*   在 `lval_eval.c` 中注册新的 `builtin_xxx` 函数, 通过操作 `lval_list` 实现库函数
*   在 `lispy.c` 中利用 `mpc_parse` 方法, 通过编写 lisp 代码的方式, 自定义一些库函数
*   法一可以用于编写大部分方法, 但编写高级方法时可能造成链表操作过于复杂
*   法二通过编写 lisp 函数式代码的方式, 可以使用极少量的代码实现库函数, 但其无法实现过于底层的库函数(e.g head)

