# Donner (Kotlin)

> Kotlin JVM bytecode compiler with Java interop

**Repository:** [eddmann/santa-lang-donner](https://github.com/eddmann/santa-lang-donner)
**Version:** 1.0.3

## Overview

Donner compiles santa-lang directly to **JVM bytecode** using the ASM library. Programs are compiled to Java `.class` files that run on any Java 21+ runtime, benefiting from JVM optimizations and JIT compilation.

The implementation uses persistent data structures throughout and includes full support for the AoC runner with test blocks and memoization. Uniquely, Donner provides **Java interop functions** for seamless integration with the Java ecosystem.

## Downloads

### CLI

| Platform      | Download                                                                                                                                                                |
| ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Linux (x64)   | [`santa-lang-donner-cli-1.0.3-linux-amd64.tar.gz`](https://github.com/eddmann/santa-lang-donner/releases/download/1.0.3/santa-lang-donner-cli-1.0.3-linux-amd64.tar.gz) |
| macOS (Intel) | [`santa-lang-donner-cli-1.0.3-macos-amd64.tar.gz`](https://github.com/eddmann/santa-lang-donner/releases/download/1.0.3/santa-lang-donner-cli-1.0.3-macos-amd64.tar.gz) |
| macOS (ARM)   | [`santa-lang-donner-cli-1.0.3-macos-arm64.tar.gz`](https://github.com/eddmann/santa-lang-donner/releases/download/1.0.3/santa-lang-donner-cli-1.0.3-macos-arm64.tar.gz) |
| JAR           | [`santa-lang-donner-cli-1.0.3.jar`](https://github.com/eddmann/santa-lang-donner/releases/download/1.0.3/santa-lang-donner-cli-1.0.3.jar)                               |
| Docker        | `docker pull ghcr.io/eddmann/santa-lang-donner:cli-latest`                                                                                                              |

## Installation

### Using Docker (Recommended)

```bash
docker run --rm ghcr.io/eddmann/santa-lang-donner:cli-latest -e '1 + 1'
```

### Binary Download

```bash
# Download and extract for your platform
curl -L https://github.com/eddmann/santa-lang-donner/releases/download/1.0.3/santa-lang-donner-cli-1.0.3-macos-arm64.tar.gz | tar xz
./santa-cli --help
```

### JAR (Requires Java 21+)

```bash
curl -L -o santa-cli.jar https://github.com/eddmann/santa-lang-donner/releases/download/1.0.3/santa-lang-donner-cli-1.0.3.jar
java -jar santa-cli.jar --help
```

## Supported Runtimes

- [CLI](../cli.md)

## Architecture

```
Source Code → Lexer → Parser → Desugar → Resolver → Bytecode Gen (ASM) → JVM
                                                          │
                                                    In-Memory Classes
                                                    (ScriptClassLoader)
```

Donner uses a multi-stage compilation pipeline:

1. **Lexer** - Tokenization with position tracking
2. **Parser** - Pratt parser producing an AST
3. **Desugaring** - Three passes: placeholder (`_`), pipeline (`|>`), pattern parameters
4. **Resolver** - Two-pass scope resolution with forward reference support
5. **Bytecode Generation** - JVM bytecode via ASM 9.7

### Desugaring Passes

| Pass                  | Transformation                                   |
| --------------------- | ------------------------------------------------ |
| PlaceholderDesugarer  | `_ + 1` → `\|$0\| $0 + 1`                        |
| PipelineDesugarer     | `a \|> f` → `f(a)`                               |
| PatternParamDesugarer | `\|[a, b]\| ...` → `\|$p\| let [a, b] = $p; ...` |

### In-Memory Compilation

Donner compiles directly to in-memory `.class` files without touching the filesystem:

```
CompiledScript {
    mainClass: ByteArray,          // Main script class
    lambdaClasses: Map<String, ByteArray>  // Lambda inner classes
}
```

A custom `ScriptClassLoader` loads these classes for execution.

### Value System

All runtime values implement a sealed `Value` interface:

| Type          | Backing Implementation                         |
| ------------- | ---------------------------------------------- |
| IntValue      | `Long`                                         |
| DecimalValue  | `Double`                                       |
| StringValue   | `String` (grapheme-cluster indexed)            |
| BoolValue     | `Boolean`                                      |
| NilValue      | Singleton                                      |
| ListValue     | `kotlinx.collections.immutable.PersistentList` |
| SetValue      | `kotlinx.collections.immutable.PersistentSet`  |
| DictValue     | `kotlinx.collections.immutable.PersistentMap`  |
| FunctionValue | Compiled lambda class                          |

## Java Interop

Donner includes functions for seamless Java integration:

| Function                              | Description                           |
| ------------------------------------- | ------------------------------------- |
| `require(className)`                  | Load a Java class by name             |
| `java_new(class, ...args)`            | Create instance with constructor      |
| `java_call(object, method, ...args)`  | Call instance method                  |
| `java_static(class, method, ...args)` | Call static method                    |
| `method(name)`                        | Create method reference for pipelines |
| `static_method(class, name)`          | Create static method reference        |

### Example: Java Interop

```santa
let ArrayList = require("java.util.ArrayList");
let list = java_new(ArrayList);
java_call(list, "add", "hello");
java_call(list, "add", "world");
java_call(list, "size") // => 2

// Pipeline-friendly methods
let StringBuilder = require("java.lang.StringBuilder");
java_new(StringBuilder)
  |> method("append")("Hello, ")
  |> method("append")("World!")
  |> method("toString")
  // => "Hello, World!"
```

### Type Conversion

Values are automatically converted between santa-lang and Java:

| santa-lang | Java               |
| ---------- | ------------------ |
| Integer    | `Long` / `Integer` |
| Decimal    | `Double`           |
| String     | `String`           |
| Boolean    | `Boolean`          |
| List       | `List<?>`          |
| Dict       | `Map<?, ?>`        |
| Nil        | `null`             |

## CLI Usage

Requires Java 21+.

```bash
# Run a solution
santa-cli solution.santa

# Run with tests
santa-cli -t solution.santa
```

## Building from Source

Requires Java 21+ and Gradle.

```bash
git clone https://github.com/eddmann/santa-lang-donner.git
cd santa-lang-donner
make build      # Build CLI
make test       # Run tests
make cli/jar    # Build fat JAR
```

## See Also

- [Language Specification](../language.md)
- [Built-in Functions](../builtins.md)
- [Full Architecture Documentation](https://github.com/eddmann/santa-lang-donner/blob/main/docs/ARCHITECTURE.md)
