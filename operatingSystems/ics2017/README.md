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

*   write opcode_table (src/cpu/exec/exec.c)
*   write all-instr.h (src/cpu/exec/all-instr.h)
*   write make_EHelper(xx) (src/cpu/exec/xx.c)
*   write rtl_xx (include/cpu/rtl.h)

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
0xff /2
E, call, rtl_push
IDEX(E, gp5) -> EX(call_rm)

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

0x68
I, push, rtl_push
IDEX(I, push)

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
0x28 /r
G2E, sub, rtl_sub, eflags
IDEXW(G2E, sub, 1)

0x29 /r
G2E, sub, rtl_sub, eflags
IDEX(G2E, sub)

0x2a /r
E2G, sub, rtl_sub, eflags
IDEXW(E2G, sub, 1)

0x2b /r
E2G, sub, rtl_sub, eflags
IDEX(E2G, sub)

0x2c ib
I2a, sub, rtl_sub, eflags
IDEXW(I2a, sub, 1)

0x2d iw/id
I2a, sub, rtl_sub, eflags
IDEX(I2a, sub)

0x83 /5 ib
SI2E, sub, rtl_sub, eflags
IDEX(SI2E, gp1) -> EXW(sub, 1)
```

### sbb (Page 386)

```c
0x18 /r
G2E, sbb, rtl_sub, eflags
IDEXW(G2E, sbb, 1)

0x19 /r
G2E, sbb, rtl_sub, eflags
IDEX(G2E, sbb)

0x1a /r
E2G, sbb, rtl_sub, eflags
IDEXW(E2G, sbb, 1)

0x1b /r
E2G, sbb, rtl_sub, eflags
IDEX(E2G, sbb)

0x1c ib
I2a, sbb, rtl_sub, eflags
IDEXW(I2a, sbb, 1)

0x1d iw/id
I2a, sbb, rtl_sub, eflags
IDEX(I2a, sbb)

0x83 /3 ib
SI2E, sbb, rtl_sub, eflags
IDEX(SI2E, gp1) -> EXW(sbb, 1)
```

### xor (Page 411)

```c
0x30 /r
G2E, xor, rtl_xor, eflags
IDEXW(G2E, xor, 1)

0x31 /r
G2E, xor, rtl_xor, eflags
IDEX(G2E, xor)

0x32 /r
E2G, xor, rtl_xor, eflags
IDEXW(E2G, xor, 1)

0x33 /r
E2G, xor, rtl_xor, eflags
IDEX(E2G, xor)

0x34 ib
I2a, xor, rtl_xor, eflags
IDEXW(I2a, xor, 1)

0x35 iw/id
I2a, xor, rtl_xor, eflags
IDEX(I2a, xor)

0x83 /6 ib
SI2E, xor, rtl_xor, eflags
IDEX(SI2E, gp1) -> EXW(xor, 1)
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

0x20 /r
G2E, and, rtl_and, eflags
IDEXW(G2E, and, 1)

0x21 /r
G2E, and, rtl_and, eflags
IDEX(G2E, and)

0x22 /r
E2G, and, rtl_and, eflags
IDEXW(E2G, and, 1)

0x23 /r
E2G, and, rtl_and, eflags
IDEX(E2G, and)

0x24 ib
I2a, and, rtl_and, eflags
IDEXW(I2a, and, 1)

0x25 iw/id
I2a, and, rtl_and, eflags
IDEX(I2a, and)
```

### nop (Page 355)

```c
0x66 0x90 (operand_size = 16)
0x90
```

### add (Page 261)

```c
0x00 /r
G2E, add, rtl_add, eflags
IDEXW(G2E, add, 1)

0x01 /r
G2E, add, rtl_add, eflags
IDEX(G2E, add)

0x02 /r
E2G, add, rtl_add, eflags
IDEXW(E2G, add, 1)

0x03 /r
E2G, add, rtl_add, eflags
IDEX(E2G, add)

0x83 /0 ib
SI2E, add, rtl_add, eflags
IDEX(SI2E, gp1) -> EXW(add, 1)

0x04 ib
I2a, add, rtl_add, eflags
IDEXW(I2a, add, 1)

