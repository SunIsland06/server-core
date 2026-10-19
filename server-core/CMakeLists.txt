# server-core/CMakeLists.txt

file(GLOB_RECURSE SCORE_SRCS CONFIGURE_DEPENDS *.cpp *.c)
file(GLOB_RECURSE SCORE_HDRS CONFIGURE_DEPENDS *.hpp *.h)

add_library(server-core STATIC ${SCORE_SRCS} ${SCORE_HDRS})

target_include_directories(server-core
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/server-core
)

target_link_libraries(server-core PUBLIC server-core-options) # 继承所有编译/链接选项

target_compile_options(server-core PRIVATE
    $<$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>:
        -Werror # 将编译过程所有警告视为错误
    >
)

install(TARGETS server-core
    EXPORT server-core_targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(FILES ${SCORE_HDRS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/server-core
)