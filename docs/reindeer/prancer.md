# Prancer (TypeScript)

> TypeScript tree-walking interpreter for browser and Node.js

**Repository:** [eddmann/santa-lang-prancer](https://github.com/eddmann/santa-lang-prancer)
**Version:** 1.0.0

## Overview

Prancer was the initial [tree-walking interpreter](<https://en.wikipedia.org/wiki/Interpreter_(computing)>) reference implementation used during the creation of santa-lang and the runner.

TypeScript was chosen for speed of development and minimal friction to try out new ideas. The JavaScript runtime makes it easy to develop for CLI, Web, and Lambda with minimal unique delivery requirements.

Prancer is ideal for exploring the language internals or when you need native JavaScript integration.

## Downloads

### CLI

| Platform      | Download                                                                                                                                                     |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Linux (x64)   | [`santa-lang-prancer-cli-1.0.0-linux-amd64`](https://github.com/eddmann/santa-lang-prancer/releases/download/1.0.0/santa-lang-prancer-cli-1.0.0-linux-amd64) |
| Linux (ARM)   | [`santa-lang-prancer-cli-1.0.0-linux-arm64`](https://github.com/eddmann/santa-lang-prancer/releases/download/1.0.0/santa-lang-prancer-cli-1.0.0-linux-arm64) |
| macOS (Intel) | [`santa-lang-prancer-cli-1.0.0-macos-amd64`](https://github.com/eddmann/santa-lang-prancer/releases/download/1.0.0/santa-lang-prancer-cli-1.0.0-macos-amd64) |
| macOS (ARM)   | [`santa-lang-prancer-cli-1.0.0-macos-arm64`](https://github.com/eddmann/santa-lang-prancer/releases/download/1.0.0/santa-lang-prancer-cli-1.0.0-macos-arm64) |
| Docker        | `docker pull ghcr.io/eddmann/santa-lang-prancer-cli:latest`                                                                                                  |

### Other Runtimes

| Runtime | Download                                                                                                                                           |
| ------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| Lambda  | [`santa-lang-prancer-lambda-1.0.0.zip`](https://github.com/eddmann/santa-lang-prancer/releases/download/1.0.0/santa-lang-prancer-lambda-1.0.0.zip) |
| Web     | [`santa-lang-prancer-web-1.0.0.tar.gz`](https://github.com/eddmann/santa-lang-prancer/releases/download/1.0.0/santa-lang-prancer-web-1.0.0.tar.gz) |

## Installation

### Using Docker (Recommended)

```bash
docker run --rm ghcr.io/eddmann/santa-lang-prancer-cli:latest -e '1 + 1'
```

### Binary Download

```bash
# Download for your platform
curl -L -o santa https://github.com/eddmann/santa-lang-prancer/releases/download/1.0.0/santa-lang-prancer-cli-1.0.0-macos-arm64
chmod +x santa
./santa --help
```

## Supported Runtimes

- [CLI](../cli.md) - Bun-based CLI with REPL
- [Web](../web.md) - Next.js editor with CodeMirror
- [Lambda](../lambda.md) - AWS Lambda custom runtime

## Architecture

```
Source Code → Lexer → Parser → AST → Evaluator → Result
                                         │
                                    Environment
                                    (Scopes, Closures)
```

Prancer follows a traditional interpreter architecture:

1. **Lexer** - Character-by-character tokenization with position tracking
2. **Parser** - Pratt parser (top-down operator precedence) producing an AST
3. **Evaluator** - Tree-walking interpreter with visitor pattern

### Key Implementation Details

- **Runtime**: Built on [Bun](https://bun.sh/) for fast startup and execution
- **Collections**: [Immutable.js](https://immutable-js.com/) for persistent data structures with structural sharing
- **Lazy Sequences**: Immutable.js `Seq` for infinite ranges and deferred computation
- **Tail-Call Optimization**: Trampolining to prevent stack overflow
- **Partial Application**: Automatic currying via placeholder (`_`) syntax

### Object System

Runtime values implement the `ValueObj` interface:

```typescript
interface ValueObj {
  inspect(): string; // String representation
  isTruthy(): boolean; // Boolean coercion
  getName(): string; // Type name for errors
  hashCode(): number; // Dict/set key support
  equals(that: Obj): boolean;
}
```

Types include: `Integer`, `Decimal`, `Str`, `Bool`, `Nil`, `List`, `Set`, `Dict`, `Range`, `Sequence`, `Func`, `Placeholder`, `Err`.

### Project Structure

Prancer is a monorepo with four packages:

```
src/
├── lang/     # Core language library
│   ├── lexer/
│   ├── parser/
│   ├── evaluator/
│   │   ├── object/    # Runtime types
│   │   └── builtins/  # Built-in functions
│   └── runner/        # AoC runner DSL
├── cli/      # Command-line interface (Bun)
├── web/      # Browser editor (Next.js + CodeMirror)
└── lambda/   # AWS Lambda runtime
```

## CLI Usage

```bash
# Run a solution
santa-cli solution.santa

# Run with tests
santa-cli -t solution.santa

# Run slow tests too
santa-cli -t -s solution.santa

# Evaluate inline expression
santa-cli -e '1 + 2'

# Interactive REPL
santa-cli -r

# Output formats
santa-cli solution.santa              # text (default)
santa-cli -o json solution.santa      # JSON
santa-cli -o jsonl solution.santa     # JSON Lines
```

## Building from Source

Requires [Bun](https://bun.sh/).

```bash
git clone https://github.com/eddmann/santa-lang-prancer.git
cd santa-lang-prancer
bun install
make lang/test   # Run tests
make cli/build   # Build CLI binaries
make web/build   # Build web editor
```

## See Also

- [Language Specification](../language.md)
- [Built-in Functions](../builtins.md)
- [Full Architecture Documentation](https://github.com/eddmann/santa-lang-prancer/blob/main/docs/ARCHITECTURE.md)
