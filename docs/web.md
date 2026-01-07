# Web

[![Comet](https://img.shields.io/badge/Comet-%23000000.svg?style=for-the-badge&logo=rust&logoColor=white)](reindeer/comet.md) [![Prancer](https://img.shields.io/badge/Prancer-%23007ACC.svg?style=for-the-badge&logo=typescript&logoColor=white)](reindeer/prancer.md)

The Web runtime is accessible via WebAssembly (WASM) within Comet, and bundled JavaScript within Prancer.
This enables the interpreter to be run within the Browser, Web Worker and Node environments.
As expected, the WASM variant is more performant than the JavaScript implementation, due to being compiled to a lower-level language.
This variant is also used to execute the runnable examples found within this documentation.

Both variants provide the following functionality:

- Execute a given solution's source, providing benchmark timing for each defined part.
- Execute a given solution's source test suite.
- Execute a given script source.
- Execute a arbitrary language expression.
- (Comet only) Format source code and check if code is formatted.
- Ability to define user-land JavaScript functions which are made available to the evaluator as [external functions](language.md#external).

## Release (Comet)

| Platform | Release                                                                                            |
| -------- | -------------------------------------------------------------------------------------------------- |
| WASM     | [`@eddmann/santa-lang-wasm`](https://github.com/eddmann/santa-lang-comet/pkgs/npm/santa-lang-wasm) |

**Also available in:** [Prancer](reindeer/prancer.md)

## API

Both variants expose the same API, shown below as TypeScript type definitions:

```typescript
type InteropType = string | number | object;
type ExternalFunctions = {
  [name: string]: (arguments: InteropType[]) => InteropType;
};

type Status = "pending" | "running" | "complete" | "error";

type ErrorLocation = { line: number; column: number };
type StackFrame = { function: string; line: number; column: number };
type ErrorInfo = { message: string; location: ErrorLocation; stack: StackFrame[] };

type PartResult = {
  status: Status;
  value?: string;
  duration_ms?: number;
};

type ScriptState = {
  type: "script";
  status: Status;
  value?: string;
  duration_ms?: number;
  error?: ErrorInfo;
};

type SolutionState = {
  type: "solution";
  status: Status;
  part_one: PartResult;
  part_two: PartResult;
  error?: ErrorInfo;
};

type TestPartResult = { passed: boolean; expected: string; actual: string };
type TestCaseStatus = "pending" | "running" | "complete" | "skipped";
type TestCaseState = {
  index: number;
  slow: boolean;
  status: TestCaseStatus;
  part_one?: TestPartResult;
  part_two?: TestPartResult;
};
type TestSummary = { total: number; passed: number; failed: number; skipped: number };
type TestState = {
  type: "test";
  status: Status;
  success?: boolean;
  summary: TestSummary;
  tests: TestCaseState[];
  error?: ErrorInfo;
};

type FormatResult = {
  success: boolean;
  formatted?: string;
  error?: ErrorInfo;
};

// Evaluate a script or expression
function evaluateScript(
  source: string,
  externalFunctions?: ExternalFunctions,
  onProgress?: (state: ScriptState) => void,
): ScriptState;

// Evaluate a solution (part_one/part_two)
function evaluateSolution(
  source: string,
  externalFunctions?: ExternalFunctions,
  onProgress?: (state: SolutionState) => void,
): SolutionState;

// Run test cases
function testSolution(
  source: string,
  includeSlow?: boolean,
  externalFunctions?: ExternalFunctions,
  onProgress?: (state: TestState) => void,
): TestState;

// Comet (WASM) only
function format(source: string): FormatResult;
function isFormatted(source: string): boolean;
```

## External Functions

Unlike other runtimes which have a select few external functions (defined at the runtime level), the Web variants gives you the power of user-land JavaScript to define and execute desired behaviour.
The runtimes implicitly handle the interoperability between the two languages type systems whilst communicating.
This provides an extensive platform on which to add additional behaviour and functionality.

The defined JavaScript functions must conform to the following type signature:

```typescript
type InteropType = string | number | object;

function external_function(arguments: InteropType[]): InteropType;
```

An example external function could be:

```js
const puts = (arguments: InteropType[]): InteropType => console.log(...arguments);
```

## Errors

All functions return state objects with a `status` field. When `status` is `"error"`, the `error` property contains detailed error information including the message, source location (line and column), and stack trace. Functions never throw exceptions.

## Example

Below is an example of how the WASM variant can be used within a Web context.

```js
import { evaluateScript, evaluateSolution, testSolution, format, isFormatted } from "@eddmann/santa-lang-wasm";

// Evaluate a simple expression
const result = evaluateScript("[1, 2, 3] |> map(_ + 1) |> sum");
if (result.status === "complete") {
  console.log(result.value); // "10"
}

// With external functions
const withPuts = evaluateScript('puts("Hello, world")', { puts: console.log.bind(console) });

// Formatting (Comet only)
const formatted = format("let x=1+2");
if (formatted.success) {
  console.log(formatted.formatted); // "let x = 1 + 2\n"
}
console.log(isFormatted("let x = 1 + 2\n")); // true
```

## Editor

**Repository:** [eddmann/santa-lang-editor](https://github.com/eddmann/santa-lang-editor)

One of the reasons for providing such a runtime was to create a Web-based code editor which could be used to develop solutions with.
Both the [Comet](https://eddmann.com/santa-lang-editor/) (WASM) and [Prancer](https://eddmann.com/santa-lang-ts/) (JavaScript) variants have been integrated into a version of the editor.
The WASM variant however is the preferred version to use.

<figure markdown>
  <a href="https://eddmann.com/santa-lang-editor/">![Web Editor](assets/web-editor.png){ width="600" }</a>
</figure>

In this use-case we are able to map the external `puts` function to `console.log`.
We are additionally able to map the `read` function to a synchronous-blocking XMLHttpRequest call (old-school!), which provides access to the `http(s)` and `aoc` schema-based input.
The evaluation itself is placed inside a Web Worker to ensure that the main JS user-thread is not blocked.

### Errors

If an error occurrs during execution the the program is immediately halted; with the error message and associated call stack trace presented to the user, as shown below:

<figure markdown>
  ![Web Editor](assets/web-editor-errors.png){ width="600" }
</figure>

## Future scope

Due to the widespread reach of JavaScript and to a lesser extent WASM, there are possibility of bringing the runtime to other platforms in the future.
For example, an [Electron](https://www.electronjs.org/)/[Tauri](https://tauri.app/)-based desktop application, or exposed within a [CloudFlare Worker](https://workers.cloudflare.com/).
