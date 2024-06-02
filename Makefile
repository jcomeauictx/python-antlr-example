run: testdelete.py Java9Lexer.py
	python3 $<
Java9Lexer.py: Java9.g4
	antlr4 -Dlanguage=Python3 $<
	sed -i s'/[(]char[)]//g' Java9Lexer.py
