# Dasher (Rust)

> Rust LLVM-based native compiler with type inference

**Repository:** [eddmann/santa-lang-dasher](https://github.com/eddmann/santa-lang-dasher)
**Version:** 1.0.0

## Overview

Dasher takes an ahead-of-time (AOT) compilation approach, using **LLVM** to compile santa-lang directly to native machine code.

This provides significant performance improvements for computationally intensive puzzles by generating optimized native executables. Type inference enables specialization for native LLVM operations, with unknown types falling back to runtime library calls.

## Downloads

### CLI

| Platform      | Download                                                                                                                                                  |
| ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Linux (x64)   | [`santa-lang-dasher-cli-1.0.0-linux-amd64`](https://github.com/eddmann/santa-lang-dasher/releases/download/1.0.0/santa-lang-dasher-cli-1.0.0-linux-amd64) |
| macOS (Intel) | [`santa-lang-dasher-cli-1.0.0-macos-amd64`](https://github.com/eddmann/santa-lang-dasher/releases/download/1.0.0/santa-lang-dasher-cli-1.0.0-macos-amd64) |
| macOS (ARM)   | [`santa-lang-dasher-cli-1.0.0-macos-arm64`](https://github.com/eddmann/santa-lang-dasher/releases/download/1.0.0/santa-lang-dasher-cli-1.0.0-macos-arm64) |
| Docker        | [`santa-lang-dasher-cli-1.0.0-docker.tar`](https://github.com/eddmann/santa-lang-dasher/releases/download/1.0.0/santa-lang-dasher-cli-1.0.0-docker.tar)   |

## Installation

### Binary Download

```bash
# Download for your platform
curl -L -o santa https://github.com/eddmann/santa-lang-dasher/releases/download/1.0.0/santa-lang-dasher-cli-1.0.0-macos-arm64
chmod +x santa
./santa --help
```

### Docker

```bash
# Load the Docker image
curl -L https://github.com/eddmann/santa-lang-dasher/releases/download/1.0.0/santa-lang-dasher-cli-1.0.0-docker.tar | docker load
docker run --rm santa-lang-dasher-cli:1.0.0 -e '1 + 1'
```

## Supported Runtimes

- [CLI](../cli.md)

## Architecture

```
Source Code → Lexer → Parser → Type Inference → Codegen → LLVM IR → Native Binary
                                                              │
                                                    Embedded Runtime Library
```

Dasher uses a multi-stage compilation pipeline:

1. **Lexer** - Tokenization (shared with other Rust implementations)
2. **Parser** - Pratt parser producing an AST
3. **Type Inference** - Bidirectional type inference with unification
4. **Codegen** - LLVM IR generation using inkwell bindings
5. **LLVM** - Optimization and native code generation

### Type System

Dasher includes a type inference engine that determines types at compile time when possible:

| Type        | Description           |
| ----------- | --------------------- |
| `Int`       | 64-bit signed integer |
| `Decimal`   | 64-bit floating point |
| `String`    | UTF-8 string          |
| `Bool`      | Boolean               |
| `Nil`       | Null value            |
| `List<T>`   | Homogeneous list      |
| `Set<T>`    | Homogeneous set       |
| `Dict<K,V>` | Dictionary            |
| `Function`  | Callable              |
| `Unknown`   | Runtime-typed value   |
| `TypeVar`   | Inference placeholder |

### NaN-Boxing

Values use NaN-boxing for efficient 64-bit representation:

```
┌─────────────────────────────────────────────────────────────────┐
│                        64-bit Value                              │
├──────────────────────────────────────────────────────────────────┤
│ Integers: 61-bit signed integer + 3-bit tag                      │
│ Nil:      Special NaN pattern                                    │
│ Boolean:  Special NaN patterns (true/false)                      │
│ Heap Ptr: 48-bit pointer + tag bits                              │
└──────────────────────────────────────────────────────────────────┘

Heap Objects:
┌────────────┬───────────┬─────────────────────────────────────────┐
│  refcount  │  type_tag │              payload                    │
│  (32-bit)  │  (8-bit)  │           (variable)                    │
└────────────┴───────────┴─────────────────────────────────────────┘
```

### Native vs Runtime Dispatch

Dasher uses a two-path execution model:

**Fast Path (Known Types):**
When types are known at compile time, operations compile directly to LLVM instructions:

```
a + b  →  LLVM add instruction (when a, b are Int)
```

**Slow Path (Unknown Types):**
When types can't be determined, operations fall back to runtime library calls:

```
a + b  →  runtime_add(a, b) (when types are Unknown)
```

### Key Implementation Details

- **Type Inference**: Bidirectional inference with call-site re-inference for polymorphic functions
- **Closures**: Compiled to structures with captured environment
- **Tail-Call Optimization**: Detected at compile time, implemented as jumps
- **Runtime Library**: Embedded compressed library extracted at link time
- **Collections**: Persistent data structures via `im` crate
- **Memoization**: Runtime support for caching expensive function calls

## CLI Usage

```bash
# Run a solution (compile and execute)
santa-cli solution.santa

# Run with tests
santa-cli -t solution.santa

# Evaluate inline expression
santa-cli -e '1 + 2'

# Compile to native executable
santa-cli -c solution.santa
```

## Building from Source

Requires Rust 1.85+ and LLVM 18.

### macOS

```bash
brew install llvm@18
export LLVM_SYS_180_PREFIX=$(brew --prefix llvm@18)
```

### Linux

```bash
apt install llvm-18 llvm-18-dev
export LLVM_SYS_180_PREFIX=/usr/lib/llvm-18
```

### Build

```bash
git clone https://github.com/eddmann/santa-lang-dasher.git
cd santa-lang-dasher
make build    # Debug build
make release  # Release build
make test     # Run tests
```

## See Also

- [Language Specification](../language.md)
- [Built-in Functions](../builtins.md)
- [Full Architecture Documentation](https://github.com/eddmann/santa-lang-dasher/blob/main/docs/ARCHITECTURE.md)
