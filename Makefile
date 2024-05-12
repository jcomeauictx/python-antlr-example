GRAMMARS := https://raw.githubusercontent.com/antlr/grammars-v4/master
JAVASCRIPT := JavaScript
PYTHON := Python3
PARSER ?= JAVASCRIPT
TARGET ?= PYTHON
JAVASCRIPTGRAMMAR := $(GRAMMARS)/javascript/javascript
BASE := $($(PARSER)GRAMMAR)/$($(TARGET))
EXAMPLES = $($(PARSER)GRAMMAR)/examples
G4FILES := $($(PARSER))Parser.g4 $($(PARSER))Lexer.g4
PARSERS := $(G4FILES:.g4=.py)
LISTENER := $(PARSER)ParserListener.py
EXAMPLEFILES := ArrowFunctions.js
BASEFILES := $(G4FILES:.g4=Base.py) transformGrammar.py
BAKFILES := $(G4FILES:.g4=g4.bak)
DOWNLOADED := $(BAKFILES) $(BASEFILES)
GENERATED := $(G4FILES) $(LISTENER) *.interp *.tokens
ifneq ($(SHOWENV),)
	export
endif
all: $(EXAMPLEFILES) parse
hello:
	$(MAKE) PARSER=Hello
$(G4FILES):
	if [ -f "$@.bak" ]; then \
	 mv $@.bak $@; \
	else \
	 wget $(JAVASCRIPT)/$@; \
	fi
$(EXAMPLEFILES):
	wget $(EXAMPLES)/$@
$(BASEFILES):
	if [ "$(PARSER) != "Hello" ]; then \
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
parse: jsparse.py $($(PARSER))Parser.py
	./$< $(word 1, $(EXAMPLEFILES))
