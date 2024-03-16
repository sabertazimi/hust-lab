#ifndef _MINIDBG_BREAKPOINT_HPP
#define _MINIDBG_BREAKPOINT_HPP

#include <sys/ptrace.h>

#include <cstdint>

namespace minidbg {
    class BreakPoint {
    public:
        BreakPoint() = default;
        BreakPoint(pid_t pid, std::intptr_t addr) : m_pid{pid}, m_addr{addr}, m_enabled{false}, m_saved_data{} {}

        void enable() {
            auto data = ptrace(PTRACE_PEEKDATA, m_pid, m_addr, nullptr);
            m_saved_data = static_cast<uint8_t>(data & 0xff); // save bottom byte
            uint64_t int3 = 0xcc;
            uint64_t data_with_int3 = ((data & ~0xff) | int3); // set bottom byte with int3
            ptrace(PTRACE_POKEDATA, m_pid, m_addr, data_with_int3);

            m_enabled = true;
        }

        void disable() {
            auto data = ptrace(PTRACE_PEEKDATA, m_pid, m_addr, nullptr);
            auto restored_data = ((data & ~0xff) | m_saved_data);
            ptrace(PTRACE_POKEDATA, m_pid, m_addr, restored_data);

            m_enabled = false;
        }

        auto is_enabled() const -> bool { return m_enabled; }
        auto get_address() const -> std::intptr_t { return m_addr; }

    private:
        pid_t m_pid;
        std::intptr_t m_addr;
        bool m_enabled;
        uint8_t m_saved_data;
    };
}

#endif
