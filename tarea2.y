%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylineno; 

void yyerror(const char *s);
int  yylex(void);
%}

/* Union de los tipos soportados */
%union {
  int   num;   /* para nexpr */
  int   boolv; /* para bexpr (0=false, 1=true) */
  char *str;   /* para sexpr */
}

/* Tokens */
%token <num>   INT
%token <boolv> TRUE FALSE
%token <str>   STRING
%token AND NOT IF
%token END_OF_FILE 0 /* Token para el fin de archivo */

/* Tipos de cada no-terminal */
%type <num>   nexpr
%type <boolv> bexpr
%type <str>   sexpr


/* Símbolo inicial de la gramática */
%start line_list

%%

line_list:
    /* puede estar vacío */
  | line_list line
  ;
line:
    '\n'
  | expr '\n' 
  | expr END_OF_FILE
  ;

expr:
    nexpr   { printf("%d\n", $1); }
  | bexpr   { printf("%s\n", $1 ? "\\true" : "\\false"); }
  | sexpr   { printf("%s\n", $1); free($1); }
  ;

/* Gramática para expresiones numéricas (nexpr) */
nexpr:
    INT                             { $$ = $1; }
  | '(' nexpr ')'               { $$ = $2; }
  | '(' '-' nexpr ')'               { $$ = -$3; }
  | '(' nexpr '+' nexpr ')'         { $$ = $2 + $4; }
  | '(' nexpr '*' nexpr ')'         { $$ = $2 * $4; }
  | '|' sexpr '|'                   { $$ = (int)strlen($2); free($2); }
  | '(' IF bexpr nexpr nexpr ')'    { $$ = $3 ? $4 : $5; }
  ;

/* Gramática para expresiones booleanas (bexpr) */
bexpr:
    TRUE                            { $$ = 1; }
  | FALSE                           { $$ = 0; }
  | '(' nexpr '<' nexpr ')'         { $$ = ($2 < $4); }
  | '(' nexpr '=' nexpr ')'         { $$ = ($2 == $4); }
  | '(' NOT bexpr ')'               { $$ = !$3; }
  | '(' bexpr AND bexpr ')'         { $$ = $2 && $4; }
  | '(' IF bexpr bexpr bexpr ')'    { $$ = $3 ? $4 : $5; }
  ;

/* Gramática para expresiones de cadenas (sexpr) */
sexpr:
    '(' STRING ')'                  { $$ = $2; }
  | '(' sexpr '.' sexpr ')'         {
                                      size_t L1 = strlen($2);
                                      size_t L2 = strlen($4);
                                      $$ = malloc(L1 + L2 + 1);
                                      if (!$$) { yyerror("falló malloc"); exit(1); }
                                      memcpy($$, $2, L1);
                                      memcpy($$ + L1, $4, L2 + 1);
                                      free($2); free($4);
                                    }
  | '(' IF bexpr sexpr sexpr ')'    {
                                      if ($3) {
                                          $$ = $4;
                                          free($5);
                                      } else {
                                          $$ = $5;
                                          free($4);
                                      }
                                    }
  ;

%%

int main(void) {
  return yyparse();
}

void yyerror(const char *s) {
  fprintf(stderr, "Error: %s en linea %d\n", s, yylineno);
  exit(1);
}