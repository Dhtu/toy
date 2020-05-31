CC = clang++ #这里的编译器用的是clang, 如果要换成gcc的话, 可能要把10行的-O3去掉
LFALGS = `llvm-config --cxxflags`
LLIBS = `llvm-config --ldflags --system-libs --libs core mcjit native`

all: LightJIT


%.o:%.cpp
		$(CC) -c -g -O3 $? $(LFALGS) -o $@


parser.tab.cpp parser.tab.h: parser.y
		bison -d parser.y
		mv parser.tab.c parser.tab.cpp

# flex的默认编译选项, 从somename.l --> somename.c
%.cpp: %.l
		$(LEX) -o $@ $<



# Main
LightJIT:Main.o parser.tab.cpp lexer.o AST.o LLVM.o
		$(CC) Main.o parser.tab.cpp lexer.o AST.o LLVM.o -o  $@  $(LFALGS) $(LLIBS)


# 删除目标代码文件
.PYHONY: clean

clean:
		- rm *.o *.tab.c *.tab.cpp *.tab.h

# 删除目标代码与最终文件
.PYHONY: reset

reset: 
		- rm Main