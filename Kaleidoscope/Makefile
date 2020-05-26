CC = clang++
LFALGS = `llvm-config --cxxflags`
LLIBS = `llvm-config --ldflags --system-libs --libs core`

all: toy

# 所有cpp的默认编译选项
%.o:%.cpp
		$(CC) -c -g -O3 $? -o $@

# bison的默认编译选项, 从somename.y --> somename.tab.c somename.tab.h
%.tab.c %.tab.h: %.y
		$(YYAC) -d $<

# flex的默认编译选项, 从somename.l --> somename.c
%.c: %.l
		$(LEX) -o $@ $<

# 官方例程的链接
toy:toy.o AST.o
		$(CC) $? -o  $@  $(LFALGS) $(LLIBS)


AST.o: AST.cpp
		$(CC) -c -g -O3 $? $(LFALGS) -o $@

toy.o: toy.cpp
		$(CC) -c -g -O3 $? $(LFALGS) -o $@



# 删除目标代码文件
.PYHONY: clean

clean:
		- rm *.o

# 删除目标代码与最终文件
.PYHONY: reset

reset: 
		- rm *.o toy