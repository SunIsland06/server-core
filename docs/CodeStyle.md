已将“`class` / `struct` 比所属的 `namespace` 多缩进一次（4 个空格）”的规则同步更新到排版约束、示例代码及 AI Agent 指令模版中。同时由于类本身相对命名空间缩进 4 格，类内部的访问控制修饰符（`public:`/`private:`）以及成员函数/变量的相对缩进层级也相应递增对齐。

---

# 项目代码风格指南 (Project Code Style Guide)

本规范用于约束由 AI Agent 或开发者编写的 C++ 代码，旨在保证代码风格高度统一、语法严密、杜绝常见内存与并发陷阱，并适配高性能服务端开发标准。

---

## 1. 命名规范 (Naming Conventions)

| 实体类别 | 命名风格 | 示例 / 说明 |
| --- | --- | --- |
| **文件名 (源文件/头文件)** | `PascalCase` | 例：`TaskQueue.hpp`, `TaskQueue.cpp`, `Logger.cpp` |
| **头文件扩展名** | `.hpp` | 统一且强制使用 `.hpp` |
| **源文件扩展名** | `.cpp` | 统一且强制使用 `.cpp` |
| **命名空间 (Namespace)** | 嵌套小写 (`snake_case`) | 例：`namespace owner::project::network` |
| **类 / 结构体 / 概念 (Concept)** | `PascalCase` | 例：`TaskQueue`, `SessionContext` |
| **函数 / 成员方法 / 自由函数** | `camelCase` | 例：`executeTask()`（类成员方法、自由函数、静态方法均统一） |
| **局部变量** | `camelCase` | 例：`bufferSize`, `retryCount` |
| **普通成员变量** | `camelCase` | 命名采用 `camelCase`；在普通成员函数体内访问时**无例外强制显式**加上 `this->`（例：`this->bufferSize`）；在构造函数初始化列表中直接书写成员名 |
| **函数入参** | `camelCase` | **仅构造函数的入参强制添加尾部下划线 `_in`**（例：`Task(int taskId_in)`）；其余所有普通函数与成员方法的入参**严禁**添加 `_in` 后缀，保持标准 `camelCase`（例：`void update(int taskId, const std::string& taskName)`） |
| **类静态变量** | `camelCase` | 访问强制通过类名作用域限定（例：`TaskQueue::activeCount`） |
| **常量 / constexpr** | `ALL_CAPS` | 例：`MAX_BUFFER_SIZE`, `DEFAULT_TIMEOUT_MS` |
| **枚举类型 (Enum Class)** | 类型名: `PascalCase` 枚举项: `PascalCase` | 例：`enum class ConnectionState { Disconnected, Connecting, Connected };` |
| **模板参数** | 大写单字母 | 例：`typename T`, `typename U` |

---

## 2. 格式与排版约束 (Formatting & Spacing)

### 缩进与制表符

* **严禁使用制表符 (Tab)**，所有缩进必须使用 **4 个空格**。

### 命名空间与类层级缩进

* **命名空间内部顶层实体缩进**：位于 `namespace` 内部的 `class`、`struct` 等定义，**必须相较于 `namespace` 多缩进一次（4 个空格）**。
* **访问控制修饰符缩进**：类内的 `public:`、`protected:`、`private:` 关键字相较于所在的 `class` **再缩进一次（4 个空格）**。
* **类成员缩进**：成员函数声明、成员变量相较于所在的访问修饰符**再缩进一次（4 个空格）**。

```cpp
namespace owner::project::network {

    class TaskWorker {
        public:
            void start();

        private:
            int workerId;
    };

}

```

### 大括号与控制流风格 (K&R 风格)

* **大括号位置**：控制语句（`if`, `else`, `for`, `while`, `switch`）及函数定义的开括号 `{` 必须与语句在**同一行**；闭括号 `}` 必须**独立成行**，并与对应的控制关键字纵向对齐。
* **强制使用复合语句块**：即使 `if`、`else`、`for`、`while` 的语句体只有一行代码，**也必须使用完整的大括号 `{}` 包裹**，严禁省略。

### 符号与空格细节

