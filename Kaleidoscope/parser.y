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
    PrototypeAST *prototype;
    FunctionAST *function;
    std::string *string;
    std::vector<AST*> *astvec;
    std::vector<ExprAST*> *exprvec;
    std::vector<std::string> *strvec;
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
%token <token> TRETURN TEXTERN TDEF

/* Define the type of ExprAST our nonterminal symbols represent.
   The types refer to the %union declaration above. Ex: when
   we call an ident (defined by union type ident) we are really
   calling an (NIdentifier*). It makes the compiler happy.
 */
%type <expr> expr
%type <exprvec> call_args
%type <function> func_decl
%type <prototype> prototype
%type <strvec> func_decl_args

/* Operator precedence for mathematical operators */
%left TPLUS TMINUS
%left TMUL TDIV

%start program

%%
call_args : /*blank*/  { $$ = new std::vector<ExprAST*>(); }
          | expr { $$ = new std::vector<ExprAST*>(); $$->push_back($1); }
          | call_args TCOMMA expr  { $1->push_back($3);$$=$1; }
          ;
program : astlist;

astlist : ast {std::cout<<"parse ast\n";}
        | astlist ast{std::cout<<"add ast\n";}

ast : expr  {std::cout<<"ast parse expr\n";}
        | func_decl {std::cout<<"ast parse func_decl\n";}


func_decl : TDEF prototype expr{
    $$ = new FunctionAST($2,$3);
    std::cout<<"Function: "<<std::endl;
}

prototype : TIDENTIFIER TLPAREN func_decl_args TRPAREN{
    $$ = new PrototypeAST(*$1,*$3);
    std::cout<<"Prototype length: "<<dynamic_cast<PrototypeAST *>($$)->Args.size()<<std::endl;
}


func_decl_args : /*blank*/  { $$ = new std::vector<std::string>(); }
           | TIDENTIFIER { $$ = new std::vector<std::string>(); $$->push_back(*$1); }
           | func_decl_args TCOMMA TIDENTIFIER { $1->push_back(*$3);$$=$1; }
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
    // | TIDENTIFIER TLPAREN call_args TRPAREN{
    //     $$ = new CallExprAST(*$1,*$3);
    //     std::cout<<"Call length: "<<dynamic_cast<CallExprAST *>($$)->Args.size()<<std::endl;
    // }
    | expr BINOP expr{
        std::cout<<"binOP: "<<char($2)<<std::endl;
        $$ = new BinaryExprAST(char($2),$1,$3);
    }




