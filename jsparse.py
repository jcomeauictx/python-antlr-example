#!/usr/bin/python3
'''
Example JavaScript parser from ANTLR repository

https://github.com/antlr/grammars-v4/tree/master/javascript/javascript/Python3
'''
import sys
from antlr4 import *
import JavaScriptLexer
import JavaScriptParser

JSL = JavaScriptLexer.JavaScriptLexer
JSP = JavaScriptParser.JavaScriptParser

class WriteTreeListener(ParseTreeListener):
    def visitTerminal(self, node:TerminalNode):
        print ("Visit Terminal: " + str(node) + " - " + repr(node))

def main(argv):
    input_stream = FileStream(argv[1])
    print("Test started for: " + argv[1])
    lexer = JSL(input_stream)
    stream = CommonTokenStream(lexer)
    parser = JSP(stream)
    print("Created parsers")
    tree = parser.program()
    ParseTreeWalker.DEFAULT.walk(WriteTreeListener(), tree)

if __name__ == '__main__':
    print("Running")
    main(sys.argv)
