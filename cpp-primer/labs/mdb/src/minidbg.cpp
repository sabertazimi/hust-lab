#include <sys/ptrace.h>
#include <sys/wait.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <iostream>
#include <sstream>
#include <fstream>
#include <iomanip>
#include <vector>

#include "linenoise.h"

#include "registers.hpp"
#include "debugger.h"

using namespace minidbg;

std::vector<std::string> split(const std::string &s, char delimiter) {
    std::vector<std::string> out{};
    std::stringstream ss {s};
    std::string item;

    while (std::getline(ss,item,delimiter)) {
        out.push_back(item);
    }

    return out;
}

bool is_suffix(const std::string& s, const std::string& of) {
    if (s.size() > of.size()) return false;
    auto diff = of.size() - s.size();
    return std::equal(s.begin(), s.end(), of.begin() + diff);
}

void Debugger::run() {
    int wait_status;
    auto options = 0;
    waitpid(m_pid, &wait_status, options);

    char* line = nullptr;
    while ((line = linenoise("minidbg> ")) != nullptr) {
        handle_command(line);
        linenoiseHistoryAdd(line);
        linenoiseFree(line);
    }
}

void Debugger::handle_command(const std::string& line) {
    auto args = split(line,' ');

    if (args.empty()) {
        continue_execution();
    } else {
        auto command = args.front();
        if (is_alias(command, "continue")) {
            continue_execution();
        } else if (is_alias(command, "break")) {
            std::string addr {args[1], 2}; // assume 0xADDRESS (remove "0x" prefix)
            set_breakpoint_at_address(std::stol(addr, 0, 16));
        } else if (is_alias(command, "register")) {
            if (is_alias(args[1], "dump")) {
                dump_registers();
            } else if (is_alias(args[1], "read")) {
                std::cout << get_register_value(m_pid, get_register_from_name(args[2])) << std::endl;
            } else if (is_alias(args[1], "write")) {
                std::string val {args[3], 2};   // assume 0xVAL
                set_register_value(m_pid, get_register_from_name(args[2]), std::stol(val, 0, 16));
            }
        } else if (is_alias(command, "memory")) {
            std::string addr {args[2], 2};      // assume 0xADDRESS

            if (is_alias(args[1], "read")) {
                std::cout << std::hex << read_memory(std::stol(addr, 0, 16)) << std::endl;
            } else if (is_alias(args[1], "write")) {
                std::string val {args[3], 2};   // assume 0xVAL
                write_memory(std::stol(addr, 0, 16), std::stol(val, 0, 16));
            }
        } else if (is_alias(command, "stepin")) {
            single_step_instruction_with_breakpoint_check();
            auto line_entry = get_line_entry_from_pc(get_pc());
            print_source(line_entry->file->path, line_entry->line);
        } else if (is_alias(command, "step")) {
            step_in();
        } else if (is_alias(command, "next")) {
            step_over();
        } else if (is_alias(command, "stepout")) {
            step_out();
        } else {
            std::cerr << "Unknown command\n";
        }
    }
}

void Debugger::dump_registers() {
    for (const auto& rd : g_register_descriptors) {
        std::cout << rd.name << " 0x"
                  << std::setfill('0') << std::setw(16) << std::hex
                  << get_register_value(m_pid, rd.r) << std::endl;
    }
}

uint64_t Debugger::read_memory(uint64_t address) {
    return ptrace(PTRACE_PEEKDATA, m_pid, address, nullptr);
}

void Debugger::write_memory(uint64_t address, uint64_t value) {
    ptrace(PTRACE_POKEDATA, m_pid, address, value);
}

void Debugger::set_breakpoint_at_address(std::intptr_t addr) {
    std::cout << "Set breakpoint at address 0x" << std::hex << addr << std::endl;
    BreakPoint bp {m_pid, addr};
    bp.enable();
    m_breakpoints[addr] = bp;
}

void Debugger::set_breakpoint_at_function(const std::string& name) {
    for (const auto& cu : m_dwarf.compilation_units()) {
        for (const auto& die : cu.root()) {
            if (die.has(dwarf::DW_AT::name) && at_name(die) == name) {
                auto low_pc = at_low_pc(die);
                auto entry = get_line_entry_from_pc(low_pc);
                ++entry; // skip prologue
                set_breakpoint_at_address(entry->address);
            }
        }
    }
}

