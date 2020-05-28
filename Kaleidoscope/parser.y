%{
    #include "AST.h"
    #include <stdio.h>
    #include <iostream>
    #include <stdlib.h>

    extern int yylex();
    void yyerror(const char *s) { printf("ERROR: %s\n", s); }
%}

/* Represents the many different ways we can access our data */
%union {
    ExprAST *expr;
    std::string *string;
    std::vector<ExprAST*> *exprvec;
    char yychar;
    int token;
}

/* Define our terminal symbols (tokens). This should
   match our tokens.l lex file. We also define the ExprAST type
   they represent.
 */
%token <string> TIDENTIFIER TINTEGER TDOUBLE
%token <token> TCEQ TCNE TCLT TCLE TCGT TCGE TEQUAL BINOP
%token <token> TLPAREN TRPAREN TLBRACE TRBRACE TCOMMA TDOT
%token <token> TPLUS TMINUS TMUL TDIV
%token <token> TIF TTHEN TELSE TFOR TIN
%token <token> TRETURN TEXTERN

/* Define the type of ExprAST our nonterminal symbols represent.
   The types refer to the %union declaration above. Ex: when
   we call an ident (defined by union type ident) we are really
   calling an (NIdentifier*). It makes the compiler happy.
 */
%type <expr> expr 
%type <exprvec> call_args

/* Operator precedence for mathematical operators */
%left TPLUS TMINUS
%left TMUL TDIV

// %start program

%%
call_args : /*blank*/  { $$ = new std::vector<ExprAST*>(); }
          | expr { $$ = new std::vector<ExprAST*>(); $$->push_back($1); }
          | call_args TCOMMA expr  { $1->push_back($3);$$=$1; }
          ;


expr : TDOUBLE { 
        auto Result = new NumberExprAST(atof($1->c_str())); 
        delete $1;
        std::cout<<"Parse double: "<<((*Result).Val)<<std::endl;
        $$ = Result;
    }
    | TLPAREN expr TRPAREN {
        auto Result = $2;
        std::cout<<"Parse (expr)"<<std::endl;
        $$ = Result;
    }
    | TIDENTIFIER {
        auto Result = new VariableExprAST(*$1); 
        delete $1;
        std::cout<<"Parse Variable: "<<((*Result).Name)<<std::endl;
        $$ = Result;
    }
    | TIDENTIFIER TLPAREN call_args TRPAREN{
        $$ = new CallExprAST(*$1,*$3);
        std::cout<<"Call length: "<<dynamic_cast<CallExprAST *>($$)->Args.size()<<std::endl;
    }
    | expr BINOP expr{
        std::cout<<"binOP: "<<char($2)<<std::endl;
        $$ = new BinaryExprAST(char($2),$1,$3);
    }
        



