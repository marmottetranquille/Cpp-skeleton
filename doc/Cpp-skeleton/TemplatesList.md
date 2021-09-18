# Template files listing

## File list

```terminal-output
.
├── include
│   ├── templatea
│   │   ├── templatea1.hpp
│   │   └── templatea2.hpp
│   ├── templatea.hpp
│   ├── templateb.hpp
│   ├── templatec.hpp
│   └── template.hpp
├── src
│   ├── bin
│   │   ├── template1
│   │   │   └── glewinit.cpp
│   │   ├── template1.cpp
│   │   └── template2.cpp
│   └── lib
│       ├── libtemplatea
│       │   ├── templatea1.cpp
│       │   └── templatea2.cpp
│       ├── libtemplatea.cpp
│       ├── libtemplateb
│       │   └── templateb1.cpp
│       └── libtemplatec.cpp
└── test
    └── src
        ├── templatea.cpp
        ├── templateb
        │   └── templateb.cpp
        └── templateb.cpp
```

## Clean up commands

Note: *Read carefuly and make sure you understand it before copy/pasting it
in your terminal.*

```bash
cd `git rev-parse --show-toplevel`
rm -r include/templatea
rm include/templatea.hpp
rm include/templateb.hpp
rm include/templatec.hpp
rm include/template.hpp
rm -r src/bin/template1
rm src/bin/template1.cpp
rm src/bin/template2.cpp
rm -r src/lib/libtemplatea
rm src/lib/libtemplatea.cpp
rm -r src/lib/libtemplateb
rm src/lib/libtemplatec.cpp
rm test/src/templatea.cpp
rm -r test/src/templateb
rm test/src/templateb.cpp
git add -u
git commit -m "Clean up Cpp-skeleton templates"
cd -
```
