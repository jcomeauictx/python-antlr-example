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
from JavaScriptParserListener import JavaScriptParserListener

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

class DowngradeJavascriptListener(JavaScriptParserListener):
    '''
    Subclass listener to change `let` to `var` and other primitivizations
    '''
    rewriter = None

    def __init__(self, rewriter):
        '''
        associate a TokenStreamRewriter with this listener
        '''
        self.rewriter = rewriter

    def exitVariableStatement(self, ctx):
        '''
        convert `let` and `const` to `var`
        '''
        logging.info('ctx: %s', ctx.getText())

    def exitArrowFunction(self, ctx):
        '''
        convert arrow function to old-style `function(){;}`
        '''
        logging.info('ctx: %s', ctx.getText())

    def exitProgram(self, ctx):
        '''
        print out modified source
        '''
        logging.info('ctx: %s', ctx.getText())

def main(filename):
    '''
    Parse file and display it, optionally modifying it
    '''
    input_stream = FileStream(filename)
    logging.info("Test started for: %s", filename)
    lexer = JSL(input_stream)
    tokens = CommonTokenStream(lexer)
    parser = JSP(tokens)
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
    logging.debug("let's do it again, this time to modify the javascript")
    input_stream.seek(0)
    lexer = JSL(input_stream)
    tokens = CommonTokenStream(lexer)
    parser = JSP(tokens)
    rewriter = TokenStreamRewriter(tokens)
    listener = DowngradeJavascriptListener(rewriter)
    tree = parser.program()
    walker = ParseTreeWalker()
    walker.walk(listener, tree)
    print(listener.rewriter.getText('default', 0, -1))

if __name__ == '__main__':
    main(sys.argv[1])
