#include <iostream>
#include <vector>
//#include <llvm/value.h>

class CodeGenContext;
class StmtAST;
class ExpressionAST;
class VarDeclAST;

typedef std::vector<StmtAST*> StatementList;
typedef std::vector<ExpressionAST*> ExpressionList;
typedef std::vector<VarDeclAST*> VariableList;

/// ExprAST - Base class for all expression nodes.
class ExprAST
{
public:
    virtual ~ExprAST() {};

//    virtual llvm::Val* codeGen(CodeGenContext& context) { }
};

/// expression class
class ExpressionAST : public ExprAST {};

/// statement class
class StmtAST : public ExprAST {};

/// IntExprAST - Expression class for numeric int literals like 1
class IntExprAST : public ExpressionAST
{
public:
	long long Val;

    IntExprAST(long long Val) : Val(Val) { }

//    virtual llvm::value* codeGen(CodeGenContext& context);
};

/// DoubleExprAST - Expression class for numeric double literals like "1.0"
class DoubleExprAST : public ExpressionAST 
{	
public:
	double Val; 

    DoubleExprAST(double Val) : Val(Val) { }

//    virtual llvm::Val* codeGen(CodeGenContext& context);
};

/// VariableExprAST - Expression class for referencing a variable, like "a".
class VariableExprAST : public ExpressionAST 
{
public:
	std::string Name;

    VariableExprAST(const std::string& Name) : Name(Name) { }

  //  virtual llvm::Val* codeGen(CodeGenContext& context);
};

/// BinaryExprAST - Expression class for a binary operator.
class BinaryExprAST : public ExpressionAST 
{
public:
	int op;
    ExpressionAST& lhs;
    ExpressionAST& rhs;

    BinaryExprAST(ExpressionAST& lhs, int op, ExpressionAST& rhs) :
        lhs(lhs), rhs(rhs), op(op) { }

//    virtual llvm::Val* codeGen(CodeGenContext& context);
};

/// CallExprAST - Expression class for function calls.
class CallExprAST : public ExpressionAST 
{
public:
    const VariableExprAST& id;
    ExpressionList arguments;
    CallExprAST(const VariableExprAST& id, ExpressionList& arguments) :
        id(id), arguments(arguments) { }
    CallExprAST(const VariableExprAST& id) : id(id) { }

  //  virtual llvm::Val* codeGen(CodeGenContext& context);
};

class AssignAST : public ExpressionAST 
{
public:
    VariableExprAST& lhs;
    ExpressionAST& rhs;

    AssignAST(VariableExprAST& lhs, ExpressionAST& rhs) : 
        lhs(lhs), rhs(rhs) { }
    //virtual llvm::Val* codeGen(CodeGenContext& context);
};

/// BlockAST - Expression class for function block.
class BlockAST : public ExpressionAST 
{
public:
    StatementList statements;

    BlockAST() { }

//    virtual llvm::Val* codeGen(CodeGenContext& context);
};

class ExprStmtAST : public StmtAST 
{
public:
	ExpressionAST& expression;
    ExprStmtAST(ExpressionAST& expression) : 
        expression(expression) { }

  //  virtual llvm::Val* codeGen(CodeGenContext& context);
};

/// ReturnAST - statement class for return.
class ReturnAST : public StmtAST
{
public:
	ExpressionAST& expression;

	ReturnAST(ExpressionAST& expression) : 
		expression(expression) { }

	//virtual llvm::Value* codeGen(CodeGenContext& context);
};

class ExternAST : public StmtAST
{
public:
    const VariableExprAST& type;
    const VariableExprAST& id;
    VariableList arguments;

    ExternAST(const VariableExprAST& type, const VariableExprAST& id,
            const VariableList& arguments) :
        type(type), id(id), arguments(arguments) {}

//    virtual llvm::Value* codeGen(CodeGenContext& context);
};

/// IfExprAST - Statement class for if/then/else.
class IfStmtAST : public StmtAST {
public:
    ExpressionAST& Cond;
    ExpressionAST& Then;
    ExpressionAST& Else;

    IfStmtAST(ExpressionAST& Cond, ExpressionAST& Then,
            ExpressionAST& Else)
    : Cond(Cond), Then(Then), Else(Else) {}
	//virtual llvm::Value* codeGen(CodeGenContext& context);
};

/// ForExprAST - Statement class for for/in
//class ForStmtAST : public StmtAST {
//public:
//    const VariableExprAST& VarName;
//    ExpressionAST& Start;
//    ExpressionAST& End;
///    ExpressionAST& Step;
//    ExpressionAST& Body;

//    ForStmtAST(const VariableExprAST& VarName, ExpressionAST& Start, ExpressionAST& End, Expression& Step, Expression& Body) :
//    VarName(VarName), Start(Start), End(End), Step(Step), Body(Body) { }

//    virtual llvm::Value* codeGen(CodeGenContext& context);
//};

/// VarDeclAST - Statement class for variable declaration.
class VarDeclAST : public StmtAST 
{
public:
    const VariableExprAST& type;
    VariableExprAST& id;
    ExpressionAST *assignmentExpr;

    VarDeclAST(const VariableExprAST& type, VariableExprAST& id) :
        type(type), id(id) { }
    VarDeclAST(const VariableExprAST& type, VariableExprAST& id, ExpressionAST *assignmentExpr) :
        type(type), id(id), assignmentExpr(assignmentExpr) { }

//    virtual llvm::Val* codeGen(CodeGenContext& context);
};

/// FunctionAST - This class represents a function definition itself.
class FunctionAST : public StmtAST 
{
public:
    const VariableExprAST& type;
    const VariableExprAST& id;
    VariableList arguments;
    BlockAST& block;

    FunctionAST(const VariableExprAST& type, const VariableExprAST& id, 
            const VariableList& arguments, BlockAST& block) :
        type(type), id(id), arguments(arguments), block(block) { }

//    virtual llvm::Val* codeGen(CodeGenContext& context);
};
