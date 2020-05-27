#ifndef AstParser
#define AstParser
//这个库作为Parser的驱动, 下面提供两个方法
#include "AST.h"

//关于参数接口的两个想法, 一个是为所有的AST创建一个基类, 然后用Vector<AST>作为参数传递
//Vector<AST> getAST();
//另一个想法是把同一文件的函数定义与声明创建到一个根节点的AST下, 假设这个根节点叫Module
//ModuleAST getAST();

//然后是一个AST绘制方法的接口
//void DrawAST();

#endif