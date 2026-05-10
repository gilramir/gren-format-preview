
# Usage

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

Use the "gren.sh" script in this directory as your "gren" exectuable.
Your CWD can be any directory when you use it. It will invoke the
Haskell-based compiler you just built, using the compiler backend
that was just built.

Make sure "node" is in your $PATH. If not, adjust gren.sh so it
adds it to the $PATH.

# Info

The CLI is under compiler/src/Terminal

The actual formatting code is under compiler-node/src/Formatter

The compiler-common code was updated to serialize the AST into JSON,
which useful for debugging.

# Tests
The pretty printer tests are in a new directory in
compiler-node/effectful-tests

To run them, in that directory:
```
./run-tests.sh
```

The normal tests in compiler-node/tests are broken for the moment.
