# mdb

[![Author](https://img.shields.io/badge/author-sabertaz-lightgrey?style=for-the-badge)](https://github.com/sabertazimi)
[![LICENSE](https://img.shields.io/github/license/sabertazimi/mdb?style=for-the-badge)](https://raw.githubusercontent.com/sabertazimi/mdb/master/LICENSE)

Minimal debugger

## ptrace

在执行系统调用之前, 内核会先检查当前进程是否处于被 "跟踪" (traced) 的状态.
如果是的话， 内核暂停当前进程并将控制权交给跟踪进程， 使跟踪进程得以察看或者修改被跟踪进程的寄存器.
Whenever traced process trigger a system call,
control is passed to the debugger.
Debugger can use `ptrace(PTRACE_CONT, trace_pid, nullptr, nullptr)`
to let traced process continue to system call.
Meanwhile, debugger can use:

- `ptrace(PTRACE_PEEKUSER)`
- `PEEKDATA`: memory data
- `PEEKTEXT`
- `PEEKSIGINFO`
- `GETREGS`: registers info

to get data of traced process,
`ptrace(PTRACE_POKEUSER)` or `POKEDATA` or `POKETEXT`
to set data of traced process.

```c
// Source: arch/i386/kernel/ptrace.c
if (request == PTRACE_TRACEME) {
    // are we already being traced?
    if (current->ptrace & PT_PTRACED) {
        goto out;
    }

    // set the ptrace bit in the process flags.
    current->ptrace |= PT_PTRACED;
    ret = 0;
    goto out;
}
```

## Breakpoints

When the processor executes the `int 3` instruction,
control is passed to the breakpoint interrupt handler,
which signals the process with a `SIGTRAP`.

Use `waitpid` to listen for signals which are sent to the debugee.
Set the breakpoint, continue the program,
call `waitpid` and wait until the `SIGTRAP` occurs.

Replace the instruction which is currently
at the given address with an int 3 instruction,
which is encoded as 0xcc to implement software breakpoints.

## Registers

- register address/value in `<sys/user.h>`: `struct user_regs_struct`
- ptrace api: `ptrace(PTRACE_GETREGS, pid, nullptr, &regs);`

## DWARF Debugging Format

- [ELF Format](http://www.skyfree.org/linux/references/ELF_Format.pdf)
- [DWARF Format](http://www.dwarfstd.org/doc/Debugging%20using%20DWARF-2012.pdf)

DWARF is a widely used, standardized debugging data format.
DWARF was originally designed along with Executable and Linkable Format (ELF),
although it is independent of object file formats.

- .debug_abbrev Abbreviations used in the .debug_info section
- .debug_aranges A mapping between memory address and compilation
- .debug_frame Call Frame Information
- .debug_info The core DWARF data containing DWARF Information Entries (DIEs)
- .debug_line Line Number Program
- .debug_loc Location descriptions
- .debug_macinfo Macro descriptions
- .debug_pubnames A lookup table for global objects and functions
- .debug_pubtypes A lookup table for global types
- .debug_ranges Address ranges referenced by DIEs
- .debug_str String table used by .debug_info
- .debug_types Type descriptions

```bash
# compile with `-g` flag
dwarfdump a.out
```

### debug_line

`NS` means that the address marks the beginning of a new statement,
which is often used for setting breakpoints or stepping.
`PE` marks the end of the function prologue,
which is helpful for setting function entry breakpoints.
`ET` marks the end of the translation unit.

### debug_info

The `.debug_info` section is the heart of DWARF.
It gives us information about the types, functions, variables.
A DIE consists of a tag telling you what kind of source-level entity is being represented,
followed by a series of attributes which apply to that entity.

The first DIE represents a compilation unit (CU),
which is essentially a source file with all of the `#includes` and such resolved.

we have a program counter value and want to figure out what function we’re in:

```cpp
for each compile unit:
    if the pc is between DW_AT_low_pc and DW_AT_high_pc:
        for each function in the compile unit:
            if the pc is between DW_AT_low_pc and DW_AT_high_pc:
                return function information
```

function breakpoints:
lookup the value of DW_AT_low_pc in the line table,
then keep reading until you get to the entry marked as the prologue end.

## Contact

[![GitHub](https://img.shields.io/badge/-GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/sabertazimi)
[![Email](https://img.shields.io/badge/-Gmail-ea4335?style=for-the-badge&logo=gmail&logoColor=white)](mailto:sabertazimi@gmail.com)
[![X](https://img.shields.io/badge/-X.com-000000?style=for-the-badge&logo=x&logoColor=white)](https://x.com/sabertazimi)

