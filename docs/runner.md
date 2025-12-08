# Advent of Code Runner

The language has been designed with the primary goal of aiding in the development of solutions to Advent of Code (AoC) problems.
Whilst the [core language](language.md) provides the building blocks to express and evaluate a problem, it is the addition of the AoC Runner that truly helps aid in solution development.
Over the many years of AoC problems I have tackled, regardless of language used, I noticed a similar pattern of building up a form of framework for both running and testing each solution.
As such, during this languages development, a lot of effort was paid in providing a REPL which catered for a frictionless problem-solving environment.

With the aid of [Sections](language.md#sections), the Runner is able to provide a clear Domain Specific Language (DSL) for the programmer to express and validate the correctness of a solution.

## Solution

The solution source consists of a `part_one` and/or `part_two` section.
Each section is an expression, which when evaluated (by the desired runtime) returns the answer to the given problem.
The solution source is additionally able to define an `input` section, which will be evaluated and supplied to both `part_*` sections in the form of a `input` variable.
The Runner also benchmarks each parts execution time and supplies this to the runtime to be presented accordingly.

Below is an example solution for solving the [first ever](https://adventofcode.com/2015/day/1) AoC problem:

```
input: "()())"

part_one: {
  input |> fold(0) |floor, direction| {
    if direction == "(" { floor + 1 } else { floor - 1 };
  }
}

part_two: {
  zip(1.., input) |> fold(0) |floor, [index, direction]| {
    let next_floor = if direction == "(" { floor + 1 } else { floor - 1 };
    if next_floor < 0 { break index } else { next_floor };
  }
}
```

**Note:** in this example the input has been statically defined as a String response.
Typically, you will see other means of fetching the problem input, for example, via runtime specific implementations of the [external](language.md#external) `read` function.
If is advised to review your desired runtimes documentation to see what is available.

## Testing

Whilst solving a days problem it is common to be shown a smaller example, in which the expected answer is provided.
Along with defining a solution, you are able to provide test cases in the form of `test` sections.
Each test case includes a desired `input`, alongside a `part_one` and/or `part_two` expected result.
Upon testing your solution, the Runner will assert the given solutions result to the expected one and return success or failure accordingly.
It is upto the runtime to determine how this test results are presented.

```
test: {
  input: "()())"
  part_one: -1
  part_two: 5
}
```

### Slow Tests

Tests that are expensive or take a long time to run can be marked with the `@slow` attribute.
These tests are skipped by default, allowing for faster iteration during development.

```
@slow
test: {
  input: read("aoc://2015/1")
  part_one: 280
  part_two: 1797
}
```

To include slow tests during test execution, use the `-s` or `--slow` flag with the CLI:

```bash
santa-cli -t -s solution.santa
```

This is useful for tests that validate against the actual puzzle input, which may be computationally expensive compared to the smaller example inputs provided in the problem description.

## External Functions

The CLI runtime provides the following external functions that are available in your santa-lang programs:

### `puts(...values)`

Prints values to standard output, separated by spaces, followed by a newline.

```santa
puts("Hello", "World");  // Output: Hello World
puts(1, 2, 3);           // Output: 1 2 3
```

Returns `nil`.

### `read(path)`

Reads content from a file path, URL, or Advent of Code input.

**File paths:**
```santa
let data = read("input.txt");
```

**HTTP/HTTPS URLs:**
```santa
let data = read("https://example.com/data.txt");
```

**Advent of Code inputs:**
```santa
let data = read("aoc://2015/1");  // Fetches Day 1 of 2015
```

The `aoc://` scheme requires the `SANTA_CLI_SESSION_TOKEN` environment variable to be set with your Advent of Code session cookie.
Fetched inputs are cached locally as `aoc{year}_day{day}.input` files to avoid repeated requests.

Returns the file contents as a String.

### `env()`

Prints all variables and functions currently defined in the REPL environment.
Useful for debugging and exploring what's available in the current session.

```santa
let x = 42;
let add = |a, b| a + b;
env();
// Output:
// Environment:
//   x = 42
//   add = Function
```

Returns `nil`. This function is primarily useful in REPL mode.

## Example

For completeness, below is the full example solution combining both the solution and test blocks.
It also documents use of a runtime-specific external `read` function.

```
input: read("aoc://2015/1")

part_one: {
  input |> fold(0) |floor, direction| {
    if direction == "(" { floor + 1 } else { floor - 1 };
  }
}

part_two: {
  zip(1.., input) |> fold(0) |floor, [index, direction]| {
    let next_floor = if direction == "(" { floor + 1 } else { floor - 1 };
    if next_floor < 0 { break index } else { next_floor };
  }
}

test: {
  input: "()())"
  part_one: -1
  part_two: 5
}
```
