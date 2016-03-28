# Lab 3 Notes

## BUG

### '0' -> 0

数据段赋值时，误将'0'补至学生姓名之后,使得字符串比较异常

解决办法: 

-   'lancer0000' -> 'lancer', 4 DUP(0)
-   'saber00000' -> 'saber', 5 DUP(0)
