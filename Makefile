SHELL := /bin/bash
GRAMMARS := https://raw.githubusercontent.com/antlr/grammars-v4/master
JAVASCRIPT := JavaScript
PYTHON := Python3
HELLO := Hello
PARSER ?= JAVASCRIPT
TARGET ?= PYTHON
JAVASCRIPTGRAMMAR := $(GRAMMARS)/javascript/javascript
BASE := $($(PARSER)GRAMMAR)/$($(TARGET))
EXAMPLES = $($(PARSER)GRAMMAR)/examples
JAVASCRIPTG4FILES := $($(PARSER))Parser.g4 $($(PARSER))Lexer.g4
HELLOG4FILES := $($(PARSER)).g4
G4FILES := $($(PARSER)G4FILES)
PARSERS := $(G4FILES:.g4=.py)
PARSE := $(word 1, $(PARSERS))
LISTENER := $(PARSER)ParserListener.py
JAVASCRIPTEXAMPLE ?= ArrowFunctions.js
HELLOEXAMPLE ?= <(echo Hello $(USER))
JAVASCRIPTBASEFILES := $(G4FILES:.g4=Base.py) transformGrammar.py
BAKFILES := $(G4FILES:.g4=g4.bak)
DOWNLOADED := $(BAKFILES) $(BASEFILES)
GENERATED := $(G4FILES) $(LISTENER) *.interp *.tokens
HELLOPARSER := helloparser.py
JAVASCRIPTPARSER := jsparse.py
ifneq ($(SHOWENV),)
	export
endif
all: $(EXAMPLEFILES) parse
hello:
	$(MAKE) PARSER=HELLO
$(G4FILES):
	if [ -f "$@.bak" ]; then \
	 mv $@.bak $@; \
	else \
	 wget $(JAVASCRIPT)/$@; \
	fi
$(EXAMPLEFILES):
	wget $(EXAMPLES)/$@
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
transform: transformGrammar.py $(G4FILES) $(BASEFILES)
	if [ "$(BASEFILES)" ]; then \
	 python3 $<; \
	fi
%.interp %.tokens %Listener.py %.py: %.g4 transform
	antlr4 -Dlanguage=$($(TARGET)) $(*:Parser=*.g4)
clean:
	rm -f dummy $(GENERATED)
distclean: clean
	rm -f dummy $(DOWNLOADED)
parse: $($(PARSER)PARSER) $(PARSE)
	./$< $($(PARSER)EXAMPLE)
