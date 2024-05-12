#!/usr/bin/python3
'''
Example code from Sumeet at yetanotherprogrammingblog.medium.com/

antlr-with-python-974c756bdb1b
'''
import sys
from antlr4 import InputStream, CommonTokenStream
from HelloLexer import HelloLexer
from HelloParser import HelloParser

def hello(*greeting):
    lexer = HelloLexer(InputStream(' '.join(greeting)))
    stream = CommonTokenStream(lexer)
    parser = HelloParser(stream)
    tree = parser.r()
    print(tree.toStringTree(recog=parser))

if __name__ == '__main__':
    hello(*sys.argv[1:])
