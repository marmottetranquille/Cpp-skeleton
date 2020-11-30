# Makefile usage

## Options

### Compiler

Compiler used can be changed with `CC`. By default this is set to use `g++`.

Example:

```bash
make libs CC=gcc
```

### Build options

By default objects will be build using `-O3 -Wall -Werror -pedantic-errors`
options. This can be changed with `OPT`.

Example:

This will simply compile in debug mode.

```bash
make bin/template OPT="-g"
```

*Note:* `-fPIC` is added anytime a library is compiled.

### Standard

By default c++11 standard is used. This can be changed with `STD`.

Example:

```bash
make bin/template STD=c++17
```

*Note:* This will of course only change the standard used for compiling; see
[VSCode usage](VSCodeUsage.md) for details on changing the standard used by the
linter.

## High level targets

The `Makefile` allows to build either shared libraries or applications (or
both). It is designed to run on Linux and will very likely not work as is in
any other environment.

### Clean

The following command gets read of anything that has been compiled.

```bash
make clean
```

### Libraries

All libraries can be built at once by using the following target:

```bash
make libs
```

Libraries will be linked twice:

- The first pass simply build the libraries without linking it to any other
one.
- The second pass scans each pre built library so that they can be re-linked
against the appropriate dependencies (local dependencies only).

A single library can be built by using its final name target. For instance, to
build the library defined in `src/lib/libtemplate.cpp`, simply use the
following command:

```bash
make lib/libtemplate.so
```

Single library build process will attempt to find the appropriate dependencies
and should work fine provided the dependencies have been built and are up to
date.

### Applications

Applications can be built using their final name target. For instance,
to build the application defined in `src/bin/template.cpp`, simply use the
following command:

```bash
make bin/template
```

*Note:* This will first build and link all libraries and then determine which
libraries the application should be linked to. As a side effect, an application
can not be built until all libraries can be build without errors.

All applications can be built at once using the following target:

```bash
make bins
```

### Test applications

Test applications can be built using their final target name. For instance, to
built the test application defined in `test/src/testtemplate.cpp`, simply
use the following command:

```bash
make test/bin/testtemplate
```

*Note:* This will not build and link any library first yet it will try to
resolve which libraries should the application be linked to based on whatever
libraries already available in the lib directory.

## Specific targets

### VsCode targets

Targets `vscode_bin` and `vscode_test` are provided to be used in conjunction
with VsCode tasks (see [VSCode usage](VSCodeUsage.md)).

- `make vscode_bin VSCODE_TGT=src/bin/template/random/sourcefile.cpp` or
  `make vscode_bin VSCODE_TGT=src/bin/template.cpp` are equivalent and result
  in triggering `make bin/template` target.
- `make vscode_test VSCODE_TGT=test/src/template/random/sourcefile.cpp` or
  `make vscode_test VSCODE_TGT=test/src/template.cpp` are equivalent and result
  in triggering `make test/bin/template` target.
- `vscode_bin_predebug` is the same as `vscode_bin` but also creates a hardlink
  `bin/vscode_bin` to the application so that VsCode can launch it.
- `vscode_test_predebug` is the same as `vscode_test` but also creates a
  hardlink `test/bin/vscode_test` to the application so that VsCode can launch
  it.
- `vscode_bin_postdebug` and `vscode_test_postdebug` remove the hardlinks.
