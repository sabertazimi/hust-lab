# Packet Tracer Basic Notes

## Basis

### Operation

*   Ctrl + click on components
*   相同设备交叉线, 不同设备直通线 特例: router pc 间用交叉线
*   DCE 端设置 clock rate

## lab1

由于右边的网络只有 1 个可用路由器端, 且只有 1 个可用 vlan 端口, 无法添加 2 条路由(192.168.1.0 192.168.2.0)

当

```sh
enable
config t
int fa0/1
no shut
exit
int fa0/1.1
encap dot1q 1
ip add 192.168.1.1 255.255.255.0
exit
exit
```

时, 左边 pc 可以与 192.168.1.0 子网 pc 通信, 但无法与 192.168.2.0 子网 pc 通信(已无可用路由)

##　lab2

*   不设置时钟频率无法 up 串行端口

## lab3

route 与右边第一个路由器的连接也须改为 trunk mode

在 route 上

```sh
int fa0/1.1
encap dot1q 2
ip add 192.168.1.1 255.255.255.0
exit
int fa0/1.2
encap dot1q 3
ip add 192.168.2.1 255.255.255.0
exit
```
