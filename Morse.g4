grammar Morse;

// Parser rules
morse_code : (letter | digit | space)* ;

letter : A | B | C | D | E | F | G | H | I | J | K | L | M |
         N | O | P | Q | R | S | T | U | V | W | X | Y | Z ;

digit : ZERO | ONE | TWO | THREE | FOUR | FIVE | SIX | SEVEN | EIGHT | NINE ;

space: SENTENCE | WORD | SPACE | TAB ;

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

SENTENCE : WORD WORD ;
WORD : SPACE SPACE SPACE | TAB ;
SPACE : [ ] | [\r\n]+ ;
TAB : [\t] ;
