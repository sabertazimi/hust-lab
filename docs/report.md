# OS Lab Notes

## Lab 1 Notes

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

对于同一个 key, 在同一进程组中, 调用 semget/shmget 函数所产生的 IPC 信号量为同一个 IPC 信号量:

*   若 semflags/shmflags 中含有 `IPC_CREAT | IPC_EXCL`, 则会创建失败, 函数返回 -1
*   若 semflags/shmflags 不含有 `IPC_EXCL` , 则函数会返回已创建 IPC 信号量的 id
*   可以通过对于同一 key, 改变 flags 的方法, 灵活操控 semget/shmget 函数, 以达到创建/获取特定 IPC 信号量的目的, 使得进程间能够进行信息交流

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
*   当 key 为 0 时, 返回 id 变成随机值(不再固定)

#### copy break condition

当从 S buffer 接收到 EOF 后, 不应该立即 break, 应将 EOF 送入 T buffer 后, 再进行 break, 否则会产生死锁

#### EOF

EOF 不能写入 dist file, 否则会造成乱码

#### Dead Lock

*   problem: get 结束后, 会 detach bufs_map, 导致 copy 得不到正确的信号量(bufs_full)而阻塞, 产生死锁
*   solution: 由于 get 与 copy 间存在同步关系, get 必定先于 copy 结束, 故不应在 get 中 detach bufs_map. 同理, 在 copy 不应 detach buft_map.
*   solution: 为了使得 get 程序不太快于 copy 程序结束, copy 程序不太快于 put 程序结束, 使其都在退出前休眠 500 ms.

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
