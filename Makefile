GRAMMARS := https://raw.githubusercontent.com/antlr/grammars-v4/master
JAVASCRIPT := $(GRAMMARS)/javascript/javascript
BASE := $(JAVASCRIPT)/Python3
EXAMPLES = $(JAVASCRIPT)/examples
G4FILES := JavaScriptLexer.g4 JavaScriptParser.g4
# :sigh: antlr4 outputs bad Python...
CORRECTION := 's/!\(this.IsStrictMode\)/not \1/'
EXAMPLEFILES := ArrowFunctions.js
BASEFILES := $(G4FILES:.g4=Base.py) transformGrammar.py
ifneq ($(SHOWENV),)
	export
endif
all: $(EXAMPLEFILES) parse
$(G4FILES):
	wget $(JAVASCRIPT)/$@
$(EXAMPLEFILES):
	wget $(EXAMPLES)/$@
$(BASEFILES):
	wget $(BASE)/$@
env:
ifneq ($(SHOWENV),)
	env
else
	$(MAKE) SHOWENV=1 $@
endif
transform: transformGrammar.py $(G4FILES) $(BASEFILES)
	python3 $<
%.interp %.tokens %Listener.py %.py: %.g4 transform
	antlr4 -Dlanguage=Python3 $(*:Parser=*.g4)
	#sed -i $(CORRECTION) $(*:Parser=Lexer).py
clean:
	rm -f *Lexer.py *Parser.py *Listener.py *.interp *.tokens
parse: jsparse.py JavaScriptParser.py
	./$< $(word 1, $(EXAMPLEFILES))
