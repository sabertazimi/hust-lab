# Hust Data Structure

*Don't Reserve a Copy for Your Own Homework - That's Cheating Behavior*

[![Author](https://img.shields.io/badge/author-sabertazimi-lightgrey.svg)](https://github.com/sabertazimi)
[![Build Status](https://travis-ci.org/sabertazimi/HustDataStructure.svg?branch=master)](https://travis-ci.org/sabertazimi/HustDataStructure)
[![License](https://img.shields.io/badge/license-HPL-blue.svg)](https://raw.githubusercontent.com/sabertazimi/HustDataStructure/master/LICENSE)
[![CLA assistant](https://cla-assistant.io/readme/badge/sabertazimi/HustDataStructure)](https://cla-assistant.io/sabertazimi/HustDataStructure)

**University Learning**

> 防止代码丢失，招致教师怨怼，你必须建立一个作业用repo -- 亚里士多德

## Directory

1.  Design : For curriculum design
2.  Lab : For daily lab on machine

## LICENSE

Homework Public License(HPL)

Copyright (c) 2016 Yilong Liu

This is for your reference only,not for your cheating -  Just don't be a dick.

Being a dick includes - but is not limited to - the following instances:

1.   Outright copyright infringement - Don't just copy this and change the name.
2.   Reserve a copy of this project and tell your teacher that it is your own homework - Plagiarism is shame.

If you become rich through modifications, related worksrvices, or supporting the original work, share the love. Only a dick would make loads off this work and not buy the original works creator(s) a pint.Code is provided with no warranty. Using somebody else's code and bitching when it goes wrong makes you a DONKEY dick. Fix the problem yourself. A non-dick would submit the fix back.

## Curriculum Design

### 任  务  书

#### 设计内容

传统队列是一种符合先插入的元素必须先删除（FIFO）的处理逻辑，这不总是满足应用要求；很多时候需要优先级高的任务先处理（即后插入的可能先删除）。
-   基于堆的概念设计优先级队列(Priority Queue)抽象数据类型，至少包含`Init_PriorityQue, Destroy_PriorityQue, Clear_PriorityQue，PriorityQue_Insert, PriorityQue_DeletMin, PriorityQue_Empty, PriorityQue_Full`等操作；
-   选择适当的物理存储结构实现优先级队列ADT;
-   应用优先级队列ADT设计与实现一个医院门诊医师与病人看诊服务事件仿真程序，使医师服务效率尽量高。

#### 设计要求

-   仿真事件（如病人到达，病情复杂度/就诊时间，病人离开等）可根据某种概率分布或随机模型生成；
-   要求对各种算法进行理论分析，同时也对实测结果进行统计分析。测试数据要求有一定规模；
-   要求界面整洁、美观，操作方便。

#### 参考文献

-   \[1]  严蔚敏, 吴伟民. 数据结构（C语言版）. 北京: 清华大学出版社,1997
-   \[2]  严蔚敏, 吴伟民, 米宁. 数据结构题集（C语言版）. 北京: 清华大学出版社,1999
-   \[3]  Mark Allen Weiss.Data Structures and Algorithm Analysis, 机械工业出版社，2010

### 系统需求与总体分析

#### 系统需求分析

本系统为借助基于堆的优先级队列模拟医生诊病模拟程序。

该模拟程序大致分为三个模块：病人入列、病人出列、更新优先级。

建立以病人为基本元素的优先级队列，根据病人的到达时间、患病等级、门诊时长、预计离开时间相关数据结合相关算法计算出病人的优先级。

构造病人随机生成器，随机生成患病等级、门诊时长、预计离开时间具有差异的病人，使生产的病人进入优先级队列(病人到达医院)，并由高到低进行优先级排序。

病人离开优先级队列，分为两种情况：
-   第一，病人的预计离开时间已到达，病人未接受门诊检查，此时，无视医生的状态(忙/空闲)，病人将以未检查的状态离开队列；
-   第二，上一病人门诊检查结束，医生状态变为空闲，此时队列中的队首病人(也是优先级最高的病人)将离开队列，接受门诊检查。以上两种情况发生后，都需对队列中剩余病人由高到低进行优先级排序。

由于优先级受时间因素影响较大，故随着时间的推移，定时地对队列中等待接受门诊检查的病人进行优先级的重新计算。

本系统需满足以上功能，才能视作一个功能完整的模拟程序。
####  系统总体分析

本系统分为四大模块：排序模块、队列模块、信息模块、模拟模块。

-   排序模块：利用堆排序算法对数组进行降序排序；
-   队列模块：实现队列基本操作如初始化、销毁、插入、删除等；
-   信息模块：时间信息与日志信息；
-   模拟模块：实现病人生成器、优先级计算器、优先级更新器、状态检查器等。

### 总结与展望

#### 全文总结

-   复杂度分析

运用自顶向下，分模块编写的方式，使得编码难度大幅度下降，并优雅地设计模块，降低了各模块的耦合度，并提高了代码的复用性。

-   系统特色

本系统绝大部分数据都具有随机性，形成一个随机模拟程序；
本系统采用单元测试、断言测试、持续集成系统、模拟测试等多种方法进行测试，大幅度增强了系统的健壮性。

#### 工作展望

今后希望能够学习更加高级的数据结构，并将其运用到项目构建上。

### 体会

(1)初次尝试使用版本管理系统管理代码。由于是个人项目的原因，本次课程设计没有机会体会Git作为分布式版本管理系统对于团队协作效率的提升。但通过一次次的commit message，良好地控制了本次课程设计的完成进度，并有效地促使自己尽可能规范化地提交代码，大幅度地提升了编程效率与代码质量；

(2)借助Travis CI持续集成系统，并编写测试代码与测试脚本，成功地实现了测试自动化流程，深深地体会到了测试也是一门大学问；

(3)通过云服务器部署代码进行长时间测试，大幅度地提升了模拟程序的健壮性，是一次有益的尝试；

(4)通过此次课程设计，有效地掌握了堆排序算法以及优先级队列这一数据结构，收获颇丰。

## Daily Lab

## Contact

-   e-mail: sabertazimi@gmail.com
-   QQ && WeChat: 2426543832