void Debugger::set_breakpoint_at_source_line(const std::string& file, unsigned line) {
    for (const auto& cu : m_dwarf.compilation_units()) {
        if (is_suffix(file, at_name(cu.root()))) {
            const auto& lt = cu.get_line_table();

            for (const auto& entry : lt) {
                if (entry.is_stmt && entry.line == line) {
                    set_breakpoint_at_address(entry.address);
                    return;
                }
            }
        }
    }
}

void Debugger::single_step_instruction() {
    ptrace(PTRACE_SINGLESTEP, m_pid, nullptr, nullptr);
    wait_for_signal();
}

void Debugger::single_step_instruction_with_breakpoint_check() {
    // first, check to see if we need to disable and enable a breakpoint
    if (m_breakpoints.count(get_pc())) {
        step_over_breakpoint();
    } else {
        single_step_instruction();
    }
}

void Debugger::step_out() {
    auto frame_pointer = get_register_value(m_pid, reg::rbp);
    auto return_address = read_memory(frame_pointer+8);

    bool should_remove_breakpoint = false;
    if (!m_breakpoints.count(return_address)) {
        set_breakpoint_at_address(return_address);
        should_remove_breakpoint = true;
    }

    continue_execution();

    if (should_remove_breakpoint) {
        remove_breakpoint(return_address);
    }
}

void Debugger::remove_breakpoint(std::intptr_t addr) {
    if (m_breakpoints.at(addr).is_enabled()) {
        m_breakpoints.at(addr).disable();
    }
    m_breakpoints.erase(addr);
}

void Debugger::step_in() {
   auto line = get_line_entry_from_pc(get_pc())->line;

    while (get_line_entry_from_pc(get_pc())->line == line) {
        single_step_instruction_with_breakpoint_check();
    }

    auto line_entry = get_line_entry_from_pc(get_pc());
    print_source(line_entry->file->path, line_entry->line);
}

void Debugger::step_over() {
    auto func = get_function_from_pc(get_pc());
    auto func_entry = at_low_pc(func);
    auto func_end = at_high_pc(func);

    auto line = get_line_entry_from_pc(func_entry);
    auto start_line = get_line_entry_from_pc(get_pc());

    std::vector<std::intptr_t> to_delete{};

    // just set a breakpoint at every line in the current function
    // then step in (must jump to next source line as every line has a breakpoint)
    // finally, remove added breakpoints
    while (line->address < func_end) {
        if (line->address != start_line->address && !m_breakpoints.count(line->address)) {
            set_breakpoint_at_address(line->address);
            to_delete.push_back(line->address);
        }
        ++line;
    }

    auto frame_pointer = get_register_value(m_pid, reg::rbp);
    auto return_address = read_memory(frame_pointer+8);
    if (!m_breakpoints.count(return_address)) {
        set_breakpoint_at_address(return_address);
        to_delete.push_back(return_address);
    }

    continue_execution();

    for (auto addr : to_delete) {
        remove_breakpoint(addr);
    }
}

void Debugger::continue_execution() {
    step_over_breakpoint();
    ptrace(PTRACE_CONT, m_pid, nullptr, nullptr);
    wait_for_signal();
}

uint64_t Debugger::get_pc() {
    return get_register_value(m_pid, reg::rip);
}

void Debugger::set_pc(uint64_t pc) {
    set_register_value(m_pid, reg::rip, pc);
}

void Debugger::step_over_breakpoint() {
    if (m_breakpoints.count(get_pc())) {
        auto& bp = m_breakpoints[get_pc()];
        if (bp.is_enabled()) {
            bp.disable();
            ptrace(PTRACE_SINGLESTEP, m_pid, nullptr, nullptr);
            wait_for_signal();
            bp.enable();
        }
    }
}

void Debugger::wait_for_signal() {
    int wait_status;
    auto options = 0;
    waitpid(m_pid, &wait_status, options);

    auto siginfo = get_signal_info();

    switch (siginfo.si_signo) {
        case SIGTRAP:
            handle_sigtrap(siginfo);
            break;
        case SIGSEGV:
            std::cout << "Yay, segfault. Reason: " << siginfo.si_code << std::endl;
            break;
        default:
            std::cout << "Got signal " << strsignal(siginfo.si_signo) << std::endl;
    }
}

siginfo_t Debugger::get_signal_info() {
    siginfo_t info;
    ptrace(PTRACE_GETSIGINFO, m_pid, nullptr, &info);
    return info;
}

