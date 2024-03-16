#ifndef _MINIDBG_DEBUGGER_H
#define _MINIDBG_DEBUGGER_H

#include <linux/types.h>

#include <utility>
#include <string>
#include <unordered_map>

#include "elf/elf++.hh"
#include "dwarf/dwarf++.hh"

#include <breakpoint.hpp>

namespace minidbg {
    class Debugger {
    public:
        Debugger (std::string prog_name, pid_t pid)
            : m_prog_name{std::move(prog_name)}, m_pid{pid} {
            auto fd = open(m_prog_name.c_str(), O_RDONLY);
            m_elf = elf::elf{elf::create_mmap_loader(fd)};
            m_dwarf = dwarf::dwarf{dwarf::elf::create_loader(m_elf)};

            this->init();
        }

        void run();

    private:
        void handle_command(const std::string& line);

        void continue_execution();        
        void dump_registers();
        auto read_memory(uint64_t address) -> uint64_t;
        void write_memory(uint64_t address, uint64_t value);

        void set_breakpoint_at_address(std::intptr_t addr);
        void set_breakpoint_at_function(const std::string& name);
        void set_breakpoint_at_source_line(const std::string& file, unsigned line);
        void single_step_instruction();
        void single_step_instruction_with_breakpoint_check();
        void step_in();
        void step_over();
        void step_out();
        void remove_breakpoint(std::intptr_t addr);

        void step_over_breakpoint();
        void wait_for_signal();
        auto get_signal_info() -> siginfo_t;
        void handle_sigtrap(siginfo_t info);

        auto get_pc() -> uint64_t;
        void set_pc(uint64_t pc);
        auto get_function_from_pc(uint64_t pc) -> dwarf::die;
        auto get_line_entry_from_pc(uint64_t pc) -> dwarf::line_table::iterator;

        void print_source(const std::string& file_name, unsigned line, unsigned n_lines_context=2);

        inline void init();
        inline auto is_alias(const std::string& input, const std::string& command) -> bool;
        inline void set_alias(const std::string& input, const std::string& command);
        
        std::string m_prog_name;
        pid_t m_pid;
        std::unordered_map<std::string, std::string> m_aliases;
        std::unordered_map<std::intptr_t, BreakPoint> m_breakpoints;

        elf::elf m_elf;
        dwarf::dwarf m_dwarf;
    };
}

#endif
