GRAMMARS := https://raw.githubusercontent.com/antlr/grammars-v4/master
JAVASCRIPT := $(GRAMMARS)/javascript/javascript
EXAMPLES = $(JAVASCRIPT)/examples
G4FILES := JavaScriptLexer.g4 JavaScriptParser.g4
# :sigh: antlr4 outputs bad Python...
CORRECTION := 's/!\(this.IsStrictMode\)/not \1/'
EXAMPLEFILES := ArrowFunctions.js
ifneq ($(SHOWENV),)
	export
endif
all: $(G4FILES) $(EXAMPLEFILES) parse
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
%.interp %.tokens %Listener.py %.py: %.g4
	antlr4 -Dlanguage=Python3 $(*:Parser=*.g4)
	sed -i $(CORRECTION) $(*:Parser=Lexer).py
clean:
	rm -f *Lexer.py *Parser.py *Listener.py *.interp *.tokens
parse: jsparse.py JavaScriptParser.py
	./$< $(word 1, $(EXAMPLEFILES))
