#!/usr/bin/python3
from antlr4 import *
from Java9Lexer import Java9Lexer
from Java9Parser import Java9Parser

code = open('helloworld.java', 'r').read()
codeStream = InputStream(code)
lexer = Java9Lexer(codeStream)

tokens = lexer.getAllTokens()

for t in tokens:
    print(t.text, t.type)
