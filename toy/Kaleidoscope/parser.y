%{
    #include "ast.h"
    #include <iostream>
    #include <stdio.h>
    #include <stdlib.h>
    BlockAST *programBlock; /* the top level root ExprAST of our final AST */

    extern int yylex();
    void yyerror(const char *s) { printf("ERROR: %s\n", s); }
%}

/* Represents the many different ways we can access our data */
%union {
    ExprAST *node;
    BlockAST *block;
    ExpressionAST *expr;
    StmtAST *stmt;
    VariableExprAST *ident;
    VarDeclAST *var_decl;
    std::vector<VarDeclAST*> *varvec;
    std::vector<ExpressionAST*> *exprvec;
    std::string *string;
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
%type <ident> ident
%type <expr> numeric expr 
%type <varvec> func_decl_args
%type <exprvec> call_args
%type <block> program stmts block
%type <stmt> stmt var_decl func_decl extern_decl if_decl
%type <token> comparison

/* Operator precedence for mathematical operators */
%left TPLUS TMINUS
%left TMUL TDIV

%start program

%%




program : stmts { programBlock = $1; }
        ;
        
stmts : stmt { $$ = new BlockAST(); $$->statements.push_back($<stmt>1); }
      | stmts stmt { $1->statements.push_back($<stmt>2); }
      ;

stmt : var_decl 
     | func_decl 
     | extern_decl
     | expr { $$ = new ExprStmtAST(*$1); }
     | TRETURN expr { $$ = new ReturnAST(*$2); }
     | if_decl
     ;

block : TLBRACE stmts TRBRACE { $$ = $2; }
      | TLBRACE TRBRACE { $$ = new BlockAST(); }
      ;

var_decl : ident ident { $$ = new VarDeclAST(*$1, *$2); }
         | ident ident TEQUAL expr { $$ = new VarDeclAST(*$1, *$2, $4); }
         ;
        
func_decl : ident ident TLPAREN func_decl_args TRPAREN block 
            { $$ = new FunctionAST(*$1, *$2, *$4, *$6); delete $4; }
          ;
    
extern_decl : 
            TEXTERN ident ident TLPAREN func_decl_args TRPAREN { $$ = new ExternAST(*$2, *$3, *$5); delete $5; }
	    ;

if_decl :
        TIF expr TTHEN expr TELSE expr { $$ = new IfStmtAST(*$2, *$4, *$6);}
	;

func_decl_args : /*blank*/  { $$ = new VariableList(); }
          | var_decl { $$ = new VariableList(); $$->push_back($<var_decl>1); }
          | func_decl_args TCOMMA var_decl { $1->push_back($<var_decl>3); }
          ;

ident : TIDENTIFIER { $$ = new VariableExprAST(*$1); delete $1; }
      ;

numeric : TINTEGER { $$ = new IntExprAST(atol($1->c_str())); delete $1; }
        | TDOUBLE { $$ = new DoubleExprAST(atof($1->c_str())); delete $1; }
        ;
    
expr : ident TEQUAL expr { $$ = new AssignAST(*$<ident>1, *$3); }
     | ident TLPAREN call_args TRPAREN { $$ = new CallExprAST(*$1, *$3); delete $3; }
     | ident { $<ident>$ = $1; }
     | numeric
     | expr comparison expr { $$ = new BinaryExprAST(*$1, $2, *$3); }
     | TLPAREN expr TRPAREN { $$ = $2; }
     ;
    
call_args : /*blank*/  { $$ = new ExpressionList(); }
          | expr { $$ = new ExpressionList(); $$->push_back($1); }
          | call_args TCOMMA expr  { $1->push_back($3); }
          ;

comparison : TCEQ | TCNE | TCLT | TCLE | TCGT | TCGE 
           | TPLUS | TMINUS | TMUL | TDIV
           ;

%%
