# How to build

1. Run "./clone-repos"

This clones my repos, but naming their directories as if they were cloned from
the gren-lang repos.

2. Build gren-format

That is:

```
cd gren-format
devbox run build
```

Or just use the helper script:

```
./build.sh
```

Use the "gren-format.sh" script in this directory as your "gren-format"
exectuable.

Make sure "node" is in your $PATH. If not, adjust gren.sh so it
adds it to the $PATH.

# Updating the repos

Once the repos are cloned, use "./update-repos" to update them.
By default it runs "git pull" in each repo that exists on disk:

```
./update-repos
```

Pass a git tag to check out that tag in each repo instead of pulling:

```
./update-repos gren-format-preview-04
```

# CLI


```
Format Gren source code.

    gren-format [<path>...]



Arguments:

    <path>
        Gren source file or directory to pretty-print in place

You can customize this command with the following flags:

    --lpt=<path>
        Parse a single file and print its Logical Printing Tree as JSON to stdout

    --post-ast=<path>
        Parse and format a file, verify the ASTs match, then print the formatted file's AST as JSON to stdout

    --pre-ast=<path>
        Parse a single file and print its AST as JSON to stdout

    --remove-unused-imports
        Remove unused imports while formatting

    --render-doc=<path>
        Parse a single file and print its Render.Doc tree as JSON to stdout

    --show=<path>
        Parse and pretty-print a single file to stdout without modifying it

```


# The Approach

see gren-format-lib/README.md


# format-packages

**THIS IS CURRENTLY BROKEN**

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

## gren-format-preview-03

Pull in performance fixes from PrettyExpressive

## gren-format-preview-04

Large amount of fixes for idempotency and canonical output.

## gren-format-preview-05

Removed my misunderstanding of wanting to produce truly canonical formatted
output from any input. Now an author's newline breaks are honored, or, at least
distinguish between "keep this expression on one line if possible" and
"break this expression across multiple lines even if it could fit on one line"

## gren-format-preview-06

To be remembered

## gren-format-preview-07

PrettyExpressive was dropped; no page with enforced. The output is
as much like elm-format's output as possible.