* **二元运算符**：两侧必须加空格。例：`a + b`, `x == y`, `i < count`, `value = 10`。
* **一元运算符**：不加空格。例：`!flag`, `&ptr`, `*deref`, `++i`, `--j`。
* **括号内部**：圆括号 `()`、方括号 `[]`、花括号 `{}` 内部两侧不加空格。例：`func(arg1, arg2)`, `array[index]`, `{1, 2, 3}`。
* **逗号与分号**：紧跟前面字符，后面加空格。例：`func(arg1, arg2);`, `for (int i = 0; i < count; ++i) {`。
* **模板参数**：尖括号 `< >` 内部两侧不加空格。例：`template <typename T>`, `std::vector<int>`。
* **指针与引用声明**：`*` 或 `&` **必须紧贴类型名**，与后续变量名之间留一个空格。例：`const std::string& foo`, `int* ptr`。

---

## 3. 文件组织与包含规范 (File Structure & Includes)

### 头文件保护机制

* 强制使用传统宏守卫，命名格式为 `PROJECT_PATH_FILE_HPP`（全大写、下划线分隔，后缀统一为 `HPP`）。

```cpp
#ifndef INCLUDE_SERVER_CORE_TASK_QUEUE_HPP
#define INCLUDE_SERVER_CORE_TASK_QUEUE_HPP

// 内容...

#endif

```

### 命名空间组织

* 命名空间必须采用 **C++17 双冒号嵌套小写写法**（例：`namespace owner::project::network`）。
* 内部声明的类和结构体依照第 2 节规定缩进 4 空格。

### 声明与实现严格分离原则

* **常规类与函数**：非模板类、非内联函数的类声明与成员方法签名必须置于 `.hpp` 中，函数体具体实现必须置于同名 `.cpp` 文件中。严禁在头文件中直接定义常规业务函数体。
* **模板与内联函数**：模板类、模板函数以及显式标记 `inline` 的极简轻量函数允许在头文件中实现。若模板实现代码较长，建议将声明置于 `FileName.hpp`，实现剥离至 `FileName-inl.hpp` 或 `FileNameImpl.hpp` 并在头文件底部引入。
* **禁止复杂内联**：严禁在头文件中直接内联包含复杂循环、重度业务分支等长逻辑。

### 包含顺序（自顶向下，组与组之间空一行）

1. 当前实现文件对应的 `.hpp` 头文件（**强制置于首位**，用于自动验证头文件自包含性）
2. 本项目内部依赖库头文件（使用项目根目录相对路径，如 `#include "network/Session.hpp"`）
3. 第三方依赖库头文件（如 Boost, fmt, abseil 等）
4. C++ 标准库头文件（`<vector>`, `<memory>`, `<string>` 等）
5. C 运行时系统头文件（`<sys/types.h>`, `<unistd.h>`, `<cstring>` 等）

### 包含约束

* **严禁命名空间污染**：**严禁**在头文件中使用 `using namespace ...;`。在 `.cpp` 源文件中也仅允许在函数体局部或限定作用域内使用。
* **前置声明优先（Forward Declaration）**：头文件中若仅使用指针（`T*`）、引用（`T&`）或智能指针（配合 `.cpp` 析构），优先使用 `class T;` 前置声明，避免无节制 `#include` 完整头文件。
* **自包含性保证（Self-contained）**：任何 `.hpp` 独立被单编译单元包含时，必须能够独立通过编译，绝不隐式依赖外部先行包含的任何头文件。

---

## 4. 类型设计与构造规范 (Type Design & Construction)

### Struct 与 Class 的选型原则

* **`struct`**：仅用于**纯粹的聚合数据载体（Plain Data / DTO / POD）**。当类型只包含公共数据成员，没有复杂的不变式检查、业务行为或私有状态时，强制使用 `struct`。
* **`class`**：当类型具有私有状态、需要封装数据或包含复杂成员方法、虚函数多态时，强制使用 `class`。

### 特殊成员函数与生命周期（Rule of Five / Rule of Zero）

* **零法则优先 (Rule of Zero)**：若类可以通过标准库容器与智能指针完成资源自动管理，不应显式声明任何析构函数或拷贝/移动操作。
* **五法则约束 (Rule of Five)**：若因底层资源管理需要**手动定义了析构函数、拷贝构造函数、拷贝赋值操作符、移动构造函数、移动赋值操作符中的任意一个，必须对其余所有成员显式声明为 `= default` 或 `= delete`**，严禁依赖编译器隐式生成或隐式抑制。

