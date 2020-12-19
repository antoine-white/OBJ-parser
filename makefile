CFLAGS=
LDFLAGS=-ll

SOURCES=lex.yy.c parser.tab.cc main.c 
TMP=$(SOURCES:.c=.o)
OBJS=$(TMP:.cc=.o)


but: obj_parser.exe

main.o: main.cc parser.tab.cc lex.yy.c utils.cc
	$(CXX) $(CFLAGS) -c $<

lex.yy.o: lex.yy.c
	$(CXX) $(CFLAGS) -c $<


obj_parser.exe: $(OBJS)
	$(CXX) $(CFLAGS) -o $@ $^ $(LDFLAGS)

lex.yy.c: lexer.ll parser.tab.cc
	flex $<

parser.tab.cc: parser.yy lexer.ll
	bison -d $<

clean:
	rm -fr $(OBJS) parser.tab.* lex.yy.c obj_parser.exe
