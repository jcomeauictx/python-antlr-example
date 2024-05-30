#!/usr/bin/python3
'''
Example JavaScript parser from ANTLR repository

https://github.com/antlr/grammars-v4/tree/master/javascript/javascript/Python3
'''
import sys, logging  # pylint: disable=multiple-imports
from antlr4 import *
from JavaScriptLexer import JavaScriptLexer as JSL
from JavaScriptParser import JavaScriptParser as JSP

logging.basicConfig(level=logging.DEBUG if __debug__ else logging.INFO)

class WriteTreeListener(ParseTreeListener):
    def visitTerminal(self, node:TerminalNode):
        logging.info("Visit Terminal: " + str(node) + " - " + repr(node))

def main(argv):
    input_stream = FileStream(argv[1])
    logging.info("Test started for: %s", argv[1])
    lexer = JSL(input_stream)
    stream = CommonTokenStream(lexer)
    parser = JSP(stream)
    listener = WriteTreeListener()
    logging.info("Created parsers")
    tree = parser.program()
    logging.info('walking parse tree')
    ParseTreeWalker.DEFAULT.walk(listener, tree)
    logging.info('parse tree: %s', tree.toStringTree(recog=parser))
    input_stream.seek(0)
    lexer = JSL(input_stream)
    logging.info('reconstructed:')
    print(''.join([token.text for token in lexer.getAllTokens()]))

if __name__ == '__main__':
    logging.info("Running")
    main(sys.argv)
