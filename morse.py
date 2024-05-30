#!/usr/bin/python3
'''
Morse code translator by Sumeet

https://yetanotherprogrammingblog.medium.com/antlr-with-python-974c756bdb1b

Some refactoring done by jc
'''
import sys, re, logging  # pylint: disable=multiple-imports
from ast import literal_eval as eval  # pylint: disable=redefined-builtin
from antlr4 import InputStream, CommonTokenStream, ParseTreeWalker
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
NUMBERS = {  # this one is for the morse-to-text translator
    getattr(MorseParser, NUMBERNAMES[index]): str(index)
    for index in range(len(NUMBERNAMES))
}
NUMBERS.update({  # this one is for text-to-morse
    name: str(NUMBERNAMES.index(name)) for name in NUMBERNAMES
})
SEPARATORS = {
    MorseParser.SENTENCE: '.',
    MorseParser.WORD: ' ',
    MorseParser.SPACE: '',
}
class MorseToPythonString(MorseListener):
    '''
    pretty-printer for Morse code translation
    '''
    # pylint: disable=invalid-name  # we're using ANTLR naming, not snake_case
    def enterMorse_code(self, ctx:MorseParser.Morse_codeContext):
        print('"', end="")

    def exitMorse_code(self, ctx:MorseParser.Morse_codeContext):
        print('"')

    def enterLetter(self, ctx:MorseParser.LetterContext):
        for child in ctx.getChildren():
            print(LETTERS[child.symbol.type], end="")

    def enterDigit(self, ctx:MorseParser.LetterContext):
        for child in ctx.getChildren():
            print(NUMBERS[child.symbol.type], end="")

    def enterSpace(self, ctx:MorseParser.SpaceContext):
        for child in ctx.getChildren():
            print(SEPARATORS[child.symbol.type], end="")

def from_morse(string):
    '''
    translate Morse code to letters and numbers
    '''
    lexer = MorseLexer(InputStream(string))
    stream = CommonTokenStream(lexer)
    parser = MorseParser(stream)
    tree = parser.morse_code()
    logging.info(tree.toStringTree(recog=parser))
    stream.seek(0)
    walker = ParseTreeWalker()
    walker.walk(MorseToPythonString(), tree)

def to_morse(string):
    '''
    translate letters and numbers to Morse code

    (this does not use antlr; the entire program could be written
     more easily and simply without it, but the primary purpose is
     to learn the use of ANTLR. just including this for completeness.)
    '''
    string = string.strip('"').lower()  # strip quotes and lowercase all
    # skip <INVALID> entries in both literals and symbols
    literals = [eval(l) for l in MorseLexer.literalNames[1:]]
    symbols = MorseLexer.symbolicNames[1:len(literals) + 1]
    for symbol in symbols:
        if len(symbol) == 1:
            symbols[symbols.index(symbol)] = symbol.lower()
        else:
            symbols[symbols.index(symbol)] = NUMBERS[symbol]
    translator = dict(zip(symbols, literals))
    for sentence in string.split('.'):
        for word in sentence.split():
            for letter in word:
                print(translator[letter], end=' ')
            print('  ', end='')  # extra two spaces at end of word
        print('   ', end='')  # extra 3 spaces at end of sentence
    print()  # final end-of-line

def dispatch(string):
    '''
    send to correct translator

    we allow either '-' or '_' for dash
    '''
    if re.compile(r'^[ \t\r\n._-]+$').match(string):
        logging.debug('translating Morse code "%s" to letters and numbers',
                      string)
        return from_morse(string.replace('_', '-'))
    logging.debug('translating letters and numbers "%s" to Morse code', string)
    return to_morse(string)

if __name__ == '__main__':
    dispatch(' '.join(sys.argv[1:]))
