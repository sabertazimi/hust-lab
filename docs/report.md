# Lab 1 Notes

## Compile and Link

*   change -lpthread to -pthread

## ipcs and ipcrm

```sh
# show share memory
$ ipcs -m

# show sem ipc
$ ipcs -s

# remove share memory
$ ipcrm -m shmid

# remove sem ipc
$ ipcrm -s semid

# remove all
$ ipcrm --all=shm
$ ipcrm --all=sem
```

## `key_t` key

对于同一个 key, 在同一进程组中, 调用 semget/shmget 函数所产生的 IPC 信号量为同一个 IPC 信号量:

*   若 semflags/shmflags 中含有 `IPC_CREAT | IPC_EXCL`, 则会创建失败, 函数返回 -1
*   若 semflags/shmflags 不含有 `IPC_EXCL` , 则函数会返回已创建 IPC 信号量的 id
*   可以通过对于同一 key, 改变 flags 的方法, 灵活操控 semget/shmget 函数, 以达到创建/获取特定 IPC 信号量的目的, 使得进程间能够进行信息交流

## BUGs

### semget/shmget

*   `sem_flags` 含有 `IPC_EXCL` 时, 不会返回已经存在的 IPC 信号量
*   当 key 为 0 时, 返回 id 变成随机值(不再固定)

### copy break condition

当从 S buffer 接收到 EOF 后, 不应该立即 break, 应将 EOF 送入 T buffer 后, 再进行 break, 否则会产生死锁

### EOF

EOF 不能写入 dist file, 否则会造成乱码
