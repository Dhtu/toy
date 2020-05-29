#ifndef AST_h
#define AST_h
#include <algorithm>
#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <map>
#include <memory>
#include <string>
#include <vector>
#include "LLVM.h"

using namespace llvm;

//===----------------------------------------------------------------------===//
// Abstract Syntax Tree (aka Parse Tree)
//===----------------------------------------------------------------------===//


/// ExprAST - Base class for all expression nodes.
class ExprAST
{
public:
    virtual ~ExprAST() = default;

    virtual Value *codegen() = 0;
};

/// NumberExprAST - Expression class for numeric literals like "1.0".
class NumberExprAST : public ExprAST
{

public:
    double Val;
    NumberExprAST(double Val) : Val(Val) {}
    Value *codegen() override;
};

/// VariableExprAST - Expression class for referencing a variable, like "a".
class VariableExprAST : public ExprAST
{

public:
    std::string Name;
    VariableExprAST(const std::string &Name) : Name(Name) {}
    Value *codegen() override;
};

/// BinaryExprAST - Expression class for a binary operator.
class BinaryExprAST : public ExprAST
{
public:
    char Op;
    ExprAST *LHS, *RHS;

    BinaryExprAST(char Op, ExprAST *LHS,
                  ExprAST *RHS)
        : Op(Op), LHS(LHS), RHS(RHS) {}

    Value *codegen() override;
};

/// CallExprAST - Expression class for function calls.
class CallExprAST : public ExprAST
{

public:
    std::string Callee;
    std::vector<ExprAST *> Args;
    CallExprAST(const std::string &Callee,
                std::vector<ExprAST *> Args)
        : Callee(Callee), Args(Args) {}

    Value *codegen() override;
};

/// PrototypeAST - This class represents the "prototype" for a function,
/// which captures its name, and its argument names (thus implicitly the number
/// of arguments the function takes).
class PrototypeAST
{
public:
    std::string Name;
    std::vector<std::string> Args;
    PrototypeAST(const std::string &Name, std::vector<std::string> Args)
        : Name(Name), Args(Args) {}
    Function *codegen();
    const std::string &getName() const { return Name; }
};

/// FunctionAST - This class represents a function definition itself.
class FunctionAST
{
public:
    PrototypeAST *Proto;
    ExprAST *Body;
    FunctionAST(PrototypeAST *Proto,
                ExprAST *Body)
        : Proto(Proto), Body(Body) {}
    Function *codegen();
};

std::unique_ptr<ExprAST> LogError(const char *Str);

extern LLVMContext TheContext;
extern IRBuilder<> Builder;
extern std::unique_ptr<Module> TheModule;
extern std::map<std::string, Value *> NamedValues;

#endif