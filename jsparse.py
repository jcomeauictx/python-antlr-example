#!/usr/bin/python3
'''
Example JavaScript parser from ANTLR repository

https://github.com/antlr/grammars-v4/tree/master/javascript/javascript/Python3
'''
import sys, logging  # pylint: disable=multiple-imports
from antlr4 import *
import JavaScriptLexer
import JavaScriptParser

logging.basicConfig(level=logging.DEBUG if __debug__ else logging.INFO)

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
    logging.info('walking parse tree')
    ParseTreeWalker.DEFAULT.walk(WriteTreeListener(), tree)
    logging.info('reconstructed:')
    print(tree.toStringTree(recog=parser))
    logging.info('token list')
    input_stream.seek(0)
    lexer = JSL(input_stream)
    for token in lexer.getAllTokens():
        logging.info('"%s", %s', token.text, token.type)

if __name__ == '__main__':
    print("Running")
    main(sys.argv)