0x05 iw/id
I2a, add, rtl_add, eflags
IDEX(I2a, add)
```

### adc (Page 260)

```c
0x10 /r
E2G, adc, rtl_add, eflags
IDEXW(E2G, adc, 1)

0x11 /r
E2G, adc, rtl_add, eflags
IDEX(E2G, adc)

0x12 /r
E2G, adc, rtl_add, eflags
IDEXW(E2G, adc, 1)

0x13 /r
E2G, adc, rtl_add, eflags
IDEX(E2G, adc)

0x14 ib
I2a, adc, rtl_add, eflags
IDEXW(I2a, adc, 1)

0x15 iw/id
I2a, adc, rtl_add, eflags
IDEX(I2a, adc)

0x83 /2 ib
SI2E, adc, rtl_add, eflags
IDEX(SI2E, gp1) -> EXW(adc, 1)
```

### or (Page 357)

```c
0x08 /r
G2E, or, rtl_or, eflags
IDEXW(G2E, or, 1)

0x09 /r
G2E, or, rtl_or, eflags
IDEX(G2E, or)

0x0a /r
E2G, or, rtl_or, eflags
IDEXW(E2G, or, 1)

0x0b /r
E2G, or, rtl_or, eflags
IDEX(E2G, or)

0x0c ib
I2a, or, rtl_or, eflags
IDEXW(I2a, or, 1)

0x0d iw/id
I2a, or, rtl_or, eflags
IDEX(I2a, or)

0x83 /1 ib
SI2E, or, rtl_or, eflags
IDEX(SI2E, gp1) -> EXW(or, 1)
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

in `exec_movzx`: change `id_dest->width`  again

```c
0x0f 0xb6 /r
E2G, movzx, rtl_li
IDEXW(E2G, movzx, 1)
```

### test (Page 405)

**gp3**: IDEXW -> IDEXW, decode twice

```c
0x84 /r 
G2E, test, rtl_and, eflags
IDEXW(G2E, test, 1)

0x85 /r
G2E, test, rtl_and, rtl_set_CF, rtl_set_OF, rtl_update_ZFSF
IDEX(G2E, test)

0xa8 ib
I2a, test, rtl_and, eflags
IDEXW(I2a, test, 1)

0xf6 /0 ib
I2E, test, rtl_and, eflags
IDEXW(E, gp3, 1) -> IDEXW(test_I, test, 1)
```

### jcc (Page 316)

```c
je:
0x74 cb
J, jcc, rtl_setcc
IDEXW(J, jcc, 1)

jne:
0x75 cb
J, jcc, rtl_setcc
IDEXW(J, jcc, 1)

jle:
0x7e cb
J, jcc, rtl_setcc
IDEXW(J, jcc, 1)
```

```c
je:
0x0f 0x84 cw/cd
J, jcc, rtl_setcc
IDEX(J, jcc)

0x0f 0x85 cw/cd
J, jcc, rtl_setcc
IDEX(J, jcc)
```

### cmp (Page 287)

```c
0x83 /7 ib
SI2E, cmp, rtl_sub, eflags
IDEX(SI2E, gp1) -> EXW(cmp, 1)

0x38 /r
G2E, cmp, rtl_sub, eflags
IDEXW(G2E, cmp, 1)

0x39 /r
G2E, cmp, rtl_sub, eflags
IDEX(G2E, cmp)

0x3a /r
E2G, cmp, rtl_sub, eflags
IDEXW(E2G, cmp, 1)

0x3b /r
E2G, cmp, rtl_sub, eflags
IDEX(E2G, cmp)

0x3c ib
I2a, cmp, rtl_sub, eflags
IDEXW(I2a, cmp, 1)

0x3d iw/id
I2a, cmp, rtl_sub, eflags
IDEX(I2a, cmp)
```

### dec (Page 293)

```c
0xfe /1
E, dec, rtl_sub, eflags
IDEXW(E, gp4, 1) -> EXW(dec, 1)

0xff /1
E, dec, rtl_sub, eflags
IDEX(E, gp5) -> EX(dec)

0x48-0x4f +r
r, dec, rtl_sub ,eflags
IDEX(r, dec)
```

