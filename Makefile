G4FILE := Java9.g4
ANTLR4FILES = $(filter-out $(G4FILE), $(wildcard $(G4FILE:.g4=)*))
run: ANTLR_tokenize.py Java9Lexer.py
	python3 $<
Java9Lexer.py: Java9.g4
	antlr4 -Dlanguage=Python3 $<
	sed -i s'/[(]char[)]//g' $@
$(G4FILE):
	wget https://raw.githubusercontent.com/antlr/grammars-v4/master/java9/$@
clean:
	rm -f dummy $(ANTLR4FILES)
distclean: clean
	rm -f dummy $(G4FILE)
