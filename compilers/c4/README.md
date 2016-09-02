## BUG Record

### Address Overflow

BUG:

```c
(int)stack+POOL_SIZE // in 64 bit computer, stack/heap start at high address that occupy 8 bytes
```

FIXED:

```c
(long)stack+POOL_SIZE
```

or

```sh
$ gcc -m32 ...
```

