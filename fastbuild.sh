#!/usr/bin/env bash

set -e # 遇到错误立即退出

# 配置默认参数
BUILD_DIR="build"
BUILD_TYPE="Debug"
RUN_TESTS=OFF
CLEAN_FIRST=OFF
CLEAN_ONLY=OFF
BUILD_JOBS=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

# 打印帮助信息
print_usage() {
    echo "Usage: ./fastbuild.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -r, --release      Compile with Release mode (default: Debug)"
    echo "  -d, --debug        Compile with Debug mode"
    echo "  -c, --clean        Clean build directory before compiling"
    echo "  --clean-only       Only remove ${BUILD_DIR} directory and exit"
    echo "  -t, --test         Run ctest after a successful build"
    echo "  -j, --jobs N       Set parallel build jobs (default: ${BUILD_JOBS})"
    echo "  -h, --help         Show this help message"
    echo ""
}

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case "$1" in
        -r|--release)
            BUILD_TYPE="Release"
            shift
            ;;
        -d|--debug)
            BUILD_TYPE="Debug"
            shift
            ;;
        -c|--clean)
            CLEAN_FIRST=ON
            shift
            ;;
        --clean-only)
            CLEAN_ONLY=ON
            shift
            ;;
        -t|--test)
            RUN_TESTS=ON
            shift
            ;;
        -j|--jobs)
            BUILD_JOBS="$2"
            shift 2
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            print_usage
            exit 1
            ;;
    esac
done

# 如果指定了“仅清理”
if [ "${CLEAN_ONLY}" = "ON" ]; then
    echo "==> Removing ${BUILD_DIR} directory and compile_commands.json..."
    rm -rf "${BUILD_DIR}" compile_commands.json
    echo "==> Done."
    exit 0
fi

# 如果指定了编译前先清理
if [ "${CLEAN_FIRST}" = "ON" ]; then
    echo "==> Cleaning ${BUILD_DIR} directory..."
    rm -rf "${BUILD_DIR}" compile_commands.json
fi

# 检查生成器（优先使用高速的 Ninja，没有则退回到 Unix Makefiles）
CMAKE_GENERATOR=""
if command -v ninja >/dev/null 2>&1; then
    CMAKE_GENERATOR="-G Ninja"
fi

echo "========================================"
echo " Project:     server-core"
echo " Build Type:  ${BUILD_TYPE}"
echo " Jobs:        ${BUILD_JOBS}"
echo " Build Dir:   ${BUILD_DIR}"
echo "========================================"

# 1. CMake 配置阶段
cmake -B "${BUILD_DIR}" \
      ${CMAKE_GENERATOR} \
      -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
      -DBUILD_TESTS="${RUN_TESTS}"

# 软链接 compile_commands.json 到根目录，方便 LSP/IDE 索引
if [ -f "${BUILD_DIR}/compile_commands.json" ]; then
    ln -sf "${BUILD_DIR}/compile_commands.json" ./compile_commands.json
fi

# 2. 编译阶段
echo "==> Compiling targets..."
cmake --build "${BUILD_DIR}" -j "${BUILD_JOBS}"

# 3. 运行测试（如果开启）
if [ "${RUN_TESTS}" = "ON" ]; then
    echo "==> Running tests..."
    ctest --test-dir "${BUILD_DIR}" --output-on-failure
fi

echo "==> Build finished successfully."