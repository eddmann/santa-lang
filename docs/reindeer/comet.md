# Comet (Rust)

> Tree-walking interpreter with the most runtime options

**Repository:** [eddmann/santa-lang-comet](https://github.com/eddmann/santa-lang-comet)
**Version:** 1.0.0

## Overview

Comet is the recommended santa-lang implementation. It's a [tree-walking interpreter](<https://en.wikipedia.org/wiki/Interpreter_(computing)>) written in Rust that directly executes the Abstract Syntax Tree (AST) without an intermediate compilation step.

Taking all the learnings from the initial TypeScript implementation (Prancer), Comet was built to be stable and performant. The move to Rust unlocked significant performance gains over the JavaScript runtime, while the core `lang` crate is shared across multiple runtime targets.

Comet offers the most runtime options: CLI with REPL, WebAssembly for browsers, AWS Lambda, a PHP extension, and a Jupyter kernel.

## Downloads

### CLI

| Platform      | Download                                                                                                                                               |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Linux (x64)   | [`santa-lang-comet-cli-1.0.0-linux-amd64`](https://github.com/eddmann/santa-lang-comet/releases/download/1.0.0/santa-lang-comet-cli-1.0.0-linux-amd64) |
| Linux (ARM)   | [`santa-lang-comet-cli-1.0.0-linux-arm64`](https://github.com/eddmann/santa-lang-comet/releases/download/1.0.0/santa-lang-comet-cli-1.0.0-linux-arm64) |
| macOS (Intel) | [`santa-lang-comet-cli-1.0.0-macos-amd64`](https://github.com/eddmann/santa-lang-comet/releases/download/1.0.0/santa-lang-comet-cli-1.0.0-macos-amd64) |
| macOS (ARM)   | [`santa-lang-comet-cli-1.0.0-macos-arm64`](https://github.com/eddmann/santa-lang-comet/releases/download/1.0.0/santa-lang-comet-cli-1.0.0-macos-arm64) |
| Docker        | `docker pull ghcr.io/eddmann/santa-lang-cli:latest`                                                                                                    |

### Other Runtimes

| Runtime         | Download                                                                                                                                                       |
| --------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Web (WASM)      | [`@eddmann/santa-lang-wasm`](https://github.com/eddmann/santa-lang-comet/pkgs/npm/santa-lang-wasm)                                                             |
| Lambda          | [`santa-lang-comet-lambda-1.0.0.zip`](https://github.com/eddmann/santa-lang-comet/releases/download/1.0.0/santa-lang-comet-lambda-1.0.0.zip)                   |
| PHP Extension   | [`santa-lang-comet-php-1.0.0-linux-amd64.so`](https://github.com/eddmann/santa-lang-comet/releases/download/1.0.0/santa-lang-comet-php-1.0.0-linux-amd64.so)   |
| Jupyter (Linux) | [`santa-lang-comet-jupyter-1.0.0-linux-amd64`](https://github.com/eddmann/santa-lang-comet/releases/download/1.0.0/santa-lang-comet-jupyter-1.0.0-linux-amd64) |
| Jupyter (macOS) | [`santa-lang-comet-jupyter-1.0.0-macos-amd64`](https://github.com/eddmann/santa-lang-comet/releases/download/1.0.0/santa-lang-comet-jupyter-1.0.0-macos-amd64) |

## Installation

### Using Docker (Recommended)

```bash
docker run --rm ghcr.io/eddmann/santa-lang-cli:latest -e '1 + 1'
```

### Binary Download

```bash
# Download for your platform
curl -L -o santa https://github.com/eddmann/santa-lang-comet/releases/download/1.0.0/santa-lang-comet-cli-1.0.0-macos-arm64
chmod +x santa
./santa --help
```

### npm (WASM)

```bash
npm install @eddmann/santa-lang-wasm
```

## Supported Runtimes

- [CLI](../cli.md) - Command-line interface with REPL, formatting, profiling
- [Web (WASM)](../web.md) - WebAssembly build for browsers and Node.js
- [Lambda](../lambda.md) - AWS Lambda custom runtime
- [PHP Extension](../php-ext.md) - Native PHP extension (.so)
- [Jupyter Kernel](../jupyter-kernel.md) - Interactive notebooks

## Architecture

```
Source Code → Lexer → Parser → AST → Evaluator → Result
                                         │
                                    Environment
                                    (Scopes, Closures)
```

Comet follows a traditional 3-stage pipeline:

1. **Lexer** - Character-by-character tokenization with position tracking
2. **Parser** - Pratt (top-down operator precedence) parser producing an AST
3. **Evaluator** - Tree-walking interpreter with reference-counted objects (`Rc<Object>`)

### Key Implementation Details

- **Object System**: Runtime values are reference-counted (`Rc<Object>`) with types including Integer, Decimal, String, List, Set, Dict, Closure, LazySequence, and more
- **Collections**: Persistent immutable data structures via the `im-rc` crate with structural sharing
- **Tail-Call Optimization**: Continuation-based trampoline preventing stack overflow in recursive functions
- **Lazy Sequences**: Infinite ranges and transformations (map, filter) computed on-demand
- **Closures**: First-class functions with captured lexical environments
- **Memoization**: Built-in support for caching expensive function calls

### Runtime Features

- **REPL**: Interactive read-eval-print loop for exploration
- **Formatter**: Opinionated code formatter (100-char width, 2-space indent)
- **Profiler**: Flamegraph generation for performance analysis
- **jemalloc**: Memory allocator for improved performance

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

# Format code
santa-cli -f solution.santa        # stdout
santa-cli --fmt-write solution.santa  # in-place
santa-cli --fmt-check solution.santa  # verify
```

## Building from Source

Requires Rust 1.85+.

```bash
git clone https://github.com/eddmann/santa-lang-comet.git
cd santa-lang-comet
make build    # Debug build
make release  # Release build
make test     # Run tests
```

## See Also

- [Language Specification](../language.md)
- [Built-in Functions](../builtins.md)
- [Full Architecture Documentation](https://github.com/eddmann/santa-lang-comet/blob/main/docs/ARCHITECTURE.md)
