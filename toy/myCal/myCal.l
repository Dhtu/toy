/* recognize tokens for the calculator and print them out */

%{
# include "myCal.tab.h"
extern int yyerror(const char *, ...);
%}

%%
"+"	{ return ADD; }
"-"	{ return SUB; }
"*"	{ return MUL; }
"/"	{ return DIV; }
"^" { return EXP; }
"(" { return OP; }
")" { return CP; }
[-+]?[0-9]*\.?[0-9]+ { yylval.floatval = atof(yytext); return NUM;}


\n      { return EOL; }
"//".*  
[ \t]   { /* ignore white space */ }
.	{ yyerror("Mystery character %c\n", *yytext); }
%%