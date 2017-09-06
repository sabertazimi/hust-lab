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

#### 0x66

`exec_wrapper` -> `exec_real` -> `exec_operand_size`
-> `exec_real`

*   `decode_xx -> decode_op_xx` `decode.c`
*   `exec_xx -> rtl_xx` `exec/*.c`  `rtl.h`

#### decode

*   `read_ModR_M`(src/cpu/decode/modrm.c include/cpu/decode.h)

#### call (Page 275)

```c
make_DHelper(J), make_EHeleper(call), rtl_push
0xe8
```

#### push (Page 367)

```c
make_DHelper(G), make_EHelper(push), rtl_push
0x50

make_DHelper(r), make_EHelper(push), rtl_push
0x55 (push %ebp)
```