```cpp
namespace owner::project::core {

    class ResourceHandler {
        public:
            ResourceHandler();
            virtual ~ResourceHandler(); // 手动定义了析构

            // 其余 4 个特殊成员函数必须显式声明
            ResourceHandler(const ResourceHandler& other_in) = delete;
            ResourceHandler& operator=(const ResourceHandler& other_in) = delete;
            ResourceHandler(ResourceHandler&& other_in) noexcept = default;
            ResourceHandler& operator=(ResourceHandler&& other_in) noexcept = default;
    };

}

```

### 构造函数与成员变量访问规则

* **初始化列表语法与 `this->` 的边界**：
* 在**构造函数初始化列表中**，语法层面无法使用 `this->`，必须**直接书写成员变量名**完成初始化。
* 在**其余所有成员函数体内**（包括普通成员方法、构造函数体、析构函数体），访问普通成员变量**无例外强制显式书写 `this->`**（例：`this->taskId = 10;`）。


* **强制在初始化列表中完成所有成员初始化**：禁止在构造函数体内做无意义的赋值。
* **多行格式严格对齐**：
* **单行形式**（成员较少时）：
```cpp
MyClass::MyClass(int id_in, const std::string& name_in) : id(id_in), name(name_in) {
}

```


* **多行形式**（成员较多时，冒号占行尾或首个成员前，各成员独立成行并严格缩进对齐）：
```cpp
MyClass::MyClass(int id_in, const std::string& name_in, bool isValid_in) : 
    id(id_in),
    name(name_in),
    isValid(isValid_in),
    creationTime(getCurrentTime()) {
}

```





---

## 5. 内存管理与所有权 (Memory & Ownership)

### 空指针规范

* **始终使用** `nullptr`，严禁使用 `NULL` 或整数 `0` 表示空指针。

### 裸指针策略

* **严禁使用** `new` / `delete` 进行手动的堆内存生命周期管理。
* 裸指针 `T*` 仅作为不拥有所有权（Non-owning）的可空引用借用传参。函数体入口必须对入参指针进行 `nullptr` 检查。

### 智能指针规范

* **独占所有权**：强制使用 `std::unique_ptr<T>`，统一使用 `std::make_unique<T>` 创建。
* **共享所有权**：仅在明确需要多方共享时使用 `std::shared_ptr<T>`，使用 `std::make_shared<T>`。
* **破除循环引用**：持有共享资源的不拥有者时，强制使用 `std::weak_ptr<T>`。

### 视图与容器传递

* 只读字符串优先入参：`std::string_view`。
* 连续内存切片优先入参：`std::span<T>`（C++20）或 `const std::vector<T>&`。
* 基础 POD 类型**按值传递**（`int`, `double`, `bool` 等），重量级对象按 `const T&` 传递，需要移动转移所有权的使用 `T&&`。

---

## 6. 现代 C++ 语言特性约束 (Modern C++ Practices)

### 类型推导 (`auto`)

* 仅在**迭代器、极长模板类型、Lambda 表达式**中使用 `auto`；基础数据类型、常规对象构建保持显式类型声明。

### 构造函数与 explicit

* **除了拷贝构造函数和移动构造函数外，所有单参数构造函数必须显式标记为 `explicit`**，严禁发生隐式类型转换。

```cpp
namespace owner::project::network {

    class DataBuffer {
        public:
            // 单参数构造函数必须显式 explicit
            explicit DataBuffer(size_t initialCapacity_in);

            // 拷贝构造与移动构造函数除外，不需要 explicit
            DataBuffer(const DataBuffer& other_in);
            DataBuffer(DataBuffer&& other_in) noexcept;
    };

}

```

### 虚函数修饰

* 包含虚函数的基类必须显式声明虚析构函数：`virtual ~Base() = default;`。
* 派生类重写虚函数时**强制且仅标记** `override`（无需再写 `virtual`）。
* 禁止继承的类或虚函数标记 `final`。

### 常量与初始化

* 能够在编译期计算的变量与函数，强制修饰为 `constexpr` / `consteval`。
* 局部变量若无需修改，尽可能声明为 `const`。
* 优先采用类内就地初始化（In-class member initializers）。

### 类型转换（Casting）

* **严禁使用** C 风格强制转换 `(int)x`。
* 必须根据语义使用现代 C++ 类型转换操作符：`static_cast`, `reinterpret_cast`, `const_cast`, `dynamic_cast`。

