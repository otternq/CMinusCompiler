BIN  = c-
CC   = g++
# CFLAGS = -g

# for use with C++ if file ext is .cc
# CCFLAGS = -DCPLUSPLUS -g
CFLAGS = -DCPLUSPLUS -g
SRCS = $(BIN).y $(BIN).l
OBJS = lex.yy.o $(BIN).tab.o

AUX    = tree.cpp

LIBS = -ll -lm 

$(BIN): $(OBJS)
	$(CC) $(CCFLAGS) $(OBJS) $(LIBS) $(AUX) -o $(BIN)

$(BIN).tab.h $(BIN).tab.c: $(BIN).y
	bison -v -t -d $(BIN).y  

lex.yy.c: $(BIN).l $(BIN).tab.h
	flex $(BIN).l  # -d debug

all:    
	touch $(SRCS)
	make

clean:
	rm -f $(OBJS) lex.yy.c $(BIN).tab.h $(BIN).tab.c c-.output $(BIN).tar calc

tar:
	tar -cvf $(BIN).tar $(SRCS) scanType.h makefile 

teste:
	./c- < ../test/2.c-

testh:
	./c- < ../test/everything02.c-

testh2:
	./c- ../test/everything02.c-