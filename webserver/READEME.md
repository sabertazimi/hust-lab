# web server

A simple web server based on Qt

[![Author](https://img.shields.io/badge/author-sabertazimi-lightgrey.svg)](https://github.com/sabertazimi)
[![Stable](https://img.shields.io/badge/stability-stable-brightgreen.svg)](https://github.com/sabertazimi/Awesome-Notes)
[![MIT](https://img.shields.io/badge/license-mit-brightgreen.svg)](https://raw.githubusercontent.com/sabertazimi/Awesome-Notes/master/LICENSE)

## Installation

*   MinGW / Visual Studio (Provide C/C++ Compiler)
*   CMake
*   Qt 5.8 Tool Chain

## Window Socket API

### bind (P12)

对TCP/IP协议，用如下结构来定义地址和端口。

```cpp
struct sockaddr_in {
    short           sin_family;
    u_short         sin_port;
    struct  in_addr sin_addr;
    char            sin_zero[8];
};
```

```cpp
struct in_addr {
   union {
     struct { u_char s_b1,s_b2,s_b3,s_b4; } S_un_b;
     struct { u_short s_w1,s_w2; } S_un_w;
     u_long S_addr;
 } S_un;
};
```

### accept

*   如果函数执行成功，会建立并返回一个新的SOCKET来与对方通信，新建的SOCKET与原来的SOCKET（函数的第一个参数s）有相同的特性，包括端口号
*   原来的SOCKET继续等待其他的连接请求。而新生成的SOCKET才是与客户端通信的实际SOCKET
*   一般将参数中的SOCKET称作“监听”SOCKET，它只负责接受连接，不负责通话；而对于函数返回的SOCKET，把它称作“会话”SOCKET，它负责与客户端通话

## License

MIT License Copyright (c) 2017 [sabertazimi](https://github.com/sabertazimi)

## Contact

-   [![Email](https://img.shields.io/badge/mailto-sabertazimi-brightgreen.svg?style=flat-square)](mailto:sabertazimi@gmail.com)
-   [![GitHub](https://img.shields.io/badge/contact-github-000000.svg?style=flat-square)](https://github.com/sabertazimi)
-   [![Twitter](https://img.shields.io/badge/contact-twitter-blue.svg?style=flat-square)](https://twitter.com/sabertazimi)

