# Documentation storage

## Foreword

This documentation structure allows easy merge of unrelated histories of
dependencies while maintaining documentation each of these histories correctly
tracked.

The minimalist instance of where this can be useful is to make this very
[Cpp-skeleton](https://github.com/marmottetranquille/Cpp-skeleton) a dependency
of your project so that the later can keep on benefiting from upgrades of the
first by a simple pull / merge mechanism.

## Internal links

Links to project documentations in the [README.md](.doc/Cpp-skeleton/README.md)
file will work both when seen from the root symbolik link or from the `doc`
directory as long as they hook on the `.doc/` symbolink link.

When several projects have been merged, root `README.md` and `LICENSE` symbolic
links should point to the main project equivalent files under the `doc`
directory.

## Minimum documentation structure

```terminal-output
Cpp-skeleton
├── .doc -> doc
├── doc
│   └── Cpp-skeleton
│       ├── .doc -> ../doc
│       ├── LICENSE
│       └── README.md
├── LICENSE -> doc/Cpp-skeleton/LICENSE
├── Makefile
└── README.md -> doc/Cpp-skeleton/README.md
```
