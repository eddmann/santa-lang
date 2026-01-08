# Blitzen (Rust)

> Rust bytecode VM with FrostByte compilation

**Repository:** [eddmann/santa-lang-blitzen](https://github.com/eddmann/santa-lang-blitzen)
**Version:** 1.0.1

## Overview

Blitzen takes a different approach from tree-walking interpretation by compiling santa-lang to **FrostByte bytecode** and executing it on a stack-based virtual machine.

This bytecode compilation approach explores a different execution model for potential performance improvements over tree-walking interpretation, particularly for computationally intensive puzzles. The bytecode format is portable and can be serialized for caching.

## Downloads

### CLI

| Platform      | Download                                                                                                                                                     |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Linux (x64)   | [`santa-lang-blitzen-cli-1.0.1-linux-amd64`](https://github.com/eddmann/santa-lang-blitzen/releases/download/1.0.1/santa-lang-blitzen-cli-1.0.1-linux-amd64) |
| Linux (ARM)   | [`santa-lang-blitzen-cli-1.0.1-linux-arm64`](https://github.com/eddmann/santa-lang-blitzen/releases/download/1.0.1/santa-lang-blitzen-cli-1.0.1-linux-arm64) |
| macOS (Intel) | [`santa-lang-blitzen-cli-1.0.1-macos-amd64`](https://github.com/eddmann/santa-lang-blitzen/releases/download/1.0.1/santa-lang-blitzen-cli-1.0.1-macos-amd64) |
| macOS (ARM)   | [`santa-lang-blitzen-cli-1.0.1-macos-arm64`](https://github.com/eddmann/santa-lang-blitzen/releases/download/1.0.1/santa-lang-blitzen-cli-1.0.1-macos-arm64) |
| Docker        | `docker pull ghcr.io/eddmann/santa-lang-blitzen:cli-latest`                                                                                                  |

## Installation

### Using Docker (Recommended)

```bash
docker run --rm ghcr.io/eddmann/santa-lang-blitzen:cli-latest -e '1 + 1'
```

### Binary Download

```bash
# Download for your platform
curl -L -o santa https://github.com/eddmann/santa-lang-blitzen/releases/download/1.0.1/santa-lang-blitzen-cli-1.0.1-macos-arm64
chmod +x santa
./santa --help
```

## Supported Runtimes

- [CLI](../cli.md)

## Architecture

```
Source Code → Lexer → Parser → Compiler → FrostByte Bytecode → Blitzen VM → Result
                                                                    │
                                                              Stack + Globals
                                                              + Upvalues
```

Blitzen uses a compilation pipeline that transforms source code into bytecode before execution:

1. **Lexer** - Tokenization (shared with other Rust implementations)
2. **Parser** - Pratt parser producing an AST
3. **Compiler** - Transforms AST to FrostByte bytecode with scope resolution
4. **VM** - Stack-based execution engine

### FrostByte Bytecode

FrostByte is a custom bytecode format designed for santa-lang. Key instruction categories:

| Category    | Instructions                                                                       |
| ----------- | ---------------------------------------------------------------------------------- |
| Stack       | `Constant`, `Pop`, `Dup`, `Nil`, `True`, `False`                                   |
| Variables   | `GetLocal`, `SetLocal`, `GetGlobal`, `SetGlobal`, `GetUpvalue`, `SetUpvalue`       |
| Arithmetic  | `Add`, `Sub`, `Mul`, `Div`, `Mod`, `Neg`                                           |
| Collections | `MakeList`, `MakeSet`, `MakeDict`, `MakeRange`, `Index`, `Slice`, `Size`, `Spread` |
| Functions   | `MakeClosure`, `Call`, `TailCall`, `Return`                                        |
| Control     | `Jump`, `JumpIfFalse`, `JumpIfTrue`                                                |
| Builtins    | `CallBuiltin` (fast-path dispatch)                                                 |

### Key Implementation Details

- **Stack-Based VM**: Operations push/pop values from an operand stack
- **Call Frames**: Each function call creates a frame with its own stack window
- **Upvalue Management**: Closures capture variables via open/closed upvalues
- **Builtin Fast-Path**: Common builtins like `map`, `filter`, `fold` use direct dispatch via `CallBuiltin` opcode, avoiding closure allocation overhead
- **Tail-Call Optimization**: Self-recursive tail calls reuse the current frame
- **Persistent Collections**: Uses `im-rs` crate for immutable data structures with structural sharing

### Value Representation

```
Value enum:
├── Nil
├── Integer (i64)
├── Decimal (f64)
├── Boolean
├── String (Rc<String>)
├── List (im::Vector)
├── Set (im::HashSet)
├── Dict (im::HashMap)
├── Function (Closure)
├── LazySequence
├── Range
├── PartialApplication
├── MemoizedFunction
└── SpreadMarker
```

## CLI Usage

```bash
# Run a solution
santa-cli solution.santa

# Run with tests
santa-cli -t solution.santa

# Evaluate inline expression
santa-cli -e '1 + 2'

# Interactive REPL
santa-cli -r
```

## Building from Source

Requires Rust 1.91.1+.

```bash
git clone https://github.com/eddmann/santa-lang-blitzen.git
cd santa-lang-blitzen
make build    # Debug build
make release  # Release build
make test     # Run tests
```

## See Also

- [Language Specification](../language.md)
- [Built-in Functions](../builtins.md)
- [Full Architecture Documentation](https://github.com/eddmann/santa-lang-blitzen/blob/main/docs/ARCHITECTURE.md)
