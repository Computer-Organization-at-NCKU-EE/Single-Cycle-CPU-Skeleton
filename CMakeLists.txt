# CMake version requirements
cmake_minimum_required(VERSION 3.21...3.28)
if(${CMAKE_VERSION} VERSION_LESS 3.28)
    cmake_policy(VERSION ${CMAKE_MAJOR_VERSION} ${CMAKE_MINOR_VERSION})
endif()

# project information
project("Single-Cycle-CPU" VERSION 0.1.0
        DESCRIPTION "Single-Cycle CPU RTL Implementation whhich supports RV32I instructions."
        LANGUAGES CXX)

# set C standard
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# file list
set(RTL_SRCS
    src/DEF.sv
    src/Intf.sv
    src/BranchComp.sv
    src/ImmExt.sv
    src/LDFilter.sv
    src/ALU.sv
    src/ProgramCounter.sv
    src/RegFile.sv
    src/Controller.sv
    src/ROM.sv
    src/CoreTop.sv
    src/RAM.sv
    src/TextBuffer.sv
    src/Halt.sv
    src/Top.sv
)

# verilator related
find_package(verilator HINTS ${VERILATOR_ROOT})
add_executable(verilator_sim src/sim_main.cpp)
verilate(verilator_sim
         PREFIX VTestbench
         TOP_MODULE DriveTop
         TRACE_FST
         SOURCES ${RTL_SRCS}
         VERILATOR_ARGS -sv --timing -trace-structs
)
