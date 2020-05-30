#include "LLVM.h"

LLVMContext TheContext;
IRBuilder<> Builder(TheContext);
std::unique_ptr<Module> TheModule;
std::map<std::string, Value *> NamedValues;
std::unique_ptr<legacy::FunctionPassManager> TheFPM;


void InitializeModuleAndPassManager() {
  // Open a new module.
  TheModule = llvm::make_unique<Module>("my cool jit", TheContext);
}