%{
#include <string>
#include "AST.h"
#include "parser.tab.h"

#define SAVE_TOKEN  yylval.string = new std::string(yytext, yyleng)
#define TOKEN(t)    (yylval.token = t)
%}

%option noyywrap

%%

[ \t\n]                 ;
"extern"                return TOKEN(TEXTERN);
"return"                return TOKEN(TRETURN);
"if"                    return TOKEN(TIF);
"then"                  return TOKEN(TTHEN);
"else"                  return TOKEN(TELSE);
"for"                   return TOKEN(TFOR);
"in"                    return TOKEN(TIN);
[a-zA-Z_][a-zA-Z0-9_]*  SAVE_TOKEN; return TIDENTIFIER;
[0-9]+                  SAVE_TOKEN; return TINTEGER;
[0-9]*\.?[0-9]+         SAVE_TOKEN; return TDOUBLE;
"="                     return TOKEN(TEQUAL);
"=="                    return TOKEN(TCEQ);
"!="                    return TOKEN(TCNE);

"<"                     return TOKEN(TCLT);
"<="                    return TOKEN(TCLE);
">"                     return TOKEN(TCGT);
">="                    return TOKEN(TCGE);
"("                     return TOKEN(TLPAREN);
")"                     return TOKEN(TRPAREN);
"{"                     return TOKEN(TLBRACE);
"}"                     return TOKEN(TRBRACE);

","                     return TOKEN(TCOMMA);
"."                     return TOKEN(TDOT);

"+"                     return TOKEN(TPLUS);
"-"                     return TOKEN(TMINUS);
"*"                     return TOKEN(TMUL);
"/"                     return TOKEN(TDIV);

"//".*                  {printf("注释: %s\n",yytext);}
.                       {printf("Unknown token!\n"); yylval.yychar = yytext;}

%%
