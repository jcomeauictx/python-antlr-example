import logging
from antlr4 import InputStream, CommonTokenStream
from antlr4.TokenStreamRewriter import TokenStreamRewriter
from Java9Lexer import Java9Lexer
logging.basicConfig(level=logging.DEBUG)
source = open("./helloworld.java", "r")
codeStream = InputStream(source.read())
lexer = Java9Lexer(codeStream)
token_stream = CommonTokenStream(lexer)
token_stream.fill()
rewriter = TokenStreamRewriter(token_stream)
logging.debug('before removing comment: %s', rewriter.getDefaultText())
for token in token_stream.tokens:
    if token.type == Java9Lexer.COMMENT:
        rewriter.deleteToken(token)
logging.debug('after removing comment: %s', rewriter.getDefaultText())
