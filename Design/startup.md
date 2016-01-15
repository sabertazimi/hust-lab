#### Function
1. 保存
2. 读取
3. 创建

#### File Structure
1. time.ini
        - set current time
2. sick.ini
        - set priority
        - simulation data
3. config.ini

#### Key
1. 优先级算法
        - 就诊时间正比
        - 快离开病人优先级高
        - boolIsTreating

#### Algrithms
1. empty() 如果队列为空返回真
2. pop() 删除对顶元素
3. push() 加入一个元素
4. size() 返回优先队列中拥有的元素个数
5. top() 返回优先队列对顶元素

#### Testing
1. Log(Enum//define log information type e.g Prompt, Record, FILE*, argument,...)
2. 测试时长
        - 1h
        - 3h
        - 9h
        - 24h
