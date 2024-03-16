# Dragon Language Specification

## Declaration

```java
// defination section(without initialization)
...

// initialization section
...

// other sections
...
```

## Variable

### String

只存在字符串常量

### Array

```java
int[][] arr;
arr = new int[][10];
```

## Function

```java
// function defination
int sayHelloFunc = (void) => {
    Print("Hello World!\n");
    return 0;
};
```

## Scope

*   局部变量不可与函数参数重名
*   局部域({}, including FuncDef) 不可有重名变量
*   局部域间的生命周期不同

## OOP

*   所有 varField 为私有域
*   所有 methodField 为公有域
*   不支持方法重载
*   支持方法重写
*   所有方法均为虚方法

```java
Computer pc;
pc = new Mac();
pc.crash();     // => "Mac crash!"
```
