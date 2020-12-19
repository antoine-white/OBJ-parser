#include <iostream>
#include <stdio.h>

#include "parser.tab.hh"
#include "utils.hh"

using namespace std;

void yyerror(const char*msg){
    printf("Error : %s",msg);
}

int main(){
    int res = 0;
    res = yyparse();
    cout << res << endl;
    return EXIT_SUCCESS;
}