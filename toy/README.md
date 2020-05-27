# 编译原理大作业

## myCal
这是我前几次的作业...为了测试flex&bison才加进来的, 没什么用

## Kaleidoscope
这是llvm官方的例程, 我把它拆分了一下.
### lexer.l
使用lex -o lexer.cpp lexer.l进行编译
### parser.y
使用bison -d -o parser.cpp parser.y进行编译
初步实现函数调用
### AST
把AST独立出来了, AST.cpp里写IR generation的实现方法
添加了几个类，调整了一些依赖关系
### Main
Main.cpp是我们最终程序的入口, 现在啥都没有
### LLVM.h
把LLVM的库拉了出来, 方便之后我写后端的时候调用
### toy.cpp
官方例程
### AstParser.h
Parser的接口, Main会调用里面的接口
### IrGenerator.h
IR生成功能的接口, Main会调用里面的接口
### Makefile
自动化编译的配置文件, 如果你的环境正常的话, 输入make命令会自动编译官方例程
### toy
官方例程的可执行文件
