<p align="center"><img src="assets/logo.png" alt="santa-lang" width="400px" /></p>
<p align="center"><a href="cli/">CLI</a> - <a href="web/">Web</a> - <a href="lambda/">Lambda</a> - <a href="php-ext/">PHP Extension</a> - <a href="jupyter-kernel/">Jupyter</a></p>

# santa-lang

An functional, C-like programming language for solving Advent of Code puzzles.

_Influenced by:_ Rust, Python, Clojure, F#, Scala

## Release

The recommended implementation is [Comet](#comet-rust) (Rust tree-walking interpreter).

| Runtime | Platform      | Release                                                                                                                                                           |
| ------- | ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CLI     | Linux (x64)   | [`santa-lang-comet-cli-0.0.13-linux-amd64`](https://github.com/eddmann/santa-lang-comet/releases/download/0.0.13/santa-lang-comet-cli-0.0.13-linux-amd64)         |
| CLI     | Linux (ARM)   | [`santa-lang-comet-cli-0.0.13-linux-arm64`](https://github.com/eddmann/santa-lang-comet/releases/download/0.0.13/santa-lang-comet-cli-0.0.13-linux-arm64)         |
| CLI     | macOS (Intel) | [`santa-lang-comet-cli-0.0.13-macos-amd64`](https://github.com/eddmann/santa-lang-comet/releases/download/0.0.13/santa-lang-comet-cli-0.0.13-macos-amd64)         |
| CLI     | macOS (ARM)   | [`santa-lang-comet-cli-0.0.13-macos-arm64`](https://github.com/eddmann/santa-lang-comet/releases/download/0.0.13/santa-lang-comet-cli-0.0.13-macos-arm64)         |
| CLI     | Docker        | [`ghcr.io/eddmann/santa-lang-cli:latest`](https://github.com/eddmann/santa-lang-comet/pkgs/container/santa-lang-cli)                                              |
| Web     | WASM          | [`@eddmann/santa-lang-wasm`](https://github.com/eddmann/santa-lang-comet/pkgs/npm/santa-lang-wasm)                                                                |
| Lambda  | provided.al2  | [`santa-lang-comet-lambda-0.0.13.zip`](https://github.com/eddmann/santa-lang-comet/releases/download/0.0.13/santa-lang-comet-lambda-0.0.13.zip)                   |
| PHP     | Linux (x64)   | [`santa-lang-comet-php-0.0.13-linux-amd64.so`](https://github.com/eddmann/santa-lang-comet/releases/download/0.0.13/santa-lang-comet-php-0.0.13-linux-amd64.so)   |
| Jupyter | Linux (x64)   | [`santa-lang-comet-jupyter-0.0.13-linux-amd64`](https://github.com/eddmann/santa-lang-comet/releases/download/0.0.13/santa-lang-comet-jupyter-0.0.13-linux-amd64) |
| Jupyter | macOS (Intel) | [`santa-lang-comet-jupyter-0.0.13-macos-amd64`](https://github.com/eddmann/santa-lang-comet/releases/download/0.0.13/santa-lang-comet-jupyter-0.0.13-macos-amd64) |

See [Implementations](#implementations) below for alternative implementations (Blitzen, Dasher, Vixen, Prancer).

## Why?

Over the past several years I have been slowly working through the previous Advent of Code calendars.
For each calendar I opt to solve the puzzles in a new programming language, to familiarise myself with other ways of understanding and working.
However, there comes a time in each calendar that I grow to dislike some aspect of the language.
So I had an idea... why not give this whole programming language design a go.
That way if I grow to dislike this language, I only have myself to blame!

Welcome **santa-lang**, my programming language designed to help tackle Advent of Code puzzles.

## Implementations

The language specification and runtime implementation can be seen as two separate concerns; similar to how the Python language has been implemented within [CPython](https://github.com/python/cpython)/[JPython](https://www.jython.org/), and ECMAScript within [V8](https://v8.dev/)/[SpiderMonkey](https://spidermonkey.dev/).
There are three implementations of the language (and runner), all of which follow the (informal) specification laid out in this documentation.
There is feature parity in-regard to the core language, data types and [70+ builtin functions](builtins.md).

### Comet (Rust)

**Repository:** [eddmann/santa-lang-comet](https://github.com/eddmann/santa-lang-comet) ⭐ _Recommended_

Taking all the learnings from the initial TypeScript implementation, Comet was built to be a stable and performant [tree-walking interpreter](<https://en.wikipedia.org/wiki/Interpreter_(computing)>).
It was felt that the JavaScript runtime could only reach [so much performance](https://eddmann.com/posts/solving-the-advent-of-code-2022-calendar-using-my-own-programming-language-santa-lang/#so-whats-next), and a lower-level language could unlock more performance gains.
Along with performance considerations, during its development, there was the addition of a WASM runtime, a PHP extension, Jupyter kernel and a CLI REPL.

**Runtimes:** CLI, Web (WASM), Lambda, PHP Extension, Jupyter Kernel

### Blitzen (Rust)

**Repository:** [eddmann/santa-lang-blitzen](https://github.com/eddmann/santa-lang-blitzen)

Blitzen takes a different approach by compiling santa-lang to FrostByte bytecode and executing it on a stack-based virtual machine.
This bytecode compilation approach explores a different execution model for potential performance improvements over tree-walking interpretation, particularly for computationally intensive puzzles.

**Runtimes:** CLI

### Dasher (Rust)

**Repository:** [eddmann/santa-lang-dasher](https://github.com/eddmann/santa-lang-dasher)

Dasher takes an ahead-of-time compilation approach, using LLVM to compile santa-lang to native machine code.
This provides significant performance improvements for computationally intensive puzzles by generating optimized native executables.
Type inference enables specialization for native LLVM operations, with unknown types falling back to runtime library calls.

**Runtimes:** CLI

### Vixen (C)

**Repository:** [eddmann/santa-lang-vixen](https://github.com/eddmann/santa-lang-vixen)

Vixen is a lightweight bytecode VM implementation designed for embedded systems.
It compiles santa-lang directly to bytecode and executes on a stack-based virtual machine, targeting microcontrollers like ESP32 and Raspberry Pi Pico.
This enables running santa-lang on resource-constrained devices with fast startup times.

**Runtimes:** CLI (Host, ESP32, RP2040)

### Prancer (TypeScript)

**Repository:** [eddmann/santa-lang-prancer](https://github.com/eddmann/santa-lang-prancer)

Prancer was the initial [tree-walking interpreted](<https://en.wikipedia.org/wiki/Interpreter_(computing)>) reference implementation used whilst creating of the language and runner.
It allowed for quick exploration of different language constructs, and exercise them with actual Advent of Code problems throughout the [2022 calendar](https://github.com/eddmann/advent-of-code/tree/master/2022/santa-lang).
TypeScript was chosen due to speed of development and minimal friction to try out new ideas.
The JavaScript runtime also made it easy to develop the initial CLI, Web and Lambda runtimes; with minimal unique delivery requirements.

**Runtimes:** CLI, Web (JavaScript), Lambda
