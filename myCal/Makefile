LEX = flex
YYAC = bison
CC = gcc

# all: myCal clean

myCal: myCal.c myCal.tab.c
		$(CC) -o ./bin/$@ $? -lfl -lm

%.tab.c %.tab.h: %.y
		$(YYAC) -d $<

%.c: %.l
		$(LEX) -o $@ $<

.PYHONY: clean

clean:
		- rm *.c *.h