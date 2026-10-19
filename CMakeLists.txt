# 项目总 CMakeLists.txt 

cmake_minimum_required(VERSION 3.31.6) # 指定cmake编译器最低版本

project(server-core 
        VERSION 1.0.0 
        LANGUAGES CXX C
) # 设置项目名称为server-core，版本为1.0.0，使用的语言为C++和C

set(CMAKE_C_COMPILER "/usr/bin/gcc" CACHE FILEPATH "C compiler" FORCE) # 设置C编译器为gcc，并缓存路径，强制使用该编译器
set(CMAKE_CXX_COMPILER "/usr/bin/g++" CACHE FILEPATH "C++ compiler" FORCE) # 设置C++编译器为g++，并缓存路径，强制使用该编译器

set(CMAKE_CXX_STANDARD 20) # 设置C++标准为C++20
set(CMAKE_CXX_STANDARD_REQUIRED ON) # 设置C++标准为必需
set(CMAKE_CXX_EXTENSIONS ON) # 设置C++扩展为ON，允许使用编译器特定的扩展

include(GNUInstallDirs) # 设置安装目录为GNU标准目录 避免硬编码
include(CMakePackageConfigHelpers) # 生成包配置文件, 支持外部项目find_package(server-core) 来查找该项目

option(BUILD_TESTS "Build tests" ON) # 设置是否构建测试，默认开启

if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE) # 如果没有指定构建类型，则设置默认构建类型为Debug
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build." FORCE)
endif()
set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS Debug Release RelWithDebInfo MinSizeRel) # 设置构建类型为Debug、Release、RelWithDebInfo、MinSizeRel四种类型
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}") # 输出构建类型

cmake_host_system_information(RESULT CPU_NUMS QUERY NUMBER_OF_LOGICAL_CORES) # 获取当前服务器的CPU数量，并将结果存储在CPU_NUMS变量中
message(STATUS "CPU NUMS on current server is: ${CPU_NUMS}") # 输出当前服务器的CPU数量
math(EXPR JOBS "${CPU_NUMS} * 1") # 将CPU数量乘以1，存储在JOBS变量中
set(CMAKE_BUILD_PARALLEL_LEVEL ${JOBS} CACHE STRING "并行编译线程数") # 设置并行编译线程数为CPU数量乘以1，并缓存该值
message(STATUS "Compilor default work jobs: ${CMAKE_BUILD_PARALLEL_LEVEL}") # 输出并行编译线程数

include(cmake/ServerCoreOptions.cmake) # 包含编译器选项配置文件

add_subdirectory(server-core) # 添加 server-core 目录
if(BUILD_TESTS)
    enable_testing() # 启用测试功能
    add_subdirectory(tests) # 添加测试目录
endif()
