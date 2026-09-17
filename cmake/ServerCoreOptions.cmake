# cmake/ServerCoreOptions.cmake

add_library(sCore_options INTERFACE)

target_compile_options(sCore_options INTERFACE
    # GCC/Clang
    $<$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>:
        -Wall   # 开启所有警告 
        -Wextra    # 开启额外警告 
        -Wpedantic    # 开启严格的标准兼容性警告
        -fno-strict-aliasing    # 关闭严格别名规则
    >
)

target_compile_options(sCore_options INTERFACE
    $<$<AND:$<PLATFORM_ID:Linux>,$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>>:
        -fPIC   # 生成位置无关代码
    >
)

target_link_options(sCore_options INTERFACE
    $<$<AND:$<PLATFORM_ID:Linux>,$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>>:
        -rdynamic    # 栈回溯,解析出人类可读的函数名称
    >
)

target_compile_definitions(sCore_options INTERFACE
    $<$<CONFIG:Debug>:sCore_DEBUG>   # Debug模式下定义DEBUG宏
)

target_compile_options(sCore_options INTERFACE 
    $<$<CONFIG:Debug>:-O0>   # Debug模式下关闭优化
    $<$<CONFIG:Debug>:-g3>    # Debug模式下开启更多调试信息
    $<$<CONFIG:Debug>:-ggdb>    # Debug模式下开启GDB调试信息
)

target_compile_options(sCore_options INTERFACE
    $<$<CONFIG:Release>:-DNDEBUG>   # Release模式下定义NDEBUG宏
    $<$<CONFIG:Release>:-O2>   # Release模式下开启O2优化
    $<$<CONFIG:Release>:-fno-omit-frame-pointer>   # Release模式下保留帧指针

    $<$<CONFIG:RelWithDebInfo>:-DNDEBUG>   # RelWithDebInfo模式下定义NDEBUG宏
    $<$<CONFIG:RelWithDebInfo>:-O2>  # RelWithDebInfo模式下开启O2优化
    $<$<CONFIG:RelWithDebInfo>:-g>  # RelWithDebInfo模式下开启调试信息
    $<$<CONFIG:RelWithDebInfo>:-fno-omit-frame-pointer> # RelWithDebInfo模式下保留帧指针
)

option(ENABLE_COVERAGE "Enable code coverage instrumentation" OFF)
if(ENABLE_COVERAGE)
    target_compile_options(sCore_options INTERFACE
        $<$<CONFIG:Debug>:--coverage>
    )
    target_link_options(sCore_options INTERFACE
        $<$<CONFIG:Debug>:--coverage>
    )
endif()