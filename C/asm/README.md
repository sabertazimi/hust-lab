一、文件说明：
sas.exe       编译器:第二参数为汇编源程序文件名，第三参数为目标代码文件名
ssim.exe      模拟器:第二参数为模拟内存大小(十进制/十六进制)，第三参数为目标代码文件名
TestCase.txt  按照课程设计教材中定义的简单计算机指令系统编写的测试用汇编源程序

二、使用说明：
1. 将上述三个文件放至同一目录X:\
2. 在命令行中找到该目录X:\
3. 用编译器sas.exe将汇编源程序TestCase.txt转化成目标代码TestCase.dat    
        X:\>sas TestCase.txt TestCase.dat↙
4. 用模拟器ssim.exe载入并运行目标代码TestCase.dat
        X:\>ssim 0x1000 TestCase.dat↙