---

## 7. 错误处理与控制流 (Error Handling)

### 错误处理体系

* **异常体系（Exceptions）**：采用标准库派生自定义异常或直接复用 `std::invalid_argument` / `std::runtime_error`；针对业务可恢复错误抛出异常，要求保证基本异常安全保证（Basic Exception Safety）。

### 返回值丢失防御

* 具有关键返回值且调用方丢弃会导致状态错乱或资源泄漏的函数，强制添加 `[[nodiscard]]`。

---

## 8. 性能与并发安全 (Performance & Concurrency)

### 移动语义与传值

* 明确要求利用 `std::move` 与 `std::forward` 实现高效完美转发与资源转移。
* 移动构造函数和移动赋值操作符**必须标记** `noexcept`。
* `noexcept` **安全边界**：移动操作必须依赖底层不抛异常的资源置换完成；严禁在移动构造/赋值中吞噬异常导致对象处于残缺或破坏类不变量的非法状态。

### 线程安全

* 数据保护强制采用 RAII 锁守卫：`std::lock_guard`, `std::unique_lock`, `std::scoped_lock`（C++17）。
* 共享变量原子操作必须明确指定内存序（无特殊要求默认使用安全序，如 `std::memory_order_seq_cst` 或经过评审的宽松序）。

---

## 9. 注释与文档规范 (Documentation & Comments)

### 通用注释排版铁律

* **代码行内严禁出现注释**：禁止在代码行尾追加注释（例如 `int count = 0; // 计数器` 为严格禁止）。
* **所有注释必须单独成行**：所有注释必须独立成行，书写在对应目标代码实体的上一行。

### 注释分类与具体风格

1. **文件注释 (File-level Comments)**：
* 必须位于文件最顶端，所有行均使用 `// ` 开头（单独成行）。
* 涵盖内容：文件的相对路径、整体内容、核心用途，以及可选的版权信息、作者信息、最后编辑时间等。


```cpp
// filepath: include/network/TaskQueue.hpp
// Description: 异步网络任务队列核心模块，负责多线程任务的分发与调度
// Author: ServerTeam
// Last Modified: 2026-10-21

```


2. **类 / 结构体注释 (Class/Struct Comments)**：
* 位于类或结构体定义的上一行，使用 `// ` 开头（单独成行）。
* 描述类的主要职责、设计意图及并发安全假设。


```cpp
namespace owner::project::network {

    // 负责管理长连接会话的生命周期，保证多线程投递事件时的线程安全性
    class SessionManager {

```


3. **函数注释 (Function Comments - Doxygen 格式)**：
* **仅在声明处书写（写在 `.hpp` 头文件中）**，`.cpp` 实现处严禁重复书写，避免双重维护。
* 采用标准 Doxygen 格式（`/** ... */`），详细说明函数功能、`@param` 参数说明、`@return` 返回值、`@throws` 可能抛出的异常类型及触发条件。


```cpp
    /**
     * @brief 异步投递一个网络处理任务到当前队列
     * @param taskId 任务唯一标识符
     * @param payload 任务承载的只读二进制数据切片
     * @return 成功投递返回 true，队列已满返回 false
     * @throws std::invalid_argument 当 payload 为空且任务类型要求载荷时抛出
     */
    bool postTask(int taskId, std::span<const uint8_t> payload);

```


4. **变量注释 (Variable Comments)**：
* 仅用于解释含义复杂、业务特定或变量名无法完全表达意图的变量。
* 位于变量声明的上一行，使用 `// ` 开头（单独成行）。


```cpp
    // 记录滑动窗口的右边界索引，用于网络流控的重传计算
    int slidingWindowEndIndex;

```


5. **实现内部注释 (Implementation Comments)**：
* 仅在 `.cpp` 函数实现内部，针对**复杂算法、巧妙技巧、不直观的逻辑或有特定性能/并发安全考量**的代码段进行解释，严禁复述代码字面逻辑。
* 位于目标代码行的上一行，使用 `// ` 开头（单独成行）。


```cpp
// 此处使用无锁内存序 acquire 保证后续读取能看到工作线程写入的最新状态
if (this->flag.load(std::memory_order_acquire)) {

```


