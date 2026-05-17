# How to build

1. Run "./clone-repos"

This clones my repos, but naming their directories as if they were cloned from
the gren-lang repos.

2. Build the compiler as per the regular instructions at
    https://github.com/gren-lang/compiler

That is:

```
devbox run prepare-deps
devbox run build
```

Or just use the helper script:

```
./build.sh
```

Use the "gren.sh" script in this directory as your "gren" exectuable.
Your CWD can be any directory when you use it. It will invoke the
Haskell-based compiler you just built, using the compiler backend
that was just built.

Make sure "node" is in your $PATH. If not, adjust gren.sh so it
adds it to the $PATH.

# CLI

The CLI has switches which are in place for development, and won't survive
when this gets officially used.

```
Format Gren source code.

    gren format



You can customize this command with the following flags:

    --check=<path>
        Parse and format a file, then compare original and formatted ASTs; prints
        Success or Failure

    --dangerous
        Format all source files in the project, overwriting them in place

    --lpt=<path>
        Parse a single file and print its Logical Printing Tree as JSON to stdout

    --pex=<path>
        Parse and format a single file, then print the PrettyExpressive Doc as
        JSON to stdout

    --post-ast=<path>
        Parse and format a file, verify the ASTs match, then print the formatted
        file's AST as JSON to stdout

    --pre-ast=<path>
        Parse a single file and print its AST as JSON to stdout

    --rename
        Write the formatted output to <filename>.gren.fmt next to each source
        file, leaving originals untouched

    --show=<path>
        Parse and pretty-print a single file to stdout without modifying it
```


# The Approach

The formatter pipeline has four stages:

1. **Parse** — The Haskell compiler parses the `.gren` source into an AST.
   Use `--pre-ast` to dump this AST as JSON.

2. **LPT** — The AST and comments are converted into a "Logical Printing Tree".
   The AST nodes retain their original row and column numbers; comments are
   inserted by position. Use `--lpt` to dump the LPT as JSON.

3. **Doc** — The LPT is converted into a PrettyExpressive `Doc`, which encodes
   layout choices that are resolved as the page width (100 columns) is
   approached. Use `--pex` to dump the Doc as JSON.

4. **Render** — PrettyExpressive renders the final text.

After formatting, the formatted file is re-parsed and its AST is compared to
the original to verify correctness. Use `--post-ast` to dump the formatted
file's AST as JSON (this also runs the verification).

# Dev Info

The CLI is under compiler/src/Terminal

The actual formatting code is under compiler-node/src/Formatter

The compiler-node/src/Formatter/README.md file explains some of the
rules that I have implemented. This documentation will grow, and
eventually will be moved into a doc comment in the code.

# Tests
The pretty printer tests are in a new directory in
compiler-node/effectful-tests

To run them, in that directory:
```
./run-tests.sh
```

The normal tests in compiler-node/tests are broken for the moment.

# format-packages

The `format-packages` script runs the formatter against published Gren packages.

Fetch all packages into a directory:
```
mkdir /tmp/pkgs && cd /tmp/pkgs
/path/to/format-packages fetch
```

Fetch specific packages:
```
./format-packages fetch aramiscd/gren-color blaix/gren-ansi
```

Run the formatter on all fetched packages:
```
./format-packages format
```

Run the formatter on specific packages:
```
./format-packages format aramiscd/gren-color
```

Check formatting of all fetched packages (per-file, does not modify files):
```
./format-packages check
./format-packages check aramiscd/gren-color
```

After a `check` run, results are written to:
- `failed.txt` — files that did not format correctly
- `timedout.txt` — files that exceeded the 5-second timeout

All subcommands accept `-j N` to run N operations in parallel. Failed
package names are summarized at the end of the run.

# Status

This is nowhere near ready.

## gren-format-preview-01

The compiler-common code was updated to serialize the AST into JSON,
which useful for debugging. It also has an unofficial fix for this
issue: https://github.com/gren-lang/compiler-common/issues/14

## gren-format-preview-02

Lots of Gren code was tested, and many formatting bugs were fixed.

Many bugs were filed in the compiler-common and core packages, too.

The local copy of the compiler-common code was updated to avoid a bug
in doc comments and String.dropLast. This is an unofficial fix for
this issue:
https://github.com/gren-lang/compiler-common/issues/19


