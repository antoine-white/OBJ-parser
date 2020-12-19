%{ 
  #include "parser.tab.hh"
%} 

%option yylineno

%% 


usemtl {return USE_MAT;}

mtllib {return MAT_LIB;}

"/" { return SLASH;}

"\n"  {}

"#".* {}

f {return FACE;}

vt {return TEXTURE;}

off {return OFF;}

s {return LISSAGE;}

v  {return VERTEX;}

n  {return NORM;}

[-+]?[0-9]* { yylval.ivalue = atoi(yytext); return INTEGER;}

[a-zA-Z_][a-zA-Z0-9_]* {strcpy(yylval.ident,yytext); return ID;}

[a-zA-Z_][a-zA-Z0-9_]*[.][a-zA-Z]+ { strcpy(yylval.ident,yytext); return FILE_STR;}

[-+]?[0-9]*([.][0-9]+)?([eE][+-]?[0-9]+)?	{ yylval.value = atof(yytext); return FLOAT; }

. {}
%% 
