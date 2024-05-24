grammar Morse;

// Parser rules
morse_code : (letter | digit | space)* ;

letter : A | B | C | D | E | F | G | H | I | J | K | L | M |
         N | O | P | Q | R | S | T | U | V | W | X | Y | Z ;

digit : ZERO | ONE | TWO | THREE | FOUR | FIVE | SIX | SEVEN | EIGHT | NINE ;

space: WORDSPACE | LETTERSPACE ;

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

WORDSPACE: [ ]{3,} | [\t] ;
LETTERSPACE: [ \r\n]+ -> skip ;
