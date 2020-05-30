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
    InitializeNativeTarget();
    InitializeNativeTargetAsmPrinter();
    InitializeNativeTargetAsmParser();
    printf("> ");
    // TheJIT = std::make_unique<orc::KaleidoscopeJIT>();
    TheJIT = llvm::make_unique<orc::KaleidoscopeJIT>();
    // Make the module, which holds all the code.
    InitializeModuleAndPassManager();
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