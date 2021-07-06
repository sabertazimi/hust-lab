# hust-sdn

Hust SDN Lab

## Mininet

```bash
# kill network
sudo mn -c
```

## 二层转发

### 传统交换机

- 提取数据报的源MAC地址，查询MAC转发表（也就是L2FDB），如果找到就直接发送到对应端口
- 对于表中不包含的地址，通过广播发送，也就是发送到所有端口
- 使用地址自动学习（根据源MAC地址学习）和老化机制（定时机制）来维护MAC转发表的信息，二层转发一般不会更改数据包内容

### SDN

- Echo Request 是 OSVKernelSwitch (127.0.0.1:36716)
  发给 POX Controller (127.0.0.1:6633） 的
- Controller 是用 TCP 6633 这个端口来控制交换机，
  为了监控交换机和 Controller 之间的连通性，
  Controller 收到 Echo Request 包后会向交换机返回一个 Echo Reply 包
- 除此之外，向流表中添加相关项，使得交换机下一次学会该将 ICMP 发送至哪个端口
