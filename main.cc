#include <iostream>
#include <stdio.h>

#include "parser.tab.hh"
#include "utils.hh"

using namespace std;


extern int yylineno;

void yyerror(const char*msg){
    printf("Error line %d :\n %s\n",yylineno ,msg);
}

int main(){
    int res = 0;
    res = yyparse();
    cout << (res == 0 ? "0 erreur" : "Problème") << endl;
    return EXIT_SUCCESS;
}