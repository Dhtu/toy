CC = clang++
LFALGS = `llvm-config --cxxflags`
LLIBS = `llvm-config --ldflags --system-libs --libs core`

all: toy reset

%.o:%.cpp
		$(CC) -c -g -O3 $? -o $@

%.tab.c %.tab.h: %.y
		$(YYAC) -d $<

%.c: %.l
		$(LEX) -o $@ $<

toy:toy.o
		$(CC) $? -o  $@  $(LFALGS) $(LLIBS)

toy.o: toy.cpp
		$(CC) -c -g -O3 $? $(LFALGS) -o $@




.PYHONY: clean

clean:
		- rm *.o

.PYHONY: reset

reset: 
		- rm *.o toy