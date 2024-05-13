grammar Hello;
r : 'Hello' ID ;
ID : [A-Za-z][A-Za-z0-9]+ ;
WS : [ \t\r\n]+ -> skip;
