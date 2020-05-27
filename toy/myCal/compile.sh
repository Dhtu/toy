#!/bin/bash
bison -d myCal.y
flex myCal.l
cc lex.yy.c myCal.tab.c -lfl -lm