%{
#include "utils.hh"
extern int yylex();
%}

// ================= //

%token VAR ID PV STOCK INTEGER EQUALCOMP MINCOMP MAXCOMP IF OPENPAR CLOSEPAR OPENBLOCK CLOSEBLOCK ELSE WHILE PLUS MINUS MULTI DIVIDE;

%start root

%%

root: main {printf("\nROOT");}
;

main:  instr main |
;

instr : decl {printf("\ninstr");} 
| affect {printf("\ninstr ");}
| if {printf("\ninstr");} 
| while {printf("\ninstr");}
;

subBlock: block | instr
;

block: OPENBLOCK main CLOSEBLOCK {printf("\nblock");}
| OPENBLOCK CLOSEBLOCK {printf("\nempty block ");}
;

expr: ID { printf("\nEXPR : ID") ; }
|INTEGER {printf("\nEXPR : INT") ; }
;

decl: VAR ID PV {printf("\ndecl ");}
;

rvalue: expr | operation {printf("operation");}
;

affect: VAR ID STOCK rvalue PV { printf("\naffect ");}
| ID STOCK rvalue PV { printf("\naffect 2");}
;

if: IF subTest subBlock {printf("\nif");}
| IF subTest subBlock ELSE subBlock{printf("\nif else");}
;

while  : WHILE subTest subBlock {printf("\nwhile");}


subTest : OPENPAR comp CLOSEPAR
;

operation : expr binOperator expr {printf("\nOperation");}
;

comp:  expr comparator expr {printf("\nComparaison ");}
;

comparator: EQUALCOMP {printf("\n== ");} | MINCOMP {printf("\n < ");} | MAXCOMP { printf("\n > ");} 
;

binOperator : MINUS | PLUS | DIVIDE | MULTI {printf("binary operaator");}
;


%%


