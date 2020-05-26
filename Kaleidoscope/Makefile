CC = clang++ #这里的编译器用的是clang, 如果要换成gcc的话, 可能要把10行的-O3去掉
LFALGS = `llvm-config --cxxflags`
LLIBS = `llvm-config --ldflags --system-libs --libs core`

all: reset toy clean

# 所有cpp的默认编译选项, 默认加了LLVM的库的链接, 因为我想不到我们有什么文件是不要链接LLVM的库的
# 前端也需要AST类, 而AST类里有code generator, 所以也是绕不开LLVM的
%.o:%.cpp
		$(CC) -c -g -O3 $? $(LFALGS) -o $@

# bison的默认编译选项, 从somename.y --> somename.tab.c somename.tab.h
%.tab.c %.tab.h: %.y
		$(YYAC) -d $<

# flex的默认编译选项, 从somename.l --> somename.c
%.c: %.l
		$(LEX) -o $@ $<

# 官方例程的链接
toy:toy.o AST.o
		$(CC) $? -o  $@  $(LFALGS) $(LLIBS)


# AST.o: AST.cpp
# 		$(CC) -c -g -O3 $? $(LFALGS) -o $@

# toy.o: toy.cpp
# 		$(CC) -c -g -O3 $? $(LFALGS) -o $@



# 删除目标代码文件
.PYHONY: clean

clean:
		- rm *.o

# 删除目标代码与最终文件
.PYHONY: reset

reset: 
		- rm toy