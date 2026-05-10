
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
