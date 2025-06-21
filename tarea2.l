%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tarea2.tab.h"
extern int yylineno;
int  yylex(void);
%}

%option noyywrap
%option yylineno 


%%
[0-9]+          { yylval.num = atoi(yytext); return INT; }
"\\true"        { yylval.boolv = 1; return TRUE; }
"\\false"       { yylval.boolv = 0; return FALSE; }
"\\and"         { return AND; }
"\\not"         { return NOT; }
"\\if"          { return IF; }

[a-zA-Z]+       { yylval.str = strdup(yytext); return STRING; }

"("             { return '('; }
")"             { return ')'; }
"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"<"             { return '<'; }
"="             { return '='; }
"."             { return '.'; } 
"|"             { return '|'; } 

[ \t]           { /* Ignorar espacios y tabulaciones */ }
\n              {
                  return '\n';
                }
<<EOF>>         { return END_OF_FILE; }
.               {return yytext[0];}
%%

