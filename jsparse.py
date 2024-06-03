#!/usr/bin/python3
'''
Parse and modify JavaScript

adapted from sample script at
https://github.com/antlr/grammars-v4/tree/master/javascript/javascript/Python3
'''
import sys, logging  # pylint: disable=multiple-imports
from antlr4 import FileStream, CommonTokenStream, ParseTreeWalker
from antlr4.TokenStreamRewriter import TokenStreamRewriter
from JavaScriptLexer import JavaScriptLexer
from JavaScriptParser import JavaScriptParser
from JavaScriptParserListener import JavaScriptParserListener

logging.basicConfig(level=logging.DEBUG if __debug__ else logging.INFO)

LOWERCASE_LETTERS = tuple('abcdefghijklmnopqrstuvwxyz')

class DowngradingJavascriptListener(JavaScriptParserListener):
    '''
    Subclass listener to change `let` to `var` and other primitivizations
    '''
    rewriter = None

    def __init__(self, rewriter):
        '''
        associate a TokenStreamRewriter with this listener
        '''
        self.rewriter = rewriter

    def enterVariableDeclarationList(self, ctx):
        '''
        convert `let` and `const` to `var`
        '''
        logging.debug('ctx: %r: %s', ctx.getText(), show(ctx))
        modifier = ctx.varModifier()
        logging.debug('varModifier: %s', modifier)
        if modifier.getText() != 'var':
            self.rewriter.replaceRangeTokens(
                modifier.start, modifier.stop, 'var'
            )

    def enterArrowFunction(self, ctx):
        '''
        convert arrow function to old-style `function(){;}`
        '''
        logging.debug('ctx: %r: %s', ctx.getText(), show(ctx))
        parameters, arrow, body = ctx.children
        logging.debug('ctx.arrowFunctionParameters: %s',
                      parameters.getText())
        logging.debug('ctx.arrowFunctionBody: %s',
                      body.getText())
        #import pdb; pdb.set_trace()
        self.rewriter.deleteToken(arrow.symbol)
        if parameters.start.text != '(':
            # assume single unparenthesized arg
            self.rewriter.insertBeforeToken(parameters.start, 'function(')
            self.rewriter.insertAfterToken(parameters.stop, ')')
        else:
            # parenthesized arg(s)
            self.rewriter.insertBeforeToken(ctx.start, 'function')
        if body.start.text != '{':
            # assume single statement (for now)
            self.rewriter.insertBeforeToken(body.start, '{return ')
            self.rewriter.insertAfterToken(body.stop, '}')

def main(filename):
    '''
    Parse file, fix for older browsers, and print out modified source
    '''
    input_stream = FileStream(filename)
    lexer = JavaScriptLexer(input_stream)
    tokens = CommonTokenStream(lexer)
    parser = JavaScriptParser(tokens)
    rewriter = TokenStreamRewriter(tokens)
    listener = DowngradingJavascriptListener(rewriter)
    tree = parser.program()
    walker = ParseTreeWalker()
    walker.walk(listener, tree)
    logging.log(logging.NOTSET,  # change to logging.DEBUG to see this
        'parse tree: %s', tree.toStringTree(recog=parser))
    print(listener.rewriter.getDefaultText())

def show(something):
    '''
    a vars-alike that only shows things likely to be of interest
    '''
    candidates = {
        k: getattr(something, k) for k in dir(something)
        if k.startswith(LOWERCASE_LETTERS)
    }
    result = {}
    for k, v in candidates.items():
        if callable(v):
            result[k] = '(function)'
        else:
            result[k] = v
    return result

if __name__ == '__main__':
    main(sys.argv[1])
