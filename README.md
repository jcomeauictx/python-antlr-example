# Python ANTLR Example

I googled for an example of using ANTLR with Python3 and found bentrevett's
repo, so I forked it to make a new one, up to date (May 2024) and for
JavaScript instead of Java9.

I'm assuming Debian Bookworm or later as the dev environment.

## Install ANTLR and Python bindings

sudo apt install antlr4 python3-antlr4

## Download the grammar file (and example)

- Go to <https://github.com/antlr/grammars-v4>
- Find the language you want to tokenize
- Download the .g4 file(s) for that language
- Get some example code for your desired language

This is all built into the Makefile, so simply: `make` to download and run.

## Write the code to tokenize

The parser `jsparse.py` was adapted from the README of the javascript
grammar page.

## References

* [Hello Antlr](https://yetanotherprogrammingblog.medium.com/antlr-with-python-974c756bdb1b)
* [Fixing lack of Base files](https://stackoverflow.com/questions/77216117/antlr-not-generating-parserbase)
