# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A development environment for previewing `gren format` — a code formatter for the [Gren programming language](https://gren-lang.org/). It wires together three forked repos (all on the `formatter` branch) into a working formatter that can be run locally.

## Setup

1. Run `./clone-repos` to clone the three dependency repos into `compiler/`, `compiler-node/`, and `compiler-common/`.
2. Build the Haskell compiler (inside `compiler/`):
   ```
   devbox run prepare-deps
   devbox run build
   ```
3. Use `./gren.sh` as the `gren` executable. It sets `GREN_BIN` and delegates to the Node.js backend.

## Repo structure

| Directory | Purpose |
|---|---|
| `compiler/` | Fork of `gren-lang/compiler` (Haskell). CLI entry point for `gren format` is under `compiler/src/Terminal/`. |
| `compiler-node/` | Fork of `gren-lang/compiler-node` (Gren). All formatter logic lives in `compiler-node/src/Formatter/`. |
| `compiler-common/` | Fork of `gren-lang/compiler-common`. Extended to serialize the AST as JSON for debugging. |
| `gren.sh` | Wrapper script — use this as your `gren` binary. Requires `node` on `$PATH` (defaults to `/opt/nodejs/25.1.0/bin`). |
| `clone-repos` | Python script that clones the three forks and checks out the `formatter` branch. |

## Formatter architecture

The formatter pipeline:

1. **Parse** — Haskell compiler parses the `.gren` source into an AST.
2. **LPT** — AST + comments are combined into a *Logical Printing Tree* (`compiler-node/src/Formatter/LogicalPrintingTree.gren`). AST nodes retain original row/column numbers; comments are inserted by position.
3. **Doc** — The LPT is converted to a PrettyExpressive `Doc` (`compiler-node/src/Formatter/MakePretty.gren`). The page width is 100 columns.
4. **Render** — PrettyExpressive renders the final text.

Key formatter modules in `compiler-node/src/Formatter/`:
- `LogicalPrintingTree.gren` — LPT data types
- `MakeLogical.gren` — AST → LPT conversion
- `MakePretty.gren` — LPT → PrettyExpressive Doc
- `PrettyPrinter.gren` — final rendering
- `Comments.gren` — comment insertion logic
- `README.md` — documents the formatting rules that have been implemented

## Running the formatter

```bash
# Preview a file (stdout, no changes)
./gren.sh format --show=<path>

# Check that formatting is idempotent (prints Success/Failure)
./gren.sh format --check=<path>

# Format all files in a project in place
./gren.sh format --dangerous

# Print the pre-format AST as JSON (for debugging)
./gren.sh format --pre-ast=<path>

# Print the post-format AST as JSON (verifies ASTs match)
./gren.sh format --post-ast=<path>

# Print the Logical Printing Tree as JSON
./gren.sh format --lpt=<path>

# Print the PrettyExpressive Doc as JSON
./gren.sh format --pex=<path>

# Write formatted output to <file>.gren.fmt (originals untouched)
./gren.sh format --rename
```

## Tests

Tests are in `compiler-node/effectful-tests/`. Each test case is a pair of files under `testfiles/Formatter/`:
- `<Name>.dirty.gren` — input
- `<Name>.formatted.gren` — expected output

To run the tests:
```bash
cd compiler-node/effectful-tests
./run-tests.sh
```

`run-tests.sh` builds the test app with `../../gren.sh make Main --output=app` then runs it with `node app`. The normal tests in `compiler-node/tests/` are currently broken.

## Rebuilding after Haskell changes

```bash
cd compiler
./build_dev_bin.sh   # runs: cabal build -f dev && cp $(cabal list-bin .) .
```

Gren source changes (formatter logic) don't require a Haskell rebuild — the compiler-node code is compiled at runtime by the Node backend.
