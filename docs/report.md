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

*   若 semflags/shmflags 中含有 `IPC_CREAT`, 则会创建失败, 函数返回 -1
*   若 semflags/shmflags 为 0, 则函数会返回已创建 IPC 信号量的 id
*   可以通过对于同一 key, 改变 flags 的方法, 灵活操控 semget/shmget 函数, 以达到创建/获取特定 IPC 信号量的目的, 使得进程间能够进行信息交流
