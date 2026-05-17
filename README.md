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

    --json=<path>
        Parse a single file and print its AST as JSON to stdout

    --lpt=<path>
        Parse a single file and print its Logical Printing Tree as JSON to stdout

    --rename
        Write the formatted output to <filename>.gren.fmt next to each source
        file, leaving originals untouched

    --show=<path>
        Parse and pretty-print a single file to stdout without modifying it
```


# The Approach

The AST and Comments are converted into a "Logical Printing Tree" (LPT).
First the AST is used to fill in the LPT; these nodes retain their
original row and column numbers. Then the comments are put into the
LPT based on row and column number.

The LPT is then converted into a PrettyExpressive "Doc", which are
instructions for how to print, but also make choices as the page width
boundary is approached; this is currently set to 100 columns.
It's possible we don't keep the PrettyExpressive printer and allow
the text to be as wide as possible.

Then the PrettyExpressive module renders the text.

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

# test-packages

The `test-packages` script runs the formatter against published Gren packages.

Fetch all packages into a directory:
```
mkdir /tmp/pkgs && cd /tmp/pkgs
/path/to/test-packages fetch
```

Fetch specific packages:
```
./test-packages fetch aramiscd/gren-color blaix/gren-ansi
```

Run the formatter on all fetched packages:
```
./test-packages format
```

Run the formatter on specific packages:
```
./test-packages format aramiscd/gren-color
```

Both subcommands accept `-j N` to run N operations in parallel. Failed
package names are summarized at the end of the run.

# Status

This is nowhere near ready.

## gren-format-preview-01

The compiler-common code was updated to serialize the AST into JSON,
which useful for debugging. It also has an unofficial fix for this
issue: https://github.com/gren-lang/compiler-common/issues/14

