#!/usr/bin/python3
'''
Example JavaScript parser from ANTLR repository

https://github.com/antlr/grammars-v4/tree/master/javascript/javascript/Python3
'''
import sys, logging  # pylint: disable=multiple-imports
from antlr4 import FileStream, CommonTokenStream, TerminalNode, \
    ParseTreeListener, ParseTreeWalker
from antlr4.TokenStreamRewriter import TokenStreamRewriter
from JavaScriptLexer import JavaScriptLexer as JSL
from JavaScriptParser import JavaScriptParser as JSP

logging.basicConfig(level=logging.DEBUG if __debug__ else logging.INFO)

class WriteTreeListener(ParseTreeListener):
    '''
    Subclass of ParseTreeListener to write out parse tree
    '''
    def visitTerminal(self, node:TerminalNode):
        '''
        Shows terminal nodes visited to stderr
        '''
        logging.info("Visit Terminal: %s - %s", node, repr(node))

def main(filename):
    '''
    Parse file and display it, optionally modifying it
    '''
    input_stream = FileStream(filename)
    logging.info("Test started for: %s", filename)
    lexer = JSL(input_stream)
    stream = CommonTokenStream(lexer)
    rewriter = TokenStreamRewriter(stream)
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
    logging.debug(dir(rewriter))

if __name__ == '__main__':
    main(sys.argv[1])
