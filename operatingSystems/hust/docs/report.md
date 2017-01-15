# OS Lab Notes

## Lab 1 Notes

两个子进程必须能够同时退出/强制退出

误以为 SIGUSR1 与 SIGUSR2 是由编程者自定义的枚举量

```c
typedef enum _sigusr_ {
    SIGUSRONE = 233,
    SIGUSRTWO = 234
} sigusr_t;

signal(SIGUSRONE, handler);
signal(SIGUSRTWO, handler);

kill(c1, SIGUSRONE);
kill(c2, SIGUSRTWO);
```

导致父进程发送无效信号, 子进程处理无效信号, 都在做无用功

> solution: SIGUSRONE->SIGUSR1, SIGUSRTWO->SIGUSR2

## Lab 2/3 Notes

### Block

如果 semget/semctl(SEMVAL, IPC_RMID)/pthread_create 中任意函数调用错误, main 将会被阻塞

### Compile and Link

*   change -lpthread to -pthread

### ipcs and ipcrm

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

### `key_t` key

对于同一个 非 0 key, 调用 semget/shmget 函数所产生的 IPC 信号量为同一个 IPC 信号量:

*   若 semflags/shmflags 中含有 `IPC_CREAT | IPC_EXCL`, 则会创建失败, 函数返回 -1
*   若 semflags/shmflags 不含有 `IPC_EXCL` , 则函数会返回已创建 IPC 信号量的 id
*   可以通过对于同一 key, 改变 flags 的方法, 灵活操控 semget/shmget 函数, 以达到创建/获取特定 IPC 信号量的目的, 使得进程间能够进行信息交流

### while (== 0 / == size)

*   由于每次取/写数据都会进行 V, 而 P 操作仅在特定条件下进行, 造成了 P/V 操作无法配对
*   故利用 while 使得进程一旦进入特定条件, 就会重复进行 P 操作, 直至进程将自己阻塞, 等待另一进程取/写数据后将其唤醒

### BUGs

#### semctl

The **calling** program must define this union as follows:

```c
union semun {
    int              val;    /* Value for SETVAL */
    struct semid_ds *buf;    /* Buffer for IPC_STAT, IPC_SET */
    unsigned short  *array;  /* Array for GETALL, SETALL */
    struct seminfo  *__buf;  /* Buffer for IPC_INFO
    (Linux-specific) */
};
```

#### semget/shmget

*   `sem_flags` 含有 `IPC_EXCL` 时, 不会返回已经存在的 IPC 信号量
*   当 key 为 0(IPC_PRIVATE) 时, 返回 key_id 变成随机值

#### copy break condition

*   不应利用文件本身字符(EOF)判断结束条件, 而应利用 fread 返回值(< 0 代表未成功读取字符)判断结束条件

### Debug

```sh
# debug parent process only
$ set follow-fork-mode parent set detach-on-fork on

# debug child  process only
$ set follow-fork-mode child  set detach-on-fork on

# debug processes together, block child process on where fork function get invoked
$ set follow-fork-mode parent set detach-on-fork off

# debug processes together, block parent process on where fork function get invoked
$ set follow-fork-mode child  set detach-on-fork off

# info inferiors
$ info inferiros
$ inferior <infer number>

# info threads
$ info threads
$ thread <thread number>
```

## Lab 4(File API) notes

### realease

```bash
#!/bin/bash
# only work in bash(not work in sh)
read -s -p "[ sudo ] input $(whoami)'s password: " password
echo $password | sudo -S cp -fr ./bin/lsr /usr/local/bin/lsr
```
