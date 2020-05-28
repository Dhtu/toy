// #include "AstParser.h"
// #include "IrGenerator.h"

#include <stdio.h>
#include <stdarg.h>
#include <math.h>
int yyerror(const char *, ...);
extern int yylex();
extern int yyparse();


int main()
{
    //Parser入口

    //IR generator入口

    //object code生成入口

    printf("> "); 
    yyparse();

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