void Debugger::handle_sigtrap(siginfo_t info) {
    switch (info.si_code) {
        // one of these will be set if a breakpoint was hit
        case SI_KERNEL:
        case TRAP_BRKPT:
        {
            set_pc(get_pc()-1); // put the pc back where it should be
            std::cout << "Hit breakpoint at address 0x" << std::hex << get_pc() << std::endl;
            auto line_entry = get_line_entry_from_pc(get_pc());
            print_source(line_entry->file->path, line_entry->line);
            return;
        }
        // this will be set if the signal was sent by single stepping
        case TRAP_TRACE:
            return;
        default:
            std::cout << "Unknown SIGTRAP code " << info.si_code << std::endl;
            return;
    }
}

dwarf::die Debugger::get_function_from_pc(uint64_t pc) {
    for (auto &cu : m_dwarf.compilation_units()) {
        if (die_pc_range(cu.root()).contains(pc)) {
            for (const auto& die : cu.root()) {
                if (die.tag == dwarf::DW_TAG::subprogram) {
                    if (die_pc_range(die).contains(pc)) {
                        return die;
                    }
                }
            }
        }
    }

    throw std::out_of_range{"Cannot find function"};
}

dwarf::line_table::iterator Debugger::get_line_entry_from_pc(uint64_t pc) {
    for (auto &cu : m_dwarf.compilation_units()) {
        if (die_pc_range(cu.root()).contains(pc)) {
            auto &lt = cu.get_line_table();
            auto it = lt.find_address(pc);
            if (it == lt.end()) {
                throw std::out_of_range{"Cannot find line entry"};
            } else {
                return it;
            }
        }
    }

    throw std::out_of_range{"Cannot find line entry"};
}

void Debugger::print_source(const std::string& file_name, unsigned line, unsigned n_lines_context) {
    std::ifstream file {file_name};

    // Work out a window around the desired line
    auto start_line = line <= n_lines_context ? 1 : line - n_lines_context;
    auto end_line = line + n_lines_context + (line < n_lines_context ? n_lines_context - line : 0) + 1;

    char c{};
    auto current_line = 1u;
    // Skip lines up until start_line
    while (current_line != start_line && file.get(c)) {
        if (c == '\n') {
            ++current_line;
        }
    }

    // Output cursor if we're at the current line
    std::cout << (current_line == line ? "> " : "  ");

    // Write lines up until end_line
    while (current_line <= end_line && file.get(c)) {
        std::cout << c;
        if (c == '\n') {
            ++current_line;
            // Output cursor if we're at the current line
            std::cout << (current_line == line ? "> " : "  ");
        }
    }

    // Write newline and make sure that the stream is flushed properly
    std::cout << std::endl;
}

inline void Debugger::init() {
    this->set_alias("c", "continue");
    this->set_alias("cont", "continue");
    this->set_alias("continue", "continue");

    this->set_alias("b", "break");
    this->set_alias("break", "break");
    this->set_alias("s", "step");
    this->set_alias("step", "step");
    this->set_alias("n", "next");
    this->set_alias("next", "next");
    this->set_alias("si", "stepin");
    this->set_alias("stepi", "stepin");
    this->set_alias("stepin", "stepin");
    this->set_alias("so", "stepout");
    this->set_alias("stepo", "stepout");
    this->set_alias("stepout", "stepout");

    this->set_alias("reg", "register");
    this->set_alias("register", "register");
    this->set_alias("mem", "memory");
    this->set_alias("memory", "memory");

    this->set_alias("d", "dump");
    this->set_alias("dump", "dump");
    this->set_alias("r", "read");
    this->set_alias("read", "read");
    this->set_alias("w", "write");
    this->set_alias("write", "write");
}

inline bool Debugger::is_alias(const std::string& input, const std::string& command) {
    auto alias = m_aliases.find(input);
    return (alias != m_aliases.end() && alias->second == command);
}

inline void Debugger::set_alias(const std::string& input, const std::string& command) {
    m_aliases[input] = command;
}

void execute_debugee (const std::string& prog_name) {
    if (ptrace(PTRACE_TRACEME, 0, 0, 0) < 0) {
        std::cerr << "Error in ptrace\n";
        return;
    }

    execl(prog_name.c_str(), prog_name.c_str(), nullptr);
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Program name not specified";
        return -1;
    }

    auto prog = argv[1];

    auto pid = fork();
    if (pid == 0) {
        // child
        execute_debugee(prog);
    } else if (pid >= 1) {
        // parent
        Debugger dbg{prog, pid};
        dbg.run();
    }
}
