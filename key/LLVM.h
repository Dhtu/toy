#ifndef LLVM
#define LLVM
/*这个是整个项目共用的头文件, 防止大量加载LLVM的库, 但是理论上应该只要加载AST.h就好了, 考虑到后端不需要AST类, 就又抽了一个头文件出来*/
#include "../include/KaleidoscopeJIT.h"
#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Transforms/InstCombine/InstCombine.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Transforms/Scalar/GVN.h"
#include <memory>

using namespace llvm;

extern LLVMContext TheContext;
extern IRBuilder<> Builder;
extern std::unique_ptr<Module> TheModule;
extern std::map<std::string, Value *> NamedValues;
extern std::unique_ptr<legacy::FunctionPassManager> TheFPM;
extern std::unique_ptr<orc::KaleidoscopeJIT> TheJIT;

void InitializeModuleAndPassManager(void);

#endif