# ics-2017

Repo for ICS PAs

## Install Docker

Get docker from `https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository`

```sh
# run docker without `sudo`
sudo gpasswd -a $USER docker
```

## Install Debian Docker Image

```sh
docker build -t ics-image .
docker images
docker create --name=ics-vm -p 20022:22 ics-image
docker ps -a

docker start ics-vm
docker stop ics-vm
ssh -p 20022 sabertazimi@127.0.0.1
```

## Install tools


```sh
sudo apt-get install build-essential    # build-essential packages, include binary utilities, gcc, make, and so on
sudo apt-get install gdb                # GNU debugger
sudo apt-get install git                # reversion control system
sudo apt-get install libreadline-dev    # a library to use compile the project later
sudo apt-get install libsdl2-dev        # a library to use compile the project later
sudo apt-get install qemu-system-x86    # QEMU
sudo apt-get install vim zsh curl
sudo apt-get install bsdmainutils       # fix hexdump not found error
```

### zsh vim

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
curl https://j.mp/spf13-vim3 -L > spf13-vim.sh && sh spf13-vim.sh

scp -P 20022 username@127.0.0.1:SRC_PATH HOST_PATH
scp -P 20022 HOST_SRC_PATH username@127.0.0.1:DEST_PATH
```

### tmux

```sh
sudo apt-get install locales
locales -a
sudo locales-gen
tmux new-session -s ics
tmux attach -t ics

C-a s list sessions
C-a d detach session

C-a c create panel
C-a % horizon split
C-a " vertical split
C-a q list panel
C-a x close panel
C-a o toggle panel
```

### git

```sh
git config --global user.name "sabertazimi"
git config --global user.email sabertazimi@gmail.com
git config --global core.editor vim
git config --global push.default simple
git config --global credential.helper store
git config --global commit.template $HOME/.gitmsg.md
git config --global http.postbuffer 524288000
git config --global alias.cm "commit -v --allow-empty"
git config --list
```

## PA1

### Expression

regexp chars: `+ * | ( ) ^ $`

```
Token rule -> make_token ->
eval -> check_parenthesis
-> Token priority -> get_donimant__ops
```

### Watch Point

*   watch point pool management (busy/free)
*   watch point implement

### QAs

#### 理解基础设施

*   270000 s = 4500 m = 75 h
*   90000  s = 1500 m = 25 h
*   75 h - 25 h = 50 h

#### i386 Manual

*   Page 34/421: CF = Carry Flag

*   Page 241-244/421: mod(7 6) reg/opcode(5 4 3) r/m(2 1 0)

mod 域与 r/m 域结合可以有 32 种值：8 寄存器，24 种索引模式，用于寄存器寻址等各种寻址方式
reg/opcode 表示寄存器编号或指令编号, 由第一个 opcode 决定其意义

*  Page 345-347/421: MOV DEST, SRC

#### shell

```sh
find . -name "*.[ch]" | xargs cat | grep -v ^$ | wc -l
```

3275

#### -Wall -Werror

```sh
sudo apt-get install man-db
```

*   �/�启大部分警告选项
*   将警告强制转为错误

使得所有隐藏的逻辑错误都可以在编译阶段得到修正

```c
if (num = 0) {
    printf("num == 0\n");
} else {
    printf("num != 0\n");
}
```

## PA2

### Macro

*   Use macro to define struct(`EX/EXW/EMPTY/IDEX/IDEXW`) or function(`make_EHelper/make__DopHelper/make_DHelper`)

### Reading

*   Table 17-3 (ModR/M field)
*   instruction set page (opcode table/Operation/Description/Flags Affected)
*   appendix A

### Benchmarks

```sh
sudo apt-get install libc6-dev libc6-dev-i386
```

### Flow

*   write make_DHelper
*   write make_EHelper and rtl_xx
*   write opcode_table
*   write all-instr.h

```c
include/cpu/decode.h
src/cpu/decode/decode.c
(src/cpu/decode/modrm.c)

src/cpu/exec/xx.c
src/cpu/exec/exec.c
src/cpu/exec/all-instr.h

