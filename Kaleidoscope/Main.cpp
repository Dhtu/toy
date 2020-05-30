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
    // TheModule->print(errs(), nullptr);

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

#ifdef _WIN32
#define DLLEXPORT __declspec(dllexport)
#else
#define DLLEXPORT
#endif

/// putchard - putchar that takes a double and returns 0.
extern "C" DLLEXPORT double putchard(double X) {
  fputc((char)X, stderr);
  return 0;
}

/// printd - printf that takes a double prints it as "%f\n", returning 0.
extern "C" DLLEXPORT double printd(double X) {
  fprintf(stderr, "%f\n", X);
  return 0;
}