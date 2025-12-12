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

**Exceptions** - Braces are preserved when the body would be ambiguous:

1. **Set/Dictionary bodies** - `|x| {1, 2}` would parse `{1, 2}` as lambda body end
2. **Pipe/Composition bodies** - operators would bind to the lambda definition
3. **Match with collection subject** - `|x| match [a, b] { ... }` would parse `[a, b]` as body

### Trailing Lambda Syntax

Trailing lambda syntax is used based on line width and statement count:

| Scenario                            | Format                     |
| ----------------------------------- | -------------------------- |
| Multi-statement lambda              | Always trailing with block |
| Single-statement, fits in 100 chars | Inline: `map(\|x\| x + 1)` |
| Single-statement, exceeds 100 chars | Trailing with block        |

```santa
// Short lambdas stay inline
items |> map(|x| x + 1)
items |> fold(0, |acc, x| acc + x)

// Long lambdas (>100 chars) use trailing syntax with block
items |> map |x| {
  value1 + value2 + value3 + value4 + value5 + value6 + value7 + value8 + value9 + value10 + x
}

// Multi-statement always trailing
items |> each |x| {
  let y = x * 2;

  puts(y)
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

Comments are preserved throughout the code:

**Top-level comments** have blank lines added for separation:

```santa
// First section

let a = 1

// Second section

let b = 2
```

**Trailing comments** on statements are preserved:

```santa
let x = 1 // important value
let y = compute(x) // derived value
```

**Trailing comments on match cases** are preserved:

```santa
match direction {
  "N" { [y - 1, x] } // north
  "S" { [y + 1, x] } // south
  "E" { [y, x + 1] } // east
  "W" { [y, x - 1] } // west
}
```

**Blank lines** within blocks are preserved when authored by the user:

```santa
let solve = |input| {
  let parsed = parse(input)
  let step1 = transform(parsed)

  let step2 = validate(step1)

  finalize(step2)
}
```
