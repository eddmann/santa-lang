# Workbench

<p align="center">
  <img src="assets/workbench-logo.png" alt="santa-lang Workbench" width="150">
</p>

A cross-platform desktop IDE for santa-lang, designed to write and test Advent of Code solutions.

## Overview

The Workbench provides a controlled environment for developing AoC solutions, with the ability to download, manage, and compare different backend implementations (reindeer) of santa-lang.

Built with Tauri 2.0 and React, featuring a Monaco editor with syntax highlighting, real-time execution output, and performance comparisons across implementations.

<figure markdown="span">
  ![Workbench Editor](assets/workbench-editor-answer.png)
  <figcaption>Running a solution with real-time output</figcaption>
</figure>

## Installation

### Homebrew (macOS)

```bash
brew install eddmann/tap/santa-lang-workbench
```

### Release Binaries

| Platform      | Download                                                                                                                                                           |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| macOS (ARM)   | [`santa-workbench-0.1.1-macos-arm64.dmg`](https://github.com/eddmann/santa-lang-workbench/releases/download/0.1.1/santa-workbench-0.1.1-macos-arm64.dmg)           |
| macOS (Intel) | [`santa-workbench-0.1.1-macos-amd64.dmg`](https://github.com/eddmann/santa-lang-workbench/releases/download/0.1.1/santa-workbench-0.1.1-macos-amd64.dmg)           |
| Linux (x64)   | [`santa-workbench-0.1.1-linux-amd64.deb`](https://github.com/eddmann/santa-lang-workbench/releases/download/0.1.1/santa-workbench-0.1.1-linux-amd64.deb)           |
| Linux (x64)   | [`santa-workbench-0.1.1-linux-amd64.AppImage`](https://github.com/eddmann/santa-lang-workbench/releases/download/0.1.1/santa-workbench-0.1.1-linux-amd64.AppImage) |

## Features

### Run Solutions

Execute santa-lang code with real-time streaming output showing progress as each part runs.

### Run Tests

Define test cases with expected values and run them to validate your solutions.

<figure markdown="span">
  ![Running Tests](assets/workbench-editor-tests.png)
  <figcaption>Running tests with expected values</figcaption>
</figure>

### Multiple Reindeer

Download and manage multiple backend implementations from within the app. Switch between them instantly to test your solutions against different interpreters and compilers.

<figure markdown="span">
  ![Reindeer Management](assets/workbench-settings-reindeer.png)
  <figcaption>Managing installed reindeer versions</figcaption>
</figure>

### AoC Integration

Auto-detects `read("aoc://YEAR/DAY")` patterns in your code and fetches puzzle descriptions and inputs using your session token.

<figure markdown="span">
  ![Puzzle Integration](assets/workbench-editor-puzzle.png)
  <figcaption>Integrated Advent of Code puzzle descriptions</figcaption>
</figure>

### Comparative Testing

Run the same code on multiple reindeer simultaneously, comparing execution times side-by-side with performance charts.

<figure markdown="span">
  ![Performance Comparison](assets/workbench-comparison-graph.png)
  <figcaption>Comparing performance across different reindeer</figcaption>
</figure>

### Code Formatting

Built-in formatting via [Tinsel](formatter.md), accessible through the toolbar or keyboard shortcut.

### Modern Editor

Monaco editor with syntax highlighting, multiple tabs, autosave, and dark themes.

## Keyboard Shortcuts

| Shortcut              | Action       |
| --------------------- | ------------ |
| `Cmd + Enter`         | Run solution |
| `Cmd + Shift + Enter` | Run tests    |
| `Cmd + S`             | Save file    |
| `Cmd + Shift + F`     | Format code  |

## Reindeer Support

The Workbench can download and manage the following implementations:

| Codename | Type                   | Description                                                  |
| -------- | ---------------------- | ------------------------------------------------------------ |
| Comet    | Rust interpreter       | Tree-walking interpreter, good balance of speed and features |
| Blitzen  | Rust bytecode VM       | High-performance bytecode compilation                        |
| Dasher   | Rust LLVM compiler     | Native compilation via LLVM for maximum performance          |
| Donner   | Kotlin JVM compiler    | JVM bytecode generation, requires Java runtime               |
| Prancer  | TypeScript interpreter | JavaScript-based, useful for debugging and web compatibility |
