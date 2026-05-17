# test-packages

## Background

The list of published Gren packages is at
https://packages.gren-lang.org/package

It lists the latest version of each package. If you descend into one such
package/version, you get page like this:
https://packages.gren-lang.org/package/aramiscd/gren-color/version/1.0.1/overview

which has a "Source" link to the source code.
That link takes you to a github page, pointing to a specific tag in the repo.
Like this:
https://github.com/aramiscd/gren-color/tree/1.0.1

## The tool

The "test-packages" tool is a Python program with sub-commands.

* **fetch** - Given no arguments, this will clone the git repos for all the packages listed
at the Gren package site. If given the name of a one or more packages (like,
aramiscd/gren-color), it will fetch those packages.  The clones will be put
into the current-working directory, but keep the directory names two levels to
match the package naming conventiion, which is PROJECT/REPO (like,
aramiscd/gren-color)


