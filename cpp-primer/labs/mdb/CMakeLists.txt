cmake_minimum_required (VERSION 3.0)
project (MiniDbg)

add_compile_options(-Wall -Wextra)
set(CMAKE_CXX_FLAGS "-std=c++14 -Wno-unused-parameter ${CMAKE_CXX_FLAGS}")
message(STATUS "optional:-std=c++14")   

include_directories(lib/libelfin lib/linenoise include)
add_executable(minidbg src/minidbg.cpp lib/linenoise/linenoise.c)
set_target_properties(minidbg
                      PROPERTIES COMPILE_FLAGS "-g")

add_executable(hello examples/hello.cpp)
set_target_properties(hello
                      PROPERTIES COMPILE_FLAGS "-g -O0")

add_executable(variable examples/variable.cpp)
set_target_properties(variable
                      PROPERTIES COMPILE_FLAGS "-gdwarf-2 -O0 -Wno-unused-variable")

add_executable(unwinding examples/stack_unwinding.cpp)
set_target_properties(unwinding
                      PROPERTIES COMPILE_FLAGS "-g -O0 -Wno-unused-variable")


add_custom_target(
   libelfin
   COMMAND make
   WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/lib/libelfin
)
target_link_libraries(minidbg
                      ${PROJECT_SOURCE_DIR}/lib/libelfin/dwarf/libdwarf++.so
                      ${PROJECT_SOURCE_DIR}/lib/libelfin/elf/libelf++.so)
add_dependencies(minidbg libelfin)