### not

```c
0xf7 /2
E, not, rtl_not
IDEX(E, gp3) -> EX(not)
```

### inc (Page 303)

```c
0x40-0x47 +r
r, inc, rtl_add, eflags
IDEX(r, inc)

0xfe /0
E, inc, rtl_add, eflags
IDEXW(E, gp4, 1) -> EXW(inc, 1)

0xff /0 (i386 manual error /6)
E, inc, rtl_add, eflags
IDEX(E, gp5) -> EX(inc)
```

### jmp (Page 319)

```c
0xe9
J, jmp
IDEX(J, jmp)

0xeb
J, jmp
IDEXW(J, jmp, 1)

0xff /4
E, jmp
IDEX(E, gp5) -> EX(jmp_rm)
```

### imul (Page 300)

```c
0xf7 /5
E, imul1, rtl_imul
IDEX(E, gp3) -> EX(imul1)


0x0f 0xaf /r
E2G, imul2, rtl_imul
IDEX(E2G, imul2)
```

### mul (Page 352)

```c
0xf7 /4
E, mul, rtl_mul
IDEX(E, gp3) -> EX(mul)
```

### idiv (Page 298)

```c
0xf7 /7
E, idiv, rtl_idiv
IDEX(E, gp3) -> EX(idiv)
```

### div (Page 294)

```c
0xf7 /6
E, div, rtl_div
IDEX(E, gp3) -> EX(div)
```

### cltd/cdq (Page 290)

```c
0x99
EX(cltd), rtl_msb
```

### cwtl/cwd (Page 290)

```c
0x98
EX(cwtl), rtl_msb
```

### movsx (Page 350)

in `exec_movsx`: change `id_dest->width`  aggin

```c
0x0f 0xbf /r
mov_E2G, movsx, rtl_sext
IDEXW(mov_E2G, movsx, 2)
```

### leave (Page 329)

```c
0xc9
EX(leave), rtl_lr, rtl_sr, rtl_pop
```

### rol

```c
0xd3 /0
gp2_cl2E, rol, eflags
IDEX(gp2_cl2E, gp2) -> EX(rol)
```
### sar

```c
0xc1 /7 ib
gp2_Ib2E, sar, rtl_sar, eflags
IDEX(gp2_Ib2E, gp2) -> EXW(sar, 1)
```

### shl

```c
0xd3 /4
gp2_cl2E, shl, rtl_shl, eflags
IDEX(gp2_cl2E, gp2) -> EX(shl)
```


### shr (Page 383)

```c
0xc1 /5 ib
gp2_Ib2E, shr, rtl_shr, eflags
IDEX(gp2_Ib2E, gp2) -> EXW(shr, 1)
```

### neg (Page 354)

```c
0xf7 /3
E, neg, rtl_neg
IDEX(E, gp3) -> EX(neg)
```

### in (Page 302)

*   `HAS_IOE`
*   `HAS_SERIAL`

```c
0xec
port(DX) to AL
IDEXW(in_dx2a, in, 1)

0xed
port(DX) to AX/EAX
IDEX(in_dx2a, in)
```

### out (Page 358)

*   `HAS_IOE`
*   `HAS_SERIAL`

```c
0xee
AL to port(DX)
IDEXW(out_a2dx, out, 1)

0xef
AX/EAX to port(DX)
IDEX(out_a2dx, out)
```

### port io

flow:

```c
cpu-exec.c: device_update() -> update_screen() -> sdl_event(key down/up)
device.c: timer interval for time_sig_handler
```

```c
pio_read:
callback -> read
```

```c
pio_write
write -> callback
```

### timer

```c
pio_read(0x48):
-> callback(update_time, store in pio_space + 0x48)
-> return time data (len = 4)
```

### vga

flow:

```c
*40000 = xx; in source code
-> asm code -> cpu-exec -> IDEX() -> data-mov.c -> rtl.h -> memory.h (vaddr_read/write -> paddr_read/write -> mmio_read/write)
```

## pa3