include/cpu/rtl.h
```

#### 0x66 operand_size

`exec_wrapper` -> `exec_real` -> `exec_operand_size`
-> `exec_real` -> `exec_xx`

*   `decode_xx -> decode_op_xx` `decode.c`
*   `exec_xx -> rtl_xx` `exec/*.c`  `rtl.h`

#### 2 byte opcode

0x0f:

`exec_wrapper -> exec_real -> exec_2byte -> exec__xx`

#### gpx

`exec_wrapper -> exec_real -> exec_gpx -> exec_xx`

#### decode

*   `read_ModR_M`(src/cpu/decode/modrm.c include/cpu/decode.h)
*    + rb/rw/rd -> r
*    ib/iw/id -> SI/I (width = 1/2/4)
*    /r -> G2E/E2G

#### eflags

eflags = 0x2h

### call (Page 275)

```c
0xe8
J, call, rtl_push
IDEX(J, call)
```

### push (Page 367)

```c
0x50 - 0x 57 +r
r, push, rtl_push
IDEX(r, push)

0xff /6
E, push, rtl_push
IDEX(E, gp5) -> EX(push)

0x6a
I, push, rtl_push
IDEXW(I, push, 1)
```

### pop (Page 361)

```c
0x58 - 0x5f +r
r, pop, rtl_pop
IDEX(r, pop)
```

### sub (Page 404)

```c
idex(decode_I2E/SI2E..., exec_gp1)
exec_gp1 -> idex(exec_sub) no decode again
```

```c
0x83 /5 ib
SI2E, sub, rtl_sub, eflags
IDEX(SI2E, gp1) -> EXW(sub, 1)
```

### xor (Page 411)

```c
0x31
G2E, xor, rtl_xor, eflags
IDEX(G2E, xor)
```

### ret (Page 378)

```c
0x31
NULL, ret, rtl_pop
EX(ret)
```

### lea

```c
0x8d
lea_M2G, lea, rtl_li
IDEX(lea_M2G, lea)
```

### and (Page 262)

```c
0x83 /4 ib
SI2E, and, rtl_and, eflags
IDEX(SI2E, gp1) -> EXW(and, 1)
```

### nop (Page 355)

```c
0x66 0x90 (operand_size = 16)
0x90
```

### add (Page 261)

```c
0x03 /r
E2G, add, rtl_add, eflags
IDEX(E2G, add)
```

### adc (Page 260)

```c
0x13 /r
E2G, adc, rtl_add, eflags
IDEX(E2G, adc)
```

### or (Page 357)

```c
0x09 /r
G2E, or, rtl_or, eflags
IDEX(G2E, or)
```

### setcc (Page 389)

```c
exec_2byte_esc:

opcode = opcode | 0x100
subcode &= 0xf
invert = subcode & 0x1
```

```c
sete:
(0x0f 2byte_esc) 0x94 -> 0x04 -> case CC_E
E, setcc, rtl_get_ZF, rtl_li
IDEXW(E, setcc, 1) to 2 byte_opcode_table

setne:
0x0f 0x95 -> case CC_E + invert
E, setcc, rtl_get_ZF, rtl_li
IDEXW(E, setcc, 1) to 2 byte_opcode_table
```

### movzx/movzbl (Page 351)

```c
0x0f 0xb6 /r
E2G, movzx, rtl_li
IDEXW(E2G, movzx, 1)
```

### test (Page 405)

```c
0x84 /r 
G2E, test, rtl_and, eflags
IDEXW(G2E, test, 1)

0x85 /r
G2E, test, rtl_and, rtl_set_CF, rtl_set_OF, rtl_update_ZFSF
IDEX(G2E, test)
```

### jcc (Page 316)

je:

```c
0x74 cb
J, jcc, rtl_setcc
IDEXW(J, jcc, 1)
```

jne:

```c
0x75 cb
J, jcc, rtl_setcc
IDEXW(J, jcc, 1)
```

jcc CC_E:

```c
0x0f 0x84 cw/cd je
J, jcc, rtl_setcc
IDEX(J, jcc)
```


### cmp

```c
0x83 /7 ib
SI2E, cmp, rtl_sub, eflags
IDEX(SI2E, gp1) -> EXW(cmp, 1)

0x3b /r
E2G, cmp, rtl_sub, eflags
IDEX(E2G, cmp)
```

### sar

```c
0xc1 /7 ib
gp2_Ib2E, sar, rtl_sar eflags
IDEX(gp2_Ib2E, gp2) -> EXW(sar, 1)
```

### shl

```c
0xd3 /4
gp2_cl2E, shl, rtl_shl, eflags
IDEX(gp2_cl2E, gp2) -> EX(shl)
```

### dec

```c
0xfe /1
E, dec, rtl_dec, eflags
IDEXW(E, gp4, 1) -> EXW(dec, 1)
```