6. **TODO 注释 (Task / Optimization Comments)**：
* 用于标注待完成或待优化的任务与技术债务。
* 独立成行，统一格式为 `// TODO: 任务具体描述`。


```cpp
// TODO: 后续引入 SIMD 指令集重构此处的批量位运算以降低延迟

```



---

## 10. 注入 AI Agent 的机器指令模版 (Directives for Agent)

```markdown
### C++ Coding Directives for AI Agent:
1. Architecture & Files:
   - Header extension MUST be .hpp, source MUST be .cpp.
   - Use `#ifndef PROJECT_PATH_FILE_HPP` macro guards for headers.
   - Strict separation of declaration and implementation: Place prototypes/declarations in .hpp and concrete implementations in .cpp. Do not implement non-template/non-inline methods in .hpp.
   - Namespaces must use C++17 nested lowercase syntax: `namespace owner::project::network`.
   - Ordering: Include corresponding .hpp first in .cpp, followed by project headers, third-party libraries, STL, and C runtime headers.
2. Formatting & Syntax:
   - Indent strictly with 4 spaces. NEVER use tabs.
   - Namespace and Class Indentation:
     * `class` and `struct` inside a namespace MUST be indented by 4 spaces relative to the `namespace`.
     * Access specifiers (`public:`, `protected:`, `private:`) MUST be indented by another 4 spaces relative to the `class`.
     * Members inside sections MUST be indented by another 4 spaces relative to the access specifiers.
   - K&R brace style: Opening brace `{` on the same line; closing brace `}` on its own line aligned with the statement keyword.
   - ALWAYS use braces `{}` for control blocks (if, else, for, while), even for single-line statements.
   - Spacing: 1 space around binary operators (+, -, ==, =, etc.). NO space inside parentheses, brackets, or braces. Pointer/reference symbols (`*`, `&`) must bind to the type (`int* ptr`, `const std::string& str`).
3. Naming & Access:
   - Types, concepts, file names: PascalCase.
   - Functions, local variables, member variables: camelCase.
   - Constants, constexpr: ALL_CAPS.
   - Enum classes: PascalCase type name and PascalCase enumerators.
   - Parameter Naming: ONLY constructor parameter names MUST end with the `_in` suffix (e.g., `Task(int id_in) : id(id_in) {}`). Regular functions and member methods MUST NOT use `_in` (use standard camelCase: `void run(int taskId)`).
   - Strict Member Access: Inside constructor initialization lists, write member names directly WITHOUT `this->` (e.g., `: id(id_in)`). Inside ALL other member function bodies, ALWAYS access non-static class member variables via `this->` (e.g., `this->size = 0;`). Never use `m_` prefixes.
   - Static Variables: Access static class variables via class scope (e.g., `TaskQueue::activeCount`).
4. Type & Constructor Design:
   - Use `struct` ONLY for pure passive data carriers (POD/DTO). Use `class` when having private invariants or complex behavior.
   - Rule of Five: If manually defining ANY of destructor, copy constructor, copy assignment, move constructor, or move assignment, you MUST explicitly declare the remaining four as either `= default` or `= delete`.
   - Single-argument constructors MUST be marked `explicit`, EXCEPT for copy and move constructors.
   - ALWAYS initialize all member variables in the constructor initializer list. For multiple members, put each member on its own indented line.
   - Polymorphic base classes must declare `virtual ~Base() = default;`. Overridden methods MUST be marked with `override` only.
5. Memory & Performance:
   - NEVER use `new`/`delete`. Use RAII, `std::unique_ptr`, `std::shared_ptr`.
   - Always use `nullptr`, never `NULL` or `0`.
   - Read-only string parameters must use `std::string_view`. Contiguous data slices must use `std::span` (C++20) or `const std::vector<T>&`.
   - Small POD types pass by value; heavy objects pass by `const T&`; ownership transfers use `T&&` with `std::move`.
   - Move constructors and move assignment operators MUST be marked `noexcept`.
6. Documentation & Comments:
   - NEVER use inline comments at the end of a line of code. Every comment MUST be on its own line preceding the code.
   - Doxygen comments (`/** ... */`) describing @brief, @param, @return, and @throws are ONLY written above function declarations in `.hpp`. Do not duplicate in `.cpp`.
   - Use `// ` on its own line for file headers, class responsibilities, complex variables, and non-obvious implementation details.
   - Use `// TODO: description` on its own line for pending items.

```