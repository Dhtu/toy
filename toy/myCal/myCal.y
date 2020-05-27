/* simplest version of calculator */

%{
#include <stdio.h>
#include <stdarg.h>
#include <math.h>
int yyerror(const char *, ...);
extern int yylex();
extern int yyparse();
%}


%union {
    double floatval;
}

/* declare tokens */
%token <floatval>NUM
%token ADD SUB MUL DIV ABS EXP
%token OP CP
%token EOL
%type <floatval> exp

%left ADD SUB
%left MUL DIV
%left EXP
%left OP CP

%%

calclist: /* nothing */
    | calclist exp EOL { printf("= %lf\n> ", $2); }
    | calclist EOL { printf("> "); } /* blank line or a comment */
;

exp: exp ADD exp {$$ = $1 + $3;}
    |exp SUB exp {$$ = $1 - $3; }
    |exp MUL exp { $$ = $1 * $3; }
    |exp DIV exp { $$ = $1 / $3; }
    |exp EXP exp { $$ = pow($1,$3);}
    |SUB exp { $$ = 0 - $2; }
    |OP exp CP { $$ = $2; }
    |NUM 
;
%%
int main()
{
    printf("> "); 
    yyparse();
    return 0;
}
int yyerror(const char *s, ...)
{
    int ret;
    va_list va;
    va_start(va, s);
    ret = vfprintf(stderr, s, va);
    va_end(va);
    return ret;
}