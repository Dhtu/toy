%{
    #include "AST.h"
    #include <stdio.h>
    #include <iostream>
    #include <stdlib.h>

    extern int yylex();
    void yyerror(const char *s) { printf("ERROR: %s\n", s); }

    void Log(const std::string Str)
    {
        // std::cout<<Str<<std::endl;
    }


    
%}

/* Represents the many different ways we can access our data */
%union {
    ExprAST *expr;
    PrototypeAST *prototype;
    FunctionAST *function;
    std::string *string;
    std::vector<ExprAST*> *exprvec;
    std::vector<std::string> *strvec;
    std::vector<std::pair<std::string, ExprAST *>> *varvec;
    char yychar;
    int token;
}

/* Define our terminal symbols (tokens). This should
   match our tokens.l lex file. We also define the ExprAST type
   they represent.
 */
%token <string> TIDENTIFIER TINTEGER TDOUBLE
%token <token> TCEQ TCNE TCLT TCLE TCGT TCGE TASSIGN BINOP
%token <token> TLPAREN TRPAREN TLBRACE TRBRACE TCOMMA TDOT
%token <token> TPLUS TMINUS TMUL TDIV
%token <token> TBINARY TUNARY
%token <token> TIF TTHEN TELSE TFOR TIN TVAR
%token <token> TRETURN TEXTERN TDEF TENDLINE

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
%type <varvec> var_decl_args


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

astlist : /*blank*/  {
            std::cout<<"> ";
         }
        | ast TENDLINE{
            Log("Parse ast");
            std::cout<<"> ";
            }
        | ast{
            Log("Parse ast");
            std::cout<<"> ";
            }
        | astlist ast TENDLINE{
            Log("Parse ast");
            std::cout<<"> ";
            }
        | astlist ast{
            Log("Parse ast");
            std::cout<<"> ";
            }

ast : expr{
            Log("Parse Top Level Expr");
            auto prototype = new PrototypeAST("__anon_expr",*(new std::vector<std::string>()));
            auto top = new FunctionAST(prototype,$1);
            if(top!=NULL)
            {
                Log("top!=null");
            }

            if (auto FnAST = top)
            {
                if (auto *FnIR = FnAST->codegen())
                {
                    // JIT the module containing the anonymous expression, keeping a handle so
                    // we can free it later.
                    auto H = TheJIT->addModule(std::move(TheModule));

                    fprintf(stderr, "Read function :");
                    FnIR->print(errs());
                    fprintf(stderr, "\n");

                    InitializeModuleAndPassManager();

                    // Search the JIT for the __anon_expr symbol.
                    auto ExprSymbol = TheJIT->findSymbol("__anon_expr");
                    assert(ExprSymbol && "Function not found");

                    // Get the symbol's address and cast it to the right type (takes no
                    // arguments, returns a double) so we can call it as a native function.
                    double (*FP)() = (double (*)())(intptr_t)cantFail(ExprSymbol.getAddress());
                    fprintf(stderr, "Evaluated to %f\n", FP());

                    

                    // Delete the anonymous expression module from the JIT.
                    TheJIT->removeModule(H);
                }
            }
        }
    | func_decl
        {
            Log("Parsed a function definition.");
            if (auto *FnIR = $1->codegen())
            {
                fprintf(stderr, "Read function :");
                FnIR->print(errs());
                fprintf(stderr, "\n");
                TheJIT->addModule(std::move(TheModule));
                InitializeModuleAndPassManager();
            }
        }
    | TEXTERN prototype
        {
            Log("Parsed a function extern declaration.");
            if (auto *FnIR = $2->codegen())
            {
                fprintf(stderr, "Read : ");
                FnIR->print(errs());
                fprintf(stderr, "\n");
                FunctionProtos[$2->getName()] = $2;
            }
        }
    



func_decl : TDEF prototype expr{
    $$ = new FunctionAST($2,$3);
    // std::cout<<"Function: "<<std::endl;
}

prototype : TIDENTIFIER TLPAREN func_decl_args TRPAREN{
            $$ = new PrototypeAST(*$1,*$3);
            // std::cout<<"Prototype length: "<<dynamic_cast<PrototypeAST *>($$)->Args.size()<<std::endl;
        }
        | TBINARY BINOP TDOUBLE TLPAREN func_decl_args TRPAREN{
            std::string FnName = "binary";
            FnName += (char)$2; 
            $$ = new PrototypeAST(FnName,*$5,true, atoi($3->c_str())); 
            
            Log(FnName);
            // std::cout<<"Prototype length: "<<dynamic_cast<PrototypeAST *>($$)->Args.size()<<std::endl;
            }

func_decl_args : /*blank*/  { $$ = new std::vector<std::string>(); }
           | TIDENTIFIER { $$ = new std::vector<std::string>(); $$->push_back(*$1); }
           | func_decl_args TCOMMA TIDENTIFIER { $1->push_back(*$3);$$=$1; }
           ;

expr : TDOUBLE { 
        auto Result = new NumberExprAST(atof($1->c_str())); 
        delete $1;
        // std::cout<<"Parse double: "<<((*Result).Val)<<std::endl;
        Log("Parse double");
        $$ = Result;
    }
    | TLPAREN expr TRPAREN {
        auto Result = $2;
        // std::cout<<"Parse (expr)"<<std::endl;
        Log("Parse (expr)");
        $$ = Result;
    }
    | TIDENTIFIER {
        auto Result = new VariableExprAST(*$1); 
        delete $1;
        // std::cout<<"Parse Variable: "<<((*Result).Name)<<std::endl;
        Log("Parse Variable : "+((*Result).Name));
        $$ = Result;
    }
    | TIDENTIFIER TLPAREN call_args TRPAREN{
        $$ = new CallExprAST(*$1,*$3);
        // std::cout<<"Call length: "<<dynamic_cast<CallExprAST *>($$)->Args.size()<<std::endl;
        Log("Parse Call");
    }
    | expr BINOP expr{
        // std::cout<<"BinOP: "<<char($2)<<std::endl;
        $$ = new BinaryExprAST(char($2),$1,$3);
        Log("Parse BinOP");
    }
    | expr TASSIGN expr{
        // std::cout<<"Assign: "<< char($2)<<std::endl;
        Log("Parse Assign");
        $$ = new BinaryExprAST(char($2),$1,$3);
    }
    | TIF expr TTHEN expr TELSE expr 
    {
        Log("ast parse if_decl\n");
        $$ = new IfExprAST($2, $4, $6);
    }
    | TFOR TIDENTIFIER TASSIGN expr TCOMMA expr TCOMMA expr TIN expr
    {
        Log("ast parse for_decl\n");
        $$ = new ForExprAST(*$2, $4, $6, $8, $10);
    }
    | TVAR var_decl_args TIN expr{
        $$ = new VarExprAST(*$2, $4);
        Log("Var");
    } ;  

    
var_decl_args : /*blank*/ { $$ = new std::vector<std::pair<std::string, ExprAST *>>();}
              | TIDENTIFIER TASSIGN expr{
          $$ = new std::vector<std::pair<std::string, ExprAST *>>;
              $$->push_back(std::pair<std::string, ExprAST *>(*$1, $3));
              }
              |var_decl_args TCOMMA TIDENTIFIER TASSIGN expr{
              $1->push_back(std::pair<std::string, ExprAST *>(*$3, $5));
              $$ = $1;
              };