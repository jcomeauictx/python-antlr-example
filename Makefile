G4FILE := Java9.g4
ANTLR4FILES = $(filter-out $(G4FILE), $(wildcard $(G4FILE:.g4=)*))
run: testdelete.py Java9Lexer.py
	python3 $<
Java9Lexer.py: Java9.g4
	antlr4 -Dlanguage=Python3 $<
	sed -i s'/[(]char[)]//g' Java9Lexer.py
clean:
	rm -f dummy $(ANTLR4FILES)
