// #include "AstParser.h"
// #include "IrGenerator.h"
#include "AST.h"
#include <stdio.h>
#include <stdarg.h>
#include <math.h>
int yyerror(const char *, ...);
extern int yylex();
extern int yyparse();


int main()
{

    printf("> "); 
    // Make the module, which holds all the code.
    TheModule = new Module("my cool jit", TheContext);
    yyparse();

    // Print out all of the generated code.
    TheModule->print(errs(), nullptr);

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