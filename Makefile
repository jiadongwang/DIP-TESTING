#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*                                                                           *
#*            This file is part of the test engine for MIPLIB2010            *
#*                                                                           *
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# $Id: Makefile,v 1.21 2011/07/04 23:05:20 bzfheinz Exp $

VERSION		=	1.0.3
TIME     	=  	3600
TEST		=	benchmark
SOLVER		=	scip
HARDMEM		=	8192
THREADS		= 	0

SHELL		= 	bash
DOXY		=	doxygen

CHECKERDIR      =       checker

RESULT1         =       decomp.cplex.res
RESULT2         =       decomp.dip.res

OUTPUT          =       cplex_dip.eps
#-----------------------------------------------------------------------------
# Rules
#-----------------------------------------------------------------------------

.PHONY: help
help:
		@echo "See README for details about the MIPLIB2010 test environment"
		@echo
		@echo "VERSION:      $(VERSION)"
		@echo
		@echo "TARGETS:"
		@echo "** checker -> compiles the solution checker" 
		@echo "** clean   -> cleans the solution checker" 
		@echo "** cmpres  -> generates solver comparison file"
		@echo "** doc     -> generates doxygen documentation"
		@echo "** eval    -> evaluate test run" 
		@echo "** test    -> start automatic test runs" 
		@echo 
		@echo "PARAMETERS:"
		@echo "** HARDMEM -> maximum memory to use MB [8192]"
		@echo "** SOLVER  -> solver [scip]"
		@echo "** THREADS -> number of threads (0: automatic) [0]"
		@echo "** TIME    -> time limit per instance in seconds [3600]"
		@echo "** TEST    -> test set [benchmark]"

.PHONY: checker
checker:
		@$(MAKE) -C $(CHECKERDIR) $^

.PHONY:		clean
clean: 		
		@$(MAKE) -C $(CHECKERDIR) clean

.PHONY: doc
doc: 		
		cd doc; $(DOXY) miplib.dxy;

.PHONY: test
test:
		@echo "run test: VERSION=$(VERSION) SOLVER=$(SOLVER) TEST=$(TEST) TIME=$(TIME) HARDMEN=$(HARDMEM) THREADS=$(THREADS)"
		@$(SHELL) ./scripts/run.sh $(SHELL) $(VERSION) $(SOLVER) $(TEST) $(TIME) $(HARDMEM) $(THREADS);

.PHONY: eval
eval:
		@echo "evaluate test: VERSION=$(VERSION) SOLVER=$(SOLVER) TEST=$(TEST)"
		@$(SHELL) ./scripts/evalrun.sh results/$(TEST).$(SOLVER).out;

.PHONY: cmpres
cmpres:
		@echo "compare result tables: VERSION=$(VERSION) SOLVER=$(SOLVER) TEST=$(TEST)"
		@$(SHELL) ./scripts/allcmpres.sh results/$(TEST).$(SOLVER).res;

.PHONY: pprof
pprof:
		@echo "generating performance profile: RESULT1=$(RESULT1) RESULT2=$(RESULT2) into OUTPUT=$(OUTPUT)"
		python ./scripts/pprof.py -l 2 -c 6 results/$(RESULT1) results/$(RESULT2) > $(OUTPUT)

# --- EOF ---------------------------------------------------------------------
# DO NOT DELETE
