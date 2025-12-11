# Formatter

[![Comet](https://img.shields.io/badge/Comet-%23000000.svg?style=for-the-badge&logo=rust&logoColor=white)](https://github.com/eddmann/santa-lang-rs)

An opinionated code formatter for santa-lang that produces consistent, readable output.

## Overview

The formatter transforms santa-lang source code into a canonical format, ensuring consistent style across solutions. It follows a single, deterministic formatting style - there are no configuration options.

## Usage

### CLI

```bash
# Format to stdout
santa-cli -f file.santa

# Format in place
santa-cli --fmt-write file.santa

# Check if formatted (exit 1 if not)
santa-cli --fmt-check file.santa

# Format inline expression
santa-cli -e "1+2" -f

# Format from stdin
echo "1+2" | santa-cli -f
```

### WASM

```javascript
import { format, isFormatted } from "@eddmann/santa-lang-wasm";

const formatted = format("let x=1+2");
const needsFormat = !isFormatted(source);
```

## Properties

The formatter guarantees:

1. **Idempotency**: Formatting formatted code produces identical output
2. **Semantic preservation**: Formatted code parses to an equivalent AST
3. **Determinism**: Same input always produces same output

## Formatting Rules

### General

| Setting          | Value                                       |
| ---------------- | ------------------------------------------- |
| Line width       | 100 characters                              |
| Indentation      | 2 spaces                                    |
| Trailing newline | Files end with a single newline             |
| Blank lines      | One blank line between top-level statements |

### Spacing

| Context               | Rule                   | Example      |
| --------------------- | ---------------------- | ------------ |
| Binary operators      | Spaces around          | `1 + 2`      |
| Commas                | Space after            | `[1, 2, 3]`  |
| Colons (dict/section) | Space after            | `key: value` |
| Function calls        | No space before parens | `func(arg)`  |
| Lambda parameters     | No space inside pipes  | `\|x, y\|`   |

### Collections

Collections (lists, sets, dictionaries) use smart wrapping:

```santa
// Fits on one line
[1, 2, 3]

// Wraps when exceeding 100 characters
[
  very_long_name_one,
  very_long_name_two,
  very_long_name_three
]
```

- **No trailing commas** in any mode
- Empty collections: `[]`, `{}`, `#{}`

### Dictionaries

Dictionary shorthand syntax is used when a key string matches the variable name:

```santa
// Shorthand syntax preferred
#{foo, bar, baz}

// Explicit syntax only when key differs from variable
#{"key": value, name}

// Explicit form is converted to shorthand
#{"foo": foo}  // becomes: #{foo}
```

### Pipe Chains (`|>`)

| Chain length                 | Format                        |
| ---------------------------- | ----------------------------- |
| Single pipe (2 elements)     | Inline: `data \|> sum`        |
| Multiple pipes (3+ elements) | Multiline with 2-space indent |

```santa
// Single pipe stays inline
[1, 2, 3] |> sum

// Multiple pipes break to multiple lines
[1, 2, 3]
  |> map(|x| x * 2)
  |> filter(|x| x > 2)
  |> sum
```

### Function Composition (`>>`)

Composition uses **line-width based** formatting:

| Scenario              | Format                        |
| --------------------- | ----------------------------- |
| Fits within 100 chars | Inline: `f >> g >> h`         |
| Exceeds 100 chars     | Multiline with 2-space indent |

```santa
// Short chains stay inline regardless of function count
parse >> validate >> transform

// Long chains wrap at line width
very_long_function_name
  >> another_long_function
  >> third_long_function
```

Note: This differs from pipe chains (`|>`), which always force multiline with 2+ functions.

### Lambda Functions

Single-expression bodies are unwrapped:

```santa
|x| x + 1
|x, y| x * y
```

Multi-statement bodies use braces:

```santa
|x| {
  let y = x * 2;

  y + 1
}
```

### Trailing Lambda Syntax

Multi-statement lambdas as the last argument use trailing lambda style:

```santa
// Formatted with trailing lambda
items
  |> map |x| {
    let y = x * 2;

    y + 1
  }
```

### If-Else Expressions

Simple if-else stays inline:

```santa
if x > 0 { "positive" } else { "non-positive" }
```

Complex bodies use multiline format:

```santa
if condition {
  do_something();

  result
} else {
  do_other();

  other_result
}
```

### Match Expressions

Always multiline with cases on separate lines:

```santa
match value {
  0 { "zero" }
  1 { "one" }
  n if n > 10 { "large" }
  _ { "other" }
}
```

### Sections (AoC Runner)

Single-expression sections are inline:

```santa
input: read("aoc://2024/1")
```

`part_one` and `part_two` always use braces at top level:

```santa
part_one: {
  input |> solve
}
```

### Operator Precedence

The formatter preserves necessary parentheses and removes unnecessary ones:

```santa
// Parentheses preserved for precedence
(a + b) * c

// Unnecessary parentheses removed
a + (b * c)  // becomes: a + b * c
```

### Comments

Comments are preserved throughout the code, with blank lines added between top-level comments and statements:

```santa
// First section

let a = 1

// Second section

let b = 2
```
