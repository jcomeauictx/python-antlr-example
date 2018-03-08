# Python ANTLR Example

I couldn't find any good step-by-step examples of using ANTLR with Python 3 to simply tokenize some code, so I made this.

This includes the steps to do everything from scratch, but also includes all the files you'll be downloading anyway, just so it's a complete package, i.e. you can just run `python ANTLR_tokenize.py` to output the tokens from the example.

## Install Java

- First check Java version with: `java -version`
  - If it doesn't exist then do: `sudo apt-get install default-jre`
- Then: `sudo apt-get install openjdk-8-jre`
- Then: `sudo apt-get install default-jdk` to get `javac`

## Install ANTLR

Follow the `UNIX` and `Testing the installation` instructions from [here](https://github.com/antlr/antlr4/blob/master/doc/getting-started.md)

## Install the ANTLR Python 3 runtime

`sudo pip install antlr4-python3-runtime`

> For some reason this didn't work on Python 3.6 for me, so I had to use a Python 3.5 environment.

## Download the grammar file (and example)

- Go to <https://github.com/antlr/grammars-v4>
- Find the language you want to tokenize
- Download the .g4 file for that language
- In this example, we're going to tokenize Java9, so we can do: `wget https://raw.githubusercontent.com/antlr/grammars-v4/master/java9/Java9.g4`
- Get some example code for your desired language, for the Java9 `helloworld.java` example, we do: `https://raw.githubusercontent.com/antlr/grammars-v4/master/java9/examples/helloworld.java`

## Get the Lexer, Parser and Listener for the target language

`antlr4 -Dlanguage=Python3 Java9.g4`

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
