# Reindeer

The language specification and runtime can be seen as two separate concerns; similar to how the Python language has been implemented within [CPython](https://github.com/python/cpython)/[JPython](https://www.jython.org/), and ECMAScript within [V8](https://v8.dev/)/[SpiderMonkey](https://spidermonkey.dev/).

There are multiple implementations (affectionately called "reindeer") of santa-lang, all of which follow the [language specification](https://github.com/eddmann/santa-lang/blob/main/docs/lang.txt). There is feature parity in-regard to the core language, data types and [rich builtin function library](../builtins.md).

| Implementation        | Language   | Execution Model          |
| --------------------- | ---------- | ------------------------ |
| [Comet](comet.md)     | Rust       | Tree-walking interpreter |
| [Blitzen](blitzen.md) | Rust       | Bytecode VM              |
| [Dasher](dasher.md)   | Rust       | LLVM native compiler     |
| [Donner](donner.md)   | Kotlin     | JVM bytecode compiler    |
| [Prancer](prancer.md) | TypeScript | Tree-walking interpreter |
