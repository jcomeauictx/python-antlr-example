#!/usr/bin/python
'''
Another example from Sumeet's intoductory article

https://yetanotherprogrammingblog.medium.com/antlr-with-python-974c756bdb1b
'''
grammar Morse;

// Parser rules
morse_code : (letter | digit | WS)* ;

letter : A | B | C | D | E | F | G | H | I | J | K | L | M |
         N | O | P | Q | R | S | T | U | V | W | X | Y | Z ;

digit : ZERO | ONE | TWO | THREE | FOUR | FIVE | SIX | SEVEN | EIGHT | NINE ;


// Lexer rules
A : '.-' ;
B : '-...' ;
C : '-.-.' ;
D : '-..' ;
E : '.' ;
F : '..-.' ;
G : '--.' ;
H : '....' ;
I : '..' ;
J : '.---' ;
K : '-.-' ;
L : '.-..' ;
M : '--' ;
N : '-.' ;
O : '---' ;
P : '.--.' ;
Q : '--.-' ;
R : '.-.' ;
S : '...' ;
T : '-' ;
U : '..-' ;
V : '...-' ;
W : '.--' ;
X : '-..-' ;
Y : '-.--' ;
Z : '--..' ;

ZERO : '-----' ;
ONE : '.----' ;
TWO : '..---' ;
THREE : '...--' ;
FOUR : '....-' ;
FIVE : '.....' ;
SIX : '-....' ;
SEVEN : '--...' ;
EIGHT : '---..' ;
NINE : '----.' ;

WS : [ \t\r\n]+ -> skip ;
