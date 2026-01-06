<p align="center"><a href="https://eddmann.com/santa-lang/"><img src="./docs/assets/logo.png" alt="santa-lang" width="400px" /></a></p>

# santa-lang

A functional, C-like programming language designed for solving [Advent of Code](https://adventofcode.com/) puzzles. [Read the docs →](https://eddmann.com/santa-lang/)

## Features

- First-class functions and closures with tail-call optimization
- Functional pipelines (`|>`) and composition (`>>`)
- Pattern matching with `match` expressions and guards
- Lazy sequences and infinite ranges (`1..`)
- Persistent immutable data structures
- Placeholder syntax (`_ + 1`) for concise lambdas
- Built-in memoization support
- [Rich built-in function library](https://eddmann.com/santa-lang/builtins/) for AoC puzzles
- AoC runner with automatic input fetching

## Examples

### Language Features

```santa
// Pattern matching
let fibonacci = |n| match n {
  0 { 0 }
  1 { 1 }
  n { fibonacci(n - 1) + fibonacci(n - 2) }
};

// Pipelines and functional operations
let result = 1..10
  |> filter(|n| n % 2 == 0)
  |> map(_ * 2)
  |> sum;

// Lazy infinite sequences
let evens = 0.. |> filter(|n| n % 2 == 0) |> take(5);
```

### Advent of Code Solution

A complete solution for [AoC 2015 Day 1](https://adventofcode.com/2015/day/1):

```santa
input: read("aoc://2015/1")

part_one: {
  input |> fold(0) |floor, direction| {
    if direction == "(" { floor + 1 } else { floor - 1 }
  }
}

part_two: {
  zip(1.., input) |> fold(0) |floor, [index, direction]| {
    let next_floor = if direction == "(" { floor + 1 } else { floor - 1 };
    if next_floor < 0 { break index } else { next_floor }
  }
}

test: {
  input: "()())"
  part_one: -1
  part_two: 5
}
```

## Reindeer

The language has multiple implementations (affectionately called "reindeer") exploring different execution models and technologies.

| Codename | Description                         | Repository                                                          |
| -------- | ----------------------------------- | ------------------------------------------------------------------- |
| Comet    | Rust tree-walking interpreter       | [santa-lang-comet](https://github.com/eddmann/santa-lang-comet)     |
| Blitzen  | Rust bytecode VM                    | [santa-lang-blitzen](https://github.com/eddmann/santa-lang-blitzen) |
| Dasher   | Rust LLVM-based native compiler     | [santa-lang-dasher](https://github.com/eddmann/santa-lang-dasher)   |
| Donner   | Kotlin JVM bytecode compiler        | [santa-lang-donner](https://github.com/eddmann/santa-lang-donner)   |
| Vixen    | C embedded bytecode VM              | [santa-lang-vixen](https://github.com/eddmann/santa-lang-vixen)     |
| Prancer  | TypeScript tree-walking interpreter | [santa-lang-prancer](https://github.com/eddmann/santa-lang-prancer) |

There is also a [web-based editor](https://github.com/eddmann/santa-lang-editor) available to try santa-lang in the browser.
