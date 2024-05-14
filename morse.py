#!/usr/bin/python3
'''
Morse code translator by Sumeet, yetanotherprogrammingblog.medium.com

Some refactoring done by jc
'''
import sys, re, logging  # pylint: disable=multiple-imports
from antlr4 import *
from MorseLexer import MorseLexer
from MorseParser import MorseParser
from MorseListener import MorseListener

logging.basicConfig(level=logging.DEBUG if __debug__ else logging.INFO)

LETTERS = {
    getattr(MorseParser, chr(letter)): chr(letter).lower()
    for letter in range(ord('A'), ord('Z') + 1)
}
NUMBERNAMES = [
    'ZERO', 'ONE', 'TWO', 'THREE', 'FOUR',
    'FIVE', 'SIX', 'SEVEN', 'EIGHT', 'NINE'
]
NUMBERS = {
    getattr(MorseParser, NUMBERNAMES[index]): index
    for index in range(len(NUMBERNAMES))
}
class MorseToPythonString(MorseListener):
    '''
    pretty-printer for Morse code translation
    '''
    # pylint: disable=invalid-name  # we're using ANTLR naming, not snake_case
    def enterMorse_code(self, ctx:MorseParser.Morse_codeContext):
        print('"', end="")

    def exitMorse_code(self, ctx:MorseParser.Morse_codeContext):
        print('"', end="")

    def enterLetter(self, ctx:MorseParser.LetterContext):
        for child in ctx.getChildren():
            print(LETTERS[child.symbol.type], end="")

    def enterDigit(self, ctx:MorseParser.LetterContext):
        for child in ctx.getChildren():
            print(NUMBERS[child.symbol.type], end="")

def from_morse(*letters):
    '''
    translate Morse code to letters and numbers
    '''
    input_text = ''.join(letters)
    lexer = MorseLexer(InputStream(input_text))
    stream = CommonTokenStream(lexer)
    parser = MorseParser(stream)
    tree = parser.morse_code()
    logging.info(tree.toStringTree(recog=parser))
    stream.seek(0)
    walker = ParseTreeWalker()
    walker.walk(MorseToPythonString(), tree)

def to_morse(*args):
    '''
    translate letters and numbers to Morse code

    (this does not use antlr; the entire program could be written
     more easily and simply without it, but the primary purpose is
     to learn the use of ANTLR. just including this for completeness.)
    '''
    return None  # let's come back to this later

def dispatch(*args):
    '''
    send to correct translator

    we allow either '-' or '_' for dash
    '''
    if re.compile(r'^[.-_ \t\r\n]$').match(''.join(args)):
        return from_morse(*[arg.replace('_', '-') for arg in args])
    return to_morse(*args)

if __name__ == '__main__':
    dispatch(*sys.argv[1:])
