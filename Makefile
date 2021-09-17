# Default settings ############################################################
STD?=c++11
OPT?=-O3 -Wall -Werror -pedantic-errors
CWD?=$(shell pwd)
SHELL?=/bin/bash
INC?=include
LIB?=lib

# Settings that should not change #############################################
CC=g++
SRCLIB=src/lib
SRCBIN=src/bin
SRCTST=test/src
CCSTD=-std=$(STD)
DEFAULT_SHARED_LIST=$(shell echo "int main(void){}" | $(CC) -v -o /dev/null -xc++ - 2>&1 | sed "s: :\n:g" | grep "^\-l" | sort -r | uniq)

# VSCode tasks overrides ######################################################
ifdef VSCODENRM
    ifdef VSCODENRMOPT
        OPT=${VSCODENRMOPT}
    endif
endif
ifdef VSCODEDBG
    ifdef VSCODEDBGOPT
        OPT=${VSCODEDBGOPT}
    endif
endif

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

# List programs to build ######################################################
BINSRCDIRS:=$(patsubst %/, %, $(shell ls -d $(SRCBIN)/*/))
BINSRCROOTS:=$(patsubst %.cpp, %, $(shell ls $(SRCBIN)/*.cpp))
BINS:=$(patsubst $(SRCBIN)/%, bin/%, $(BINSRCDIRS) $(BINSRCROOTS))

# Basic utilities #############################################################
%/:
	mkdir -pv $@

.PHONY: cleanlibs
cleanlibs:
	@rm -rvf .build/lib
	@rm -rvf lib

.PHONY: cleanbins
cleanbins:
	@rm -rvf .build/bin
	@rm -rvf bin

.PHONY: cleantests
cleantests:
	@rm -rvf .build/test
	@rm -rvf test/bin

.PHONY: cleansyscache
cleansyscache:
	@rm -rvf .build/.syscache

.PHONY: clean
clean: cleanlibs cleanbins cleantests cleansyscache
	@rm -rvf .build

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
# use g++ -MM to list required non system headers included in a test program
cc-mm_tst=$(CC) -MM $(SRCTST/$(STEM).cpp -I $(INC)
# Clean the output of g++ -MM from non header file list information
includes_tst=$$(filter $$(STEM).hpp $$(STEM).h, $$(shell $(cc-mm_tst)))
# Find all sources associated to a test program
srcs_tst=$$(wildcard $(SRCTST)/$$*/*.cpp) $$(wildcard $(SRCTST)/$$*.cpp)
# Build program objects demendency list from associated sources
objs_tst=$$(patsubst $(SRCTST)/$$(STEM).cpp, .build/test/bin/$$(STEM).o, $(srcs_tst))

.SECONDEXPANSION:

# Build system library cache ##################################################
# List system libraries
SYSLIBS=$(shell strings /etc/ld.so.cache | grep ^/.*.so$$)
# Filter defined global objects from an objdump -T of a system library
sys_glbs_finder=grep -v "\*UND\*" | grep "[ g |  w].* .text\|[ g |  w].* .bss\|[ g |  w].* .data"

# Create individual system library global object cache
.build/.syscache/%.glbs: /%
	@mkdir -p $(tdir)
	@-objdump -T $< | $(sys_glbs_finder) > $@

# Create system library global object cache
.build/.syscache: $(patsubst /%, .build/.syscache/%.glbs, $(SYSLIBS))
	@touch $@
	@echo - System libraries global symbols tables cache created

# Objects compiling ###########################################################
# Compile one library object
.SECONDARY:
.build/lib/lib%.o: $(SRCLIB)/lib%.cpp $(includes_lib)
	@echo - Building object $@ depends on $^
	@# Create build directory if id does not exist yet
	@mkdir -p $(tdir)
	@# Compile object file
	$(CC) $(CCSTD) $(OPT) -fPIC -I $(INC) -c $< -o $@

# Make one program object
.SECONDARY:
.build/bin/%.o: $(SRCBIN)/%.cpp $(includes_prg)
	@echo - Building object $@ depends on $^
	@mkdir -p $(tdir)
	$(CC) $(CCSTD) $(OPT) -I $(INC) -c $< -o $@

# Make one test program object
.SECONDARY:
#.build/test/bin/%.o: $(SRCTEST)/%.cpp $(includes_tst)
.build/test/bin/%.o: $(SRCTST)/%.cpp
	@echo - Building object $@ depends on $^
	@mkdir -p $(tdir)
	$(CC) $(CCSTD) $(OPT) -I $(INC) -c $< -o $@

# Unfiltered dependency list ##################################################
udef_list=$(patsubst %.dl.0, %.udef, $@)
sys_glbs=`find .build/.syscache/ | grep .so.glbs$$`
glbs_orig_finder=grep -l "$$pat" .build/lib/*.so.glbs $(sys_glbs)
%.dl.0:
	@> $@
	@for pat in `cat $(udef_list)`; do $(glbs_orig_finder) || true; done > $@

# Shared Library linking ######################################################
# Primary linking using only self objects
sym_name_cutter=rev | cut -f 1 -d' ' | rev
glbs_finder=grep "[ g |  w].* .text\|[ g |  w].* .bss\|[ g |  w].* .data"
udef_finder=grep " \*UND\*"
dl_prereq=.build/lib/lib%.so.glbs .build/lib/lib%.so.udef .build/.syscache

# Dynamic library primary linking (without dependencies)
.build/lib/lib%.so: $(objs_lib)
	@echo - Primary linking of shared library $@ depends on $^
	@mkdir -p $(tdir)
	$(CC) -shared -o $@ $(filter %.o, $^)

# List defined global objects from dynamic library
.build/lib/lib%.so.glbs: .build/lib/lib%.so
	@mkdir -p $(tdir)
	@objdump -t $< | $(glbs_finder) | $(sym_name_cutter) > $@

# List undefined objects from dynamic library
.build/lib/lib%.so.udef: .build/lib/lib%.so
	@mkdir -p $(tdir)
	@objdump -t $< | $(udef_finder) | $(sym_name_cutter) > $@

# Create dependency list of dynamic library
# Note: some dependencies might be overridden by default libs
.build/lib/lib%.so.dl: $(dl_prereq)
	@echo - Building local dynamic dependency list for $(patsubst .build/%.so.dl, %.so, $@)
	@$(MAKE) $@.0 
	@sort $@.0 | uniq > $@
	@rm $@.0
	@mkdir -p lib
	@ln -f $(patsubst .build/%.so.dl, .build/%.so, $@) $(patsubst .build/lib/%.so.dl, lib/%.so, $@)

lib/lib%.so: .build/lib/lib%.so.dl $(objs_lib)
	@echo - Second linking of shared library $@
	@mkdir -p $(tdir)
	$(CC) -shared -o $@ $(LDOPT) -Wall -Wl,-rpath,'$$ORIGIN/../lib' $(filter %.o, $^) -L$(LIB) $(DEFAULT_SHARED_LIST) $(patsubst .build/lib/lib%.so.glbs, -l%, $(shell cat $<))

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
	$(MAKE) -j1 $(LIBS)
	@echo ---------------------------------------------------------------------
	@echo - Library build complete
	@echo ---------------------------------------------------------------------

# Application linking #########################################################
# Build dependency list
.build/bin/%.udef: $(objs_prg)
	@mkdir -p $(tdir)
	@> $@
	@for obj in $^; do objdump -t $$obj | $(udef_finder) | $(sym_name_cutter) >> $@; done

.build/bin/%.dl: .build/bin/%.udef | libs
	@mkdir -p $(tdir)
	@$(MAKE) $@.0
	@sort $@.0 | uniq > $@
	@rm $@.0

bin/%: .build/bin/%.dl $(objs_prg)
	@echo - Building program $@ depends on $^
	@mkdir -p $(tdir)
	$(CC) -o $@ $(LDOPT) -Wl,-rpath,'$$ORIGIN/../lib' -L$(LIB) $(filter %.o, $^) $(DEFAULT_SHARED_LIST) $(patsubst lib%.so.glbs, -l%, $(shell cat $< | rev | cut -f1 -d / | rev))

# Make all applications
.PHONY: bins
bins: $(BINS)

# Test application linking ####################################################
.build/test/bin/%.udef: $(objs_tst)
	@mkdir -p $(tdir)
	@> $@
	@for obj in $^; do objdump -t $$obj | $(udef_finder) | $(sym_name_cutter) >> $@; done

.build/test/bin/%.dl: .build/test/bin/%.udef
	@mkdir -p $(tdir)
	@$(MAKE) $@.0
	@sort $@.0 | uniq > $@
	@rm $@.0

test/bin/%: .build/test/bin/%.dl $(objs_tst)
	@echo - Building test program $@ depends on $^
	@mkdir -p $(tdir)
	$(CC) -o $@ $(LDOPT) -Wl,-rpath,'$$ORIGIN/../../lib' -L$(LIB) $(filter %.o, $^) $(DEFAULT_SHARED_LIST) $(patsubst lib%.so.glbs, -l%, $(shell cat $< | rev | cut -f1 -d / | rev))


# VSCode targets ##############################################################
# Defines recipes called by VSCode
vs_bin_tgt=$(shell echo $(patsubst $(CWD)/src/bin/%.cpp, %, $(VSCODE_TGT)) | cut -f1 -d '/')
.PHONY: vscode_bin 
vscode_bin:
	@$(MAKE) bin/$(vs_bin_tgt)

.PHONY: vscode_bin_predebug
vscode_bin_predebug: vscode_bin
	@ln -f bin/$(vs_bin_tgt) bin/vscode_bin

.PHONY: vscode_bin_postdebug
vscode_postbin:
	@rm bin/vscode_bin

vs_tst_tgt=$(shell echo $(patsubst $(CWD)/test/src/%.cpp, %, $(VSCODE_TGT)) | cut -f1 -d '/')
.PHONY: vscode_test
vscode_test:
	@$(MAKE) test/bin/$(vs_tst_tgt)

.PHONY: vscode_test_predebug
vscode_test_predebug: vscode_test
	@ln -f test/bin/$(vs_tst_tgt) test/bin/vscode_test

.PHONY: vscode_posttest
vscode_posttest:
	@rm test/bin/vscode_test
