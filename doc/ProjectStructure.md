# Project structure

## Version controlled directories and files

### `include/`

Store header files (`.hpp`). No specific structure is required.

### `src/`

Stores sources (`.cpp`) for shared libraries and actual programs.

#### Shared libraries

Shared libraries sources should be stored in `src/lib`. Shared libraries
can be structured using either of the three following options:

* All sources located in a directory called `libmylibrary`
* A source called `libmylibrary.cpp`
* A combination of the two other options

#### Programs

Programs sources should be stored in `src/bin`. Programs can be structured
using either of the three following options:

* All sources located in a directory called `myprogram`
* A source called `myprogam.cpp`
* A combination of the two other options

### `test/`

Stores sources (`.cpp`) of test programs.

Test programs sources should be stored in `test/src`. Test programs can be
structured using either of the three following options:

* All sources located in a directory called `mytestprogram`
* A source called `mytestprogram.cpp`
* A combination of the two other options

### `Makefile`

A Makefile to rule them all. See [Makefile usage](MakeFileUsage.md) for more
details.

### `.vscode`

Tasks, debug launch configurations and c++ linter settings. See
[VSCode usage](VSCodeUsage.md) for more details.
