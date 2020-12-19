#include <iostream>
#include <stdio.h>
#include <vector>

#include "geo_objects.hh"
#include "parser.tab.hh"
#include "utils.hh"

using namespace std;


std::vector<vertice*> vertices;
std::vector<face> faces;
int nbGroup = 0;
int nbObject = 0;

extern int yylineno;

void yyerror(const char*msg){
    printf("Error line %d :\n %s\n",yylineno ,msg);
}

int main(){
    int res = 0;
    res = yyparse();

    
    int minSize = 0;
    int maxSize = 0;
    if(faces.size()){
        minSize = faces[0].size();
        maxSize = faces[0].size();
        for (int i = 1; i < faces.size(); i++){
            if (faces[i].size() > maxSize)
                maxSize = faces[i].size();
            else if (faces[i].size() < minSize)
                minSize = faces[i].size();
        }
    }
    

    cout << (res == 0 ? "0 erreur" : "Problème") << endl;
    cout << "Size vertices: " << vertices.size() << endl;
    cout << "Size faces: " << faces.size() << endl;
    cout << "Face arity min: " << minSize << endl;
    cout << "Face arity max: " << maxSize << endl;
    cout << "size objects: " << nbGroup << endl;
    cout << "size groups: " << nbObject << endl;
    
    
    return EXIT_SUCCESS;
}