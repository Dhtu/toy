#ifndef AST_h
#define AST_h
#include <iostream>
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
    const std::string &getName() const { return Name; }
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
/// UnaryExprAST - Expression class for a unary operator.
class UnaryExprAST : public ExprAST
{
    char Opcode;
    ExprAST *Operand;

public:
    UnaryExprAST(char Opcode, ExprAST *Operand)
        : Opcode(Opcode), Operand(Operand) {}

    Value *codegen() override;
};
/// VarExprAST - Expression class for var/in
class VarExprAST : public ExprAST
{
public:
    std::vector<std::pair<std::string, ExprAST *>> VarNames;
    ExprAST *Body;

    VarExprAST(std::vector<std::pair<std::string, ExprAST *>> VarNames, ExprAST *Body)
        : VarNames(VarNames), Body(Body) {}

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
    bool IsOperator;
    unsigned Precedence;

    PrototypeAST(const std::string &Name, std::vector<std::string> Args, bool IsOperator = false, unsigned Prec = 0)
        : Name(Name), Args(Args), IsOperator(IsOperator), Precedence(Prec) {}

    Function *codegen();
    const std::string &getName() const { return Name; }

    bool isUnaryOp() const
    {
        return IsOperator && Args.size() == 1;
    }
    bool isBinaryOp() const
    {
        return IsOperator && Args.size() == 2;
    }

    char getOperatorName() const
    {
        assert(isUnaryOp() || isBinaryOp());
        return Name[Name.size() - 1];
    }

    unsigned getBinaryPrecedence() const { return Precedence; }
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
    void Hello();
};

/// IfExprAST - Expression class for if/then/else.
class IfExprAST : public ExprAST
{
public:
    ExprAST *Cond, *Then, *Else;
    IfExprAST(ExprAST *Cond, ExprAST *Then, ExprAST *Else)
        : Cond(Cond), Then(Then), Else(Else) {}

    Value *codegen() override;
};

/// ForExprAST - Expression class for for/in.
class ForExprAST : public ExprAST
{
public:
    std::string VarName;
    ExprAST *Start, *End, *Step, *Body;

    ForExprAST(const std::string &VarName, ExprAST *Start, ExprAST *End, ExprAST *Step, ExprAST *Body) : VarName(VarName), Start(Start), End(End), Body(Body) {}

    Value *codegen() override;
};

std::unique_ptr<ExprAST> LogError(const char *Str);

extern std::map<std::string, PrototypeAST *> FunctionProtos;

#endif
