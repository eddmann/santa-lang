# Santa Lang

A functional, C-like programming language designed for solving [Advent of Code](https://adventofcode.com/) puzzles.

## Overview

Santa-lang is a domain-specific language with the primary goal of aiding in the development of solutions to Advent of Code problems. The language provides a batteries-included approach with many built-in functions for tackling general-purpose and AoC-specific problems.

### Key Features

- **First-class functions and closures** with tail-call optimization
- **Functional pipelines** (`|>`) and composition (`>>`)
- **Pattern matching** with `match` expressions and guards
- **Lazy sequences** and infinite ranges (`1..`)
- **Persistent immutable data structures**
- **Placeholder syntax** (`_ + 1`) for concise lambdas
- **Built-in memoization** support
- **Rich built-in function library** for AoC puzzles
- **AoC runner** with automatic input fetching

### AoC Runner

The language includes a Runner that provides a DSL for expressing and validating solutions:
- `input:` section for puzzle input
- `part_one:` and `part_two:` sections for solutions
- `test:` sections for validation with expected results
- Support for `@slow` attribute to skip expensive tests during iteration

## This Repository

This is the **documentation and specification repository** for Santa Lang. It contains:

- `docs/lang.txt` - **Canonical language specification** used by both documentation and implementations
- `docs/` - Human-readable documentation (published to [eddmann.com/santa-lang](https://eddmann.com/santa-lang/))
- `runner/` - Interactive code runner for the docs website (uses `@eddmann/santa-lang-wasm`)
- `Makefile` - Build commands for the documentation site
- `mkdocs.yml` - MkDocs configuration

The actual language implementations live in separate repositories (see Implementations table below).

### Source of Truth

The `docs/lang.txt` file is the **canonical language specification**. This file should be used as the authoritative reference when:

- Building or updating documentation in `docs/`
- Implementing language features across all implementations
- Resolving discrepancies between implementations

When there are conflicts:

- Implementation bugs should be fixed to match `docs/lang.txt`
- If an implementation behaves differently from the spec, investigate whether `docs/lang.txt` or the implementation is incorrect
- Spec changes should be made to `docs/lang.txt` first, then propagated to other docs and implementations

### Building Documentation

```bash
make serve    # Serve docs locally at http://localhost:8000
make build    # Build static site to ./site
```

Note: Requires Docker. The runner uses the WASM build of santa-lang to enable interactive code execution in the documentation.

### Formatting Documentation

After making any changes to documentation files, always run Prettier to ensure consistent formatting:

```bash
npx prettier --write docs/
```

This applies to all markdown files in the `docs/` directory.

## Reindeer

The language has multiple implementations (affectionately called "reindeer") exploring different execution models and technologies. **When making cross-implementation changes (e.g., adding a new built-in function), spawn separate subagents to explore and implement in each project concurrently.**

| Codename | Type | Description | Project Location |
|----------|------|-------------|------------------|
| **Comet** | Rust tree-walking interpreter | The primary Rust implementation using AST interpretation | `~/Projects/santa-lang-comet` |
| **Blitzen** | Rust bytecode VM | High-performance Rust implementation with bytecode compilation | `~/Projects/santa-lang-blitzen` |
| **Dasher** | Rust LLVM-based native compiler | AOT compiler generating native executables via LLVM | `~/Projects/santa-lang-dasher` |
| **Donner** | Kotlin JVM bytecode compiler | AOT compiler generating JVM bytecode via ASM | `~/Projects/santa-lang-donner` |
| **Vixen** | C embedded bytecode VM | Lightweight subset VM for microcontrollers (ESP32, Raspberry Pi Pico) | `~/Projects/santa-lang-vixen` |
| **Prancer** | TypeScript tree-walking interpreter | TypeScript/JavaScript implementation for browser and Node.js | `~/Projects/santa-lang-prancer` |

## Tooling

| Name | Type | Description | Project Location |
|------|------|-------------|------------------|
| **Tinsel** | Zig code formatter | Opinionated code formatter for santa-lang source files | `~/Projects/santa-lang-tinsel` |

## Working with Implementations

**Before making any changes to an implementation, always explore that project first.** Each implementation has its own `AGENTS.md`, `CLAUDE.md`, or `README.md` that explains how the project works, its structure, conventions, and how to build/test.

### Workflow

1. **Explore first**: Navigate to the implementation's project directory and read its `AGENTS.md`/`CLAUDE.md`/`README.md` to understand the codebase
2. **Understand patterns**: Look at existing code to understand conventions before adding new code
3. **Make changes**: Implement the feature following the project's established patterns
4. **Verify**: Run the project's tests to ensure changes work correctly

### Cross-Implementation Changes

When a task affects multiple implementations (e.g., adding a new built-in function):

1. Spawn separate subagents for each implementation
2. Each subagent should explore its target project's documentation first
3. Implement in parallel, respecting each project's conventions
4. Update documentation in this repo (`docs/`) if the language spec changes

## Documentation Reference

- **Language syntax**: `docs/` directory
- **Built-in functions**: `docs/builtins.md` - comprehensive list of all available functions
- **Runner DSL**: `docs/runner.md` - AoC solution structure and testing
- **Examples**: `docs/examples.md` - real-world usage in AoC solutions

## Built-in Function Categories

The language provides built-in functions across these categories:
- **Collection**: `list`, `set`, `dict`, `get`, `size`, `push`, `assoc`, `update`, `map`, `filter`, `fold`, `reduce`, `find`, `zip`, `sort`, `reverse`, etc.
- **Math**: `abs`, `vec_add`, `signum`
- **Bitwise**: `bit_and`, `bit_or`, `bit_xor`, `bit_shift_left`, `bit_shift_right`, `bit_not`
- **String**: `int`, `ints`, `lines`, `split`, `regex_match`, `regex_match_all`, `md5`, `upper`, `lower`, `replace`, `join`
- **Miscellaneous**: `range`, `id`, `memoize`, `type`

## External Functions (Runtime-Specific)

Different runtimes provide their own external functions:
- `puts(...values)` - Print to stdout
- `read(path)` - Read from file, URL, or `aoc://YEAR/DAY` for puzzle inputs
- `env()` - Display current REPL environment
