# Template project

This is a template for Linux/GCC/C++ projects. The structure is optimized for
use with VSCode but can also be used stand alone. By default this is set for a
C++11 project.

This readme and the associated documentation are also templates in addition of
being a user manual of the Makefile and VSCode features.

## Bootstrap a new C++ project

### Initialize the project

#### Cpp-skeleton as a simple initial template

* Clone [Cpp-skeleton](https://github.com/marmottetranquille/Cpp-skeleton):  
`git clone https://github.com/marmottetranquille/Cpp-skeleton.git`
* Update the remote to whatever suits you:  
`git remote remove origin`  
`git remote add origin whatever/url/you/want`

#### Cpp-skeleton as a dependency

* Initialize a repository or clone a compatible one (a compatible project is
likely one that also has [Cpp-skeleton](https://github.com/marmottetranquille/Cpp-skeleton)
as a dependency).
* Add [Cpp-skeleton](https://github.com/marmottetranquille/Cpp-skeleton) as a
remote:  
`git remote add cpp-skeleton https://github.com/marmottetranquille/Cpp-skeleton.git`  
`git fetch --all`
* Merge with [Cpp-skeleton](https://github.com/marmottetranquille/Cpp-skeleton)
history:  
`git merge --allow-unrelated-histories cpp-skeleton`

### Clean up template files

Template files are located in `include`, `src/bin`, `src/lib`, `test/src` and
can be removed or renamed before being modified.  
The comprehensive template file list and pre-canned commands can be found
[here](doc/Cpp-skeleton/TemplatesList.md).

### Start coding

Put you header files in `include` directory and your source files in `src/bin`
directory.

Note: Read [Project structure](doc/Cpp-skeleton/ProjectStructure.md) for
more details on controlling the output.

### Build your stuff

From VSCode use pre-canned tasks (`F1` then `Run Task`), or simply use the run
and debug menu.

From a terminal, run the command `make bins` from the repository's root.

Note: *Reading [Project structure](doc/Cpp-skeleton/ProjectStructure.md)
and [Makefile usage](doc/Cpp-skeleton/MakeFileUsage.md) or
[VSCode usage](doc/Cpp-skeleton/VSCodeUsage.md) detailed documentation is
recommanded*.

## Release

## Detailed documentation

* [Project structure](doc/Cpp-skeleton/ProjectStructure.md)
* [Makefile usage](doc/Cpp-skeleton/MakeFileUsage.md)
* [VSCode usage](doc/Cpp-skeleton/VSCodeUsage.md)
* [Documentation storage](doc/Cpp-skeleton/DocumentationStorage.md)
