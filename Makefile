# Default settings ############################################################
CC=g++
STD?=-std=c++11
OPT?=-O3 -fPIC -Wall
CWD?=$(shell pwd)
SHELL?=/bin/bash
INC?=include
LIB?=lib

# Settings that should not change #############################################
SRCLIB=src/lib
SRCBIN=src/bin

# List libraries to build #####################################################
# list all ./src/libsomelib/ that will be compiled into ./lib/libsomelib.so
LIBSRCDIRS:=$(patsubst %/, %, $(shell ls -d $(SRCLIB)/lib*/))
# list all ./src/libsomelib.cpp that will be compiled into ./lib/libsomelib.so
LIBSRCROOTS:=$(shell ls $(SRCLIB)/lib*.cpp)
# prepare list of libraries to build
LIBS:=$(addsuffix .so, $(patsubst $(SRCLIB)/%, lib/%, $(LIBSRCDIRS))) \
      $(patsubst $(SRCLIB)/lib%.cpp, lib/lib%.so, $(LIBSRCROOTS))
# prepare list of libraries global tables
LIBSGLBS:=$(patsubst lib/lib%.so, .build/lib/lib%.so.glbs, $(LIBS))
# prepare list of libraries undefined tables
LIBSUNDS:=$(patsubst lib/lib%.so, .build/lib/lib%.so.unds, $(LIBS))

# Basic utilities #############################################################
%/:
	mkdir -pv $@

.PHONY: clean
clean:
	@rm -rvf .build
	@rm -rvf lib
	@rm -rvf bin

.PHONY: listlibs
listlibs:
	@echo $(LIBS)

# Prepare second expansion functionalites #####################################
STEM=%
MONEY=$$
# Target directory
tdir=$(dir $@)
# Use g++ -MM to list required non system headers included in library source
cc-mm_lib=$(CC) -MM $(SRCLIB)/lib$(STEM).cpp -I $(INC)
# Clean the output of g++ -MM from non header file list information
includes_lib=$$(filter $$(STEM).hpp $$(STEM).h, $$(shell $(cc-mm_lib)))
# Find all sources associated to a library
srcs_lib=$$(wildcard $(SRCLIB)/lib$$*/*.cpp) $$(wildcard $(SRCLIB)/lib$$*.cpp)
# Build library objects dependency list from associated sources
objs_lib=$$(patsubst $(SRCLIB)/$$(STEM).cpp, .build/lib/$$(STEM).o, $(srcs_lib))
# use g++ -MM to list required non system headers included in program source
cc-mm_prg=$(CC) -MM $(SRCBIN)/$(STEM).cpp -I $(INC)
# Clean the output of g++ -MM from non header file list information
includes_prg=$$(filter $$(STEM).hpp $$(STEM).h, $$(shell $(cc-mm_prg)))
# Find all sources associated to a program
srcs_prg=$$(wildcard $(SRCBIN)/$$*/*.cpp) $$(wildcard $(SRCBIN)/$$*.cpp)
# Build program objects dependency list from associated sources
objs_prg=$$(patsubst $(SRCBIN)/$$(STEM).cpp, .build/bin/$$(STEM).o, $(srcs_prg))

.SECONDEXPANSION:

# Objects compiling ###########################################################
# Compile one library object
.SECONDARY:
.build/lib/lib%.o: $(SRCLIB)/lib%.cpp $(includes_lib)
	@echo - Building object $@ depends on $^
	@# Create build directory if id does not exist yet
	@mkdir -p $(tdir)
	@# Compile object file
	$(CC) $(STD) $(OPT) -I $(INC) -c $< -o $@

# Make one program object
.SECONDARY:
.build/bin/%.o: $(SRCBIN)/%.cpp $(includes_prg)
	@echo - Building object $@ depends on $^
	@mkdir -p $(tdir)
	$(CC) $(STD) $(OPT) -I $(INC) -c $< -o $@

# Shared Library linking ######################################################
# Primary linking using only self objects
glbs_names_rec=$(patsubst lib/%, .build/lib/%, $@.glbs)
udef_names_rec=$(patsubst lib/%, .build/lib/%, $@.udef)
sym_name_cutter=cut -f 2 -d"	" | tr -s ' ' | cut -f 2 -d' '
glbs_finder=grep "g     [FO] .text\|g     [FO] .bss"
udef_finder=grep "        \*UND\*"
.build/lib/lib%.so: $(objs_lib)
	@echo - Primary linking of shared library $@ depends on $^
	@mkdir -p $(tdir)
	g++ -shared -o $@ $(filter %.o, $^)

.build/lib/lib%.so.glbs: .build/lib/lib%.so
	@mkdir -p $(tdir)
	objdump -t $< | $(glbs_finder) | $(sym_name_cutter) > $@

.build/lib/lib%.so.udef: .build/lib/lib%.so
	@mkdir -p $(tdir)
	objdump -t $< | $(udef_finder) | $(sym_name_cutter) > $@

.build/lib/lib%.so.dl: .build/lib/lib%.so.glbs .build/lib/lib%.so.udef 
	@echo - Building local dynamic dependency list for $(patsubst .build/%.so.dl, %.so, $@)
	-for pat in `cat $(patsubst %.dl, %.udef, $@)`; do grep -l "$$pat" .build/lib/*.so.glbs; done > $@
	@mkdir -p lib
	ln -f $(patsubst .build/%.so.dl, .build/%.so, $@) $(patsubst .build/lib/%.so.dl, lib/%.so, $@)

lib/lib%.so: .build/lib/lib%.so.dl $(objs_lib)
	@echo - Second linking of shared library $@
	@mkdir -p $(tdir)
	g++ -shared -o $@ -Wall -Wl,-rpath,'$$ORIGIN/../lib' $(filter %.o, $^) -L$(LIB) $(patsubst .build/lib/lib%.so.glbs, -l%, $(shell cat $<))

bin/%: libs $(objs_prg) 
	@echo - Building program $@ depends on $^
	@mkdir -p $(tdir)
	g++ -o $@ -Wl,-rpath,'$$ORIGIN/../lib' -L$(LIB) $(filter %.o, $^) $(patsubst lib/lib%.so, -l%, $(wildcard lib/*.so))

# Make all libraries
.PHONY: libsheader
libsheader:
	@echo ---------------------------------------------------------------------
	@echo - Library build
	@echo ---------------------------------------------------------------------

.PHONY: libs1
libs1:
	@$(MAKE) $(patsubst lib/lib%.so, .build/lib/lib%.so.udef, $(LIBS))
	@$(MAKE) $(patsubst lib/lib%.so, .build/lib/lib%.so.glbs, $(LIBS))
	@$(MAKE) $(patsubst lib/lib%.so, .build/lib/lib%.so.dl, $(LIBS))

.PHONY: libs
libs: libsheader libs1
	$(MAKE) $(LIBS)
	@echo ---------------------------------------------------------------------
	@echo - Library build complete
	@echo ---------------------------------------------------------------------
