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
"def"                   return TOKEN(TDEF);
"return"                return TOKEN(TRETURN);
"if"                    return TOKEN(TIF);
"then"                  return TOKEN(TTHEN);
"else"                  return TOKEN(TELSE);
"for"                   return TOKEN(TFOR);
"in"                    return TOKEN(TIN);
[a-zA-Z_][a-zA-Z0-9_]*  SAVE_TOKEN; return TIDENTIFIER;
[0-9]+                  SAVE_TOKEN; return TINTEGER;
[0-9]*\.?[0-9]+         SAVE_TOKEN; return TDOUBLE;
"="                     {yylval.yychar = *yytext; return BINOP;}
"=="                    return TOKEN(TCEQ);
"!="                    return TOKEN(TCNE);

"<"                     {yylval.yychar = *yytext; return BINOP;}
"<="                    return TOKEN(TCLE);
">"                     {yylval.yychar = *yytext; return BINOP;}
">="                    return TOKEN(TCGE);
"("                     return TOKEN(TLPAREN);
")"                     return TOKEN(TRPAREN);
"{"                     return TOKEN(TLBRACE);
"}"                     return TOKEN(TRBRACE);

","                     return TOKEN(TCOMMA);
"."                     return TOKEN(TDOT);

"+"                     {yylval.yychar = *yytext; return BINOP;}
"-"                     {yylval.yychar = *yytext; return BINOP;}
"*"                     {yylval.yychar = *yytext; return BINOP;}
"/"                     {yylval.yychar = *yytext; return BINOP;}

"//".*                  {printf("注释: %s\n",yytext);}
.                       {printf("Unknown token!\n"); yylval.yychar = *yytext;}

%%
