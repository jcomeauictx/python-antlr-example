grammar Hello;
r : '[Hh]ello' ID ;
ID : [A-Za-z][A-Za-z0-9]+ ;
WS : [ \t\r\n]+ -> skip;
