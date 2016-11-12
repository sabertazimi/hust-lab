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
