# Python ANTLR Example

I googled for an example of using ANTLR with Python3 and found bentrevett's
repo, so I forked it to make a new one, up to date (May 2024) and for
JavaScript instead of Java9.

I'm assuming Debian Bookworm or later as the dev environment.

## Install ANTLR

sudo apt install python3-antlr4

## Download the grammar file (and example)

- Go to <https://github.com/antlr/grammars-v4>
- Find the language you want to tokenize
- Download the .g4 file for that language
- Get some example code for your desired language

This is all built into the Makefile, so simply: `make` to download and run.

## Write the code to tokenize

Make a new file called something like `ANTLR_tokenize.py` and enter:

``` python
from antlr4 import *
from Java9Lexer import Java9Lexer

code = open('helloworld.java', 'r').read()
codeStream = InputStream(code)
lexer = Java9Lexer(codeStream)

tokens = lexer.getAllTokens()

for t in tokens:
    print(t.text, t.type)
```

Note: do NOT call your file `tokenize.py`, I'm not sure why but it messes with the lexer.

Note: the Python 3 runtime is still in beta, so not everything works! To make this example work you need to go into the `Java9Lexer` and change lines 792 and 802 from:

``` python
return Character.isJavaIdentifierPart(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))
```

to:

``` python
return Character.toCodePoint(chr(_input.LA(-2)), chr(_input.LA(-1)))
```

## Run the example

`python ANTLR_tokenize.py`

This will print out each token along with its corresponding "type". The type will just be an integer, and if you go into the Java9Lexer.py, you will see what each integer represents. The problem is that the 'types' won't line up across languages, i.e. Identifier is 115 in Java9, but 102 in Java8. If you need it so you want everything to line up across languages, you're going to have to make a look-up table with a quick copy and paste and convert to a dictionary.

## References

[Hello Antlr](https://yetanotherprogrammingblog.medium.com/antlr-with-python-974c756bdb1b)
[Fixing lack of Base files](https://stackoverflow.com/questions/77216117/antlr-not-generating-parserbase)
