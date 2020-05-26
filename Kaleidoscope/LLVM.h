#ifndef LLVM
#define LLVM
/*这个是整个项目共用的头文件, 防止大量加载LLVM的库, 但是理论上应该只要加载AST.h就好了, 考虑到后端不需要AST类, 就又抽了一个头文件出来*/

#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Verifier.h"


#endif