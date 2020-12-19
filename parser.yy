%{
#include <iostream>
#include <vector>
#include "utils.hh"
#include "geo_objects.hh"
extern int yylex();
extern std::vector<vertice*> vertices;
extern std::vector<face> faces;
extern int nbGroup ;
extern int nbObject;


std::vector<vertice*> curr;
void addFace(){        
    vertice** v_arr = new vertice*[curr.size()];
    for (int i = 0; i < curr.size(); i++)
        v_arr[i] = curr[i];
    face f(v_arr, curr.size());
    faces.push_back(f);
    curr.clear();
}
vertice* getVerticeFromIndex(int index){
    if (index > vertices.size() + 1 )
    {
        yyerror("vertice not defined yet");
        return nullptr;
    } else {
        return vertices[index];
    }
}

%}

// ================= //


%code requires {
    /* Fais un copier coller dans le fichier parser.tab.cc */
    //#include <vector>
    class vertice;
}

%locations

%define parse.error verbose

%union {
	char ident[255];
	double value;
    int ivalue;
    vertice* vert;
}

%token VERTEX "vertex declaration";
%token TEXTURE "texture declaration";
%token NORM "normal declaration";
%token SLASH "/";
%token OFF "off";
%token USE_MAT "material usage declaration";
%token LISSAGE "lissage";
%token MAT_LIB "material library loading instruction";
%token FACE "face declaration";
%token OBJECT "object declaration";
%token GROUP "group declaration";

%token<ivalue> INTEGER "integer";
%token<value> FLOAT "float";
%token<ident> FILE_STR "file path";
%token<ident> ID "identifiant";


%type<value> number
%type<vert> face_normal
%type<vert> face_texture
%type<vert> face_normal_texture
%start root

%%

root : instr root|

instr: vertex | normale | texture | bibli | use_mat | lissage| face | obj | group;

obj : OBJECT ID{++nbObject;};

group : GROUP ID{++nbGroup;};

face : triangle | triangle_texture | triangle_normal | triangle_texture_normale;

vertex : VERTEX number number number { vertices.push_back(new vertice($2 , $3 , $4 ));};

normale : NORM number number number;

texture: TEXTURE number number;

bibli : MAT_LIB FILE_STR;

use_mat : USE_MAT ID;

lissage : LISSAGE INTEGER| LISSAGE OFF;

number : FLOAT {$$ = $1;}| INTEGER {$$ = 0.0 + $1;}

// if you want to use the faces later you'll have to
// fix the order of the vertice in the face

triangle : FACE INTEGER INTEGER list_coord {
    curr.push_back(getVerticeFromIndex($2 + 1));
    curr.push_back(getVerticeFromIndex($3 + 1));
    addFace();
};

list_coord : INTEGER {curr.push_back(getVerticeFromIndex($1 + 1));}
| INTEGER list_coord {curr.push_back(getVerticeFromIndex($1 + 1));};


triangle_texture : FACE  face_texture face_texture list_face_texture{
    curr.push_back($2);
    curr.push_back($3);
    addFace();
};

list_face_texture : face_texture  {curr.push_back($1);}
| face_texture list_face_texture  {curr.push_back($1);};

face_texture : INTEGER SLASH INTEGER {$$ = getVerticeFromIndex($1 + 1);};


triangle_normal : FACE   face_normal face_normal list_face_normal{
    curr.push_back($2);
    curr.push_back($3);
    addFace();
};

list_face_normal : face_normal {curr.push_back($1);}
| face_normal list_face_normal {curr.push_back($1);};

face_normal : INTEGER SLASH SLASH INTEGER {$$ = getVerticeFromIndex($1 + 1);};



triangle_texture_normale : FACE face_normal_texture face_normal_texture list_face_normal_texture{
    curr.push_back($2);
    curr.push_back($3);
    addFace();
};

list_face_normal_texture : face_normal_texture {curr.push_back($1);};
| face_normal_texture list_face_normal_texture {curr.push_back($1);};

face_normal_texture :  INTEGER SLASH INTEGER SLASH INTEGER {$$ = getVerticeFromIndex($1 + 1);};

%%


