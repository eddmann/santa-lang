# Web

[![Comet](https://img.shields.io/badge/Comet-%23000000.svg?style=for-the-badge&logo=rust&logoColor=white)](https://github.com/eddmann/santa-lang-rs/tree/main/runtime/wasm) [![Prancer](https://img.shields.io/badge/Prancer-%23007ACC.svg?style=for-the-badge&logo=typescript&logoColor=white)](https://github.com/eddmann/santa-lang-ts/tree/main/src/web)

The Web runtime is accessible via WebAssembly (WASM) within Comet, and bundled JavaScript within Prancer.
This enables the interpreter to be run within the Browser, Web Worker and Node environments.
As expected, the WASM variant is more performant than the JavaScript implementation, due to being compiled to a lower-level language.
This variant is also used to execute the runnable examples found within this documentation.

Both variants provide the following functionality:

- Execute a given solution's source, providing benchmark timing for each defined part.
- Execute a given solution's source test suite.
- Execute a given script source.
- Execute a arbitrary language expression.
- Ability to define user-land JavaScript functions which are made available to the evaluator as [external functions](language.md#external).

## Release (Comet)

| Platform | Release                                                                                         |
| -------- | ----------------------------------------------------------------------------------------------- |
| WASM     | [`@eddmann/santa-lang-wasm`](https://github.com/eddmann/santa-lang-rs/pkgs/npm/santa-lang-wasm) |

**Note:** Prancer's Web runtime can be accessed via the [GitHub repository](https://github.com/eddmann/santa-lang-ts).

## API

Both variants expose the same API, shown below as TypeScript type definitions:

```typescript
type InteropType = string | number | object;
type ExternalFunctions = {
  [name: string]: (arguments: InteropType[]) => InteropType;
};

type Location = { start: number; end: number };
type RunErr = { message: string; source: Location; trace: Location[] };

type RunResult = { value: string; duration: number };
type RunEvaluation =
  | {
      part_one?: RunResult;
      part_two?: RunResult;
    }
  | RunResult;

type TestCaseResult = { expected: string; actual: string; passed: boolean };
type TestCase = {
  part_one?: TestCaseResult;
  part_two?: TestCaseResult;
};

function aoc_run(
  source: string,
  js_functions: ExternalFunctions,
): RunEvaluation | RunErr;

function aoc_test(
  source: string,
  js_functions: ExternalFunctions,
): TestCase[] | RunErr;

function evaluate(
  expression: string,
  js_functions?: ExternalFunctions,
): string | RunErr;
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

If an error occurs during execution the the program is immediately halted; with the error message, location and associated call stack trace locations returned as an `RunErr` object (as detailed above).

## Example

Below is an example of how the WASM variant can be used within a Web context.

```js
import { evaluate } from "@eddmann/santa-lang-wasm";

evaluate("[1, 2, 3] |> map(_ + 1) |> sum");

evaluate('puts("Hello, world")', { puts: console.log.bind(console) });
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
