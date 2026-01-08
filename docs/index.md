<p align="center"><img src="assets/logo.png" alt="santa-lang" width="400px" /></p>
<p align="center"><a href="cli/">CLI</a> - <a href="web/">Web</a> - <a href="lambda/">Lambda</a> - <a href="php-ext/">PHP Extension</a> - <a href="jupyter-kernel/">Jupyter</a></p>

# santa-lang

An functional, C-like programming language for solving Advent of Code puzzles.

_Influenced by:_ Rust, Python, Clojure, F#, Scala

## Release

The recommended implementation is [Comet](reindeer/comet.md) (Rust tree-walking interpreter).

| Runtime | Platform      | Release                                                                                                                                                        |
| ------- | ------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CLI     | Linux (x64)   | [`santa-lang-comet-cli-1.0.0-linux-amd64`](https://github.com/eddmann/santa-lang-comet/releases/download/1.0.0/santa-lang-comet-cli-1.0.0-linux-amd64)         |
| CLI     | Linux (ARM)   | [`santa-lang-comet-cli-1.0.0-linux-arm64`](https://github.com/eddmann/santa-lang-comet/releases/download/1.0.0/santa-lang-comet-cli-1.0.0-linux-arm64)         |
| CLI     | macOS (Intel) | [`santa-lang-comet-cli-1.0.0-macos-amd64`](https://github.com/eddmann/santa-lang-comet/releases/download/1.0.0/santa-lang-comet-cli-1.0.0-macos-amd64)         |
| CLI     | macOS (ARM)   | [`santa-lang-comet-cli-1.0.0-macos-arm64`](https://github.com/eddmann/santa-lang-comet/releases/download/1.0.0/santa-lang-comet-cli-1.0.0-macos-arm64)         |
| CLI     | Docker        | [`ghcr.io/eddmann/santa-lang-cli:latest`](https://github.com/eddmann/santa-lang-comet/pkgs/container/santa-lang-cli)                                           |
| Web     | WASM          | [`@eddmann/santa-lang-wasm`](https://github.com/eddmann/santa-lang-comet/pkgs/npm/santa-lang-wasm)                                                             |
| Lambda  | provided.al2  | [`santa-lang-comet-lambda-1.0.0.zip`](https://github.com/eddmann/santa-lang-comet/releases/download/1.0.0/santa-lang-comet-lambda-1.0.0.zip)                   |
| PHP     | Linux (x64)   | [`santa-lang-comet-php-1.0.0-linux-amd64.so`](https://github.com/eddmann/santa-lang-comet/releases/download/1.0.0/santa-lang-comet-php-1.0.0-linux-amd64.so)   |
| Jupyter | Linux (x64)   | [`santa-lang-comet-jupyter-1.0.0-linux-amd64`](https://github.com/eddmann/santa-lang-comet/releases/download/1.0.0/santa-lang-comet-jupyter-1.0.0-linux-amd64) |
| Jupyter | macOS (Intel) | [`santa-lang-comet-jupyter-1.0.0-macos-amd64`](https://github.com/eddmann/santa-lang-comet/releases/download/1.0.0/santa-lang-comet-jupyter-1.0.0-macos-amd64) |

See [Reindeer](#reindeer) below for alternative implementations (Blitzen, Dasher, Donner, Prancer).

## Why?

Over the past several years I have been slowly working through the previous Advent of Code calendars.
For each calendar I opt to solve the puzzles in a new programming language, to familiarise myself with other ways of understanding and working.
However, there comes a time in each calendar that I grow to dislike some aspect of the language.
So I had an idea... why not give this whole programming language design a go.
That way if I grow to dislike this language, I only have myself to blame!

Welcome **santa-lang**, my programming language designed to help tackle Advent of Code puzzles.

## Reindeer

There are multiple implementations (affectionately called "reindeer") of the language, all of which follow the [language specification](https://github.com/eddmann/santa-lang/blob/main/docs/lang.txt). See the [Reindeer](reindeer/index.md) section for detailed comparisons, downloads, and architecture information.

| Implementation                 | Language   | Execution Model          | Runtimes                              |
| ------------------------------ | ---------- | ------------------------ | ------------------------------------- |
| [Comet](reindeer/comet.md)     | Rust       | Tree-walking interpreter | CLI, Web (WASM), Lambda, PHP, Jupyter |
| [Blitzen](reindeer/blitzen.md) | Rust       | Bytecode VM              | CLI                                   |
| [Dasher](reindeer/dasher.md)   | Rust       | LLVM native compiler     | CLI                                   |
| [Donner](reindeer/donner.md)   | Kotlin     | JVM bytecode compiler    | CLI                                   |
| [Prancer](reindeer/prancer.md) | TypeScript | Tree-walking interpreter | CLI, Web (JS), Lambda                 |

## Tooling

| Tool                      | Language | Description                               |
| ------------------------- | -------- | ----------------------------------------- |
| [Formatter](formatter.md) | Zig      | Opinionated code formatter for santa-lang |
