GRAMMARS := https://github.com/antlr/grammars-v4/blob/master
JAVASCRIPT := $(GRAMMARS)/javascript/javascript
EXAMPLES = $(JAVASCRIPT)/examples
G4FILES := JavaScriptLexer.g4 JavaScriptParser.g4
EXAMPLEFILES := ArrowFunctions.js
ifneq ($(SHOWENV),)
	export
endif
all: $(G4FILES) $(EXAMPLEFILES)
$(G4FILES):
	wget $(JAVASCRIPT)/$@
$(EXAMPLEFILES):
	wget $(EXAMPLES)/$@
env:
ifneq ($(SHOWENV),)
	env
else
	$(MAKE) SHOWENV=1 $@
endif