```c
pal -> nanos-lite -> am -> nemu -> host x86/docker x86
```

### navy-apps

compile client apps to 0x4000000

### nanos-lite

```c
make update
```

initrd.S:

```c
client app locate in 0x0 of ramdisk (ramdisk_start)
```

### pa3.1

#### loader

```c
implement loader.c -> loader()
```

read content in 0x0 ramdisk to 0x4000000

```c
nemu.main -> nemu.ui_loop -> nemu.cpu-exec
-> nanos.main -> nanos.init_xx -> nanos.loader(0x4000000) first client app
```

#### 'lidt' instruction

cs: Page 31
IDTR: Page 156

```c
0x0f 0x01 /3
gp7_E(addr), lidt, vaddr_read
IDEX(gp7_E, gp7) -> EX(lidt)
```

#### 'int' instruction

```c
push eflags, cs, eip
load idt
seek gate descriptor
jump
```

```c
0xcd
I, int, rtl_push, jmp
IDEXW(I, int, 1)
```

```c
address access error in 0x4001f59 (int instruction)
-> cpu.idtr.base error
-> lidt implementation error
```

#### 'pusha' / 'popa' instruction

```c
pusha:
pusha, rtl_push
EX(pusha)

popa:
popa, rtl_pop
EX(popa)
```

#### irq

```c
nexus-am/am/am.h -> _Event
```

```c
nemu/src/cpu/instr.c
nexus-am/am/arch/x86-nemu/src/trap.S
nexus-am/am/arch/x86-nemu/include/arch.h -> _Reg_Set (Trap Frame)

int 0x80 -> raise_intr -> search idt table ->
nexus-am.vecsys -> nexus-am.asm_trap -> nexus-am.irq_handle ->
nanos.do_event (next = H(ev, tf)) -> nanos.do_syscall -> nanos.do_syscall_xx
nanos._putc/_halt/_draw_rect/_uptime/_read_key/fs_xx/fb_write/dispinfo_read/events_read

eflags -> cs -> eip
error_code -> irq
-> eax -> ecx -> edx -> ebx -> esp -> ebp -> esi -> edi
```

```c
nanos.main -> nanos.init_irq -> nexus-am._asyte_init(do_event)
-> nexus-am->set_idt
```

#### 'iret' instruction

```c
0xcf
iret, rtl_pop
EX(iret)
```

### pa3.2

#### syscalls in navy-apps

```c
navy-apps/libs/libc/src/syscalls/syswrite.c:
printf -> vprintf -> out_string -> putc/puts ->
_putc/_puts -> __sputc/__svwrite
-> write -> _write -> do_syscall -> do_syscall_write -> fs_write -> ramdisk_write
```

### pa3.3

#### dispinfo and fb

```c
navy-apps/libs/libndl/src/ndl.c -> get_display_info()
```

#### pal

```c
navy-apps/fsimg/share/games/nes
navy-apps/fsimg/share/games/pal
```

## PA 4

### PA 4.1 (PTE)

#### control register (cr0/cr3) (Page 87)

```c
nemu/include/memory/mmu.h
```

#### mov cr0/cr3 (Page 347)

```c
opcode level:
mod: 11B
reg: control register x
r/m: general purpose register
```

```c
fix control registers X in 'reg' parameter when call read_Mod_R_M
fix general purpose registers in 'rm' parameter when call read_Mod_R_M
```

```c
0x0f 20 /r
mov_G2E, mov_cr2r, rtl_sr
IDEX(mov_G2E, mov_cr2r)

0x0f 22 /r
mov_E2G, mov_r2cr, rtl_sr
IDEX(mov_E2G, mov_r2cr)
```

#### mmu (Page 100)

```c
Page Directory Start = cr3
Page Table Start = *(cr3 + PDX(va) * sizeof(uint32)) & ~0xfff (set low-order 12 bits to 0)
Physical Page Start = *(Page Table Start + PTX(va) * sizeof(uint32) & ~0xfff
Physical Address = Physical Page Start + OFF(va)
```

#### multi-task

```c
trap -> schedule (change as(pde/pte), return new tf) -> asm_trap (to new tf)
```

