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
G4FILES := $($(PARSER))Parser.g4 $($(PARSER))Lexer.g4
PARSERS := $(G4FILES:.g4=.py)
LISTENER := $(PARSER)ParserListener.py
JAVASCRIPTEXAMPLE ?= ArrowFunctions.js
HELLOEXAMPLE ?= <(echo Hello $(USER))
BASEFILES := $(G4FILES:.g4=Base.py) transformGrammar.py
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
	python3 $<
%.interp %.tokens %Listener.py %.py: %.g4 transform
	antlr4 -Dlanguage=$($(TARGET)) $(*:Parser=*.g4)
clean:
	rm -f $(GENERATED)
distclean: clean
	rm -f $(DOWNLOADED)
parse: $($(PARSER)PARSER) $($(PARSER))Parser.py
	./$< $($(PARSER)EXAMPLE)
