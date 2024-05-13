SHELL := /bin/bash
GRAMMARS := https://raw.githubusercontent.com/antlr/grammars-v4/master
JAVASCRIPT := JavaScript
PYTHON := Python3
HELLO := Hello
PARSER ?= JAVASCRIPT
TARGET ?= PYTHON
JAVASCRIPTGRAMMAR := $(GRAMMARS)/javascript/javascript
GRAMMAR := $($(PARSER)GRAMMAR)
BASE := $(GRAMMAR)/$($(TARGET))
EXAMPLES = $(GRAMMAR)/examples
JAVASCRIPTG4FILES := $($(PARSER))Parser.g4 $($(PARSER))Lexer.g4
HELLOG4FILES := $($(PARSER)).g4
G4FILES := $($(PARSER)G4FILES)
G4FILE := $(word 1, $(G4FILES))
BAKFILES := $(G4FILES:.g4=.g4.bak)
PARSERS := $($(PARSER))Parser.py $($(PARSER))Lexer.py
PARSE := $(word 1, $(PARSERS))
LISTENER := $(G4FILE:.g4=Listener.py)
JAVASCRIPTEXAMPLE ?= ArrowFunctions.js
HELLOEXAMPLE ?= Hello $(USER)
EXAMPLE := $($(PARSER)EXAMPLE)
JAVASCRIPTBASEFILES := $(G4FILES:.g4=Base.py) transformGrammar.py
BASEFILES := $($(PARSER)BASEFILES)
DOWNLOADED := $(BAKFILES) $(BASEFILES)
GENERATED := $(filter-out $(HELLOG4FILES), $(G4FILES)) $(LISTENER)
GENERATED += $(PARSERS) *.interp *.tokens
HELLOPARSER := helloparser.py
JAVASCRIPTPARSER := jsparse.py
ifneq ($(SHOWENV),)
	export
endif
all: $(EXAMPLE) parse
hello:
	$(MAKE) PARSER=HELLO
$(G4FILES):
	if [ -f "$@.bak" ]; then \
	 mv $@.bak $@; \
	else \
	 wget $(GRAMMAR)/$@; \
	fi
$(EXAMPLE):
	if [ "$(PARSER)" != "HELLO" ]; then \
	 wget $(EXAMPLES)/$@; \
	fi
$(BASEFILES):
	if [ "$(PARSER)" != "HELLO" ]; then \
	 wget $(BASE)/$@; \
	fi
env:
ifneq ($(SHOWENV),)
	env
else
	$(MAKE) SHOWENV=1 $@
endif
transform: $(G4FILES) $(BASEFILES)
	if [ "$(BASEFILES)" ]; then \
	 python3 transformGrammar.py; \
	fi
$(PARSERS): $(G4FILES) transform
	antlr4 -Dlanguage=$($(TARGET)) $(filter-out transform, $+)
clean:
	rm -f dummy $(GENERATED)
	rm -rf __pycache__
	if [ "$(PARSER)" != "HELLO" ]; then $(MAKE) PARSER=HELLO $@; fi
distclean: clean
	rm -f dummy $(DOWNLOADED) $(JAVASCRIPTEXAMPLE)
	if [ "$(PARSER)" != "HELLO" ]; then $(MAKE) PARSER=HELLO $@; fi
parse: $($(PARSER)PARSER) $(PARSE)
	./$< $($(PARSER)EXAMPLE)
