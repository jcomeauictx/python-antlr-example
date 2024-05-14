SHELL := /bin/bash
GRAMMARS := https://raw.githubusercontent.com/antlr/grammars-v4/master
JAVASCRIPT := JavaScript
PYTHON := Python3
HELLO := Hello
MORSE := Morse
PARSER ?= JAVASCRIPT
TARGET ?= PYTHON
JAVASCRIPTGRAMMAR := $(GRAMMARS)/javascript/javascript
GRAMMAR := $($(PARSER)GRAMMAR)
BASE := $(GRAMMAR)/$($(TARGET))
EXAMPLES = $(GRAMMAR)/examples
JAVASCRIPTG4FILES := $(JAVASCRIPT)Parser.g4 $(JAVASCRIPT)Lexer.g4
HELLOG4FILES := $(HELLO).g4
MORSEG4FILES := $(MORSE).g4
G4FILES := $($(PARSER)G4FILES)
G4FILE := $(word 1, $(G4FILES))
BAKFILES := $(G4FILES:.g4=.g4.bak)
PARSERS := $($(PARSER))Parser.py $($(PARSER))Lexer.py
PARSE := $(word 1, $(PARSERS))
LISTENER := $(G4FILE:.g4=Listener.py)
JAVASCRIPTEXAMPLE ?= ArrowFunctions.js
HELLOEXAMPLE ?= Hello $(USER)
MORSEEXAMPLE ?= .... . .-.. .-.. ---
EXAMPLE := $($(PARSER)EXAMPLE)
JAVASCRIPTBASEFILES := $(G4FILES:.g4=Base.py) transformGrammar.py
BASEFILES := $($(PARSER)BASEFILES)
DOWNLOADED = $(BAKFILES) $(BASEFILES) $(JAVASCRIPTEXAMPLE)
DOWNLOADED += *Parser.g4 *Lexer.g4
GENERATED = *Parser.py *Lexer.py
GENERATED += *Listener.py *.interp *.tokens __pycache__
HELLOPARSER := helloparser.py
JAVASCRIPTPARSER := jsparse.py
MORSEPARSER := morse.py
ifneq ($(SHOWENV),)
	export
endif
all: $(EXAMPLE) parse
hello:
	$(MAKE) PARSER=HELLO
morse:
	$(MAKE) PARSER=MORSE
$(G4FILES):
	if [ -f "$@.bak" ]; then \
	 mv $@.bak $@; \
	else \
	 wget $(GRAMMAR)/$@; \
	fi
$(EXAMPLE):
	if [ "$(PARSER)" = "JAVASCRIPT" ]; then \
	 wget $(EXAMPLES)/$@; \
	fi
$(BASEFILES):
	if [ "$(PARSER)" = "JAVASCRIPT" ]; then \
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
	rm -rf dummy $(GENERATED) __pycache__
distclean: clean
	rm -f dummy $(DOWNLOADED)
parse: $($(PARSER)PARSER) $(PARSE)
	./$< $($(PARSER)EXAMPLE)
