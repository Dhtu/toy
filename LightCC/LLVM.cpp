#include "LLVM.h"

LLVMContext TheContext;
IRBuilder<> Builder(TheContext);
std::unique_ptr<Module> TheModule;
std::map<std::string, AllocaInst *> NamedValues;
std::unique_ptr<legacy::FunctionPassManager> TheFPM;

/// CreateEntryBlockAlloca - Create an alloca instruction in the entry block of
/// the function.  This is used for mutable variables etc.
AllocaInst *CreateEntryBlockAlloca(Function *TheFunction,
                                          const std::string &VarName)
{
  IRBuilder<> TmpB(&TheFunction->getEntryBlock(),
                   TheFunction->getEntryBlock().begin());
  return TmpB.CreateAlloca(Type::getDoubleTy(TheContext), 0,
                           VarName.c_str());
}


//===----------------------------------------------------------------------===//
// Top-Level parsing and JIT Driver
//===----------------------------------------------------------------------===//
void InitializeModuleAndPassManager() {
  // Open a new module.
  TheModule = llvm::make_unique<Module>("my cool jit", TheContext);
}