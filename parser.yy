%{
#include <iostream>
#include <vector>
#include <utility>
#include "utils.hh"
#include "geo_objects.hh"

extern int yylex();
extern std::vector<vertice*> vertices;
extern std::vector<face> faces;
extern int nbGroup ;
extern int nbObject;
extern std::vector<std::pair<int,int>> redundant;
extern std::vector<serializable*> objects;

// on se sert de ses variables globale pour éviter de remonter 
// les vertices dans l'arbre
std::vector<vertice*> curr;
std::vector<std::string> currStr;

// ajoute une nouvelle face
void addFace(bool special){        
    vertice** v_arr = new vertice*[curr.size()];
    for (int i = 0; i < curr.size(); i++)
        v_arr[i] = curr[i];
    
    face* f;
    if (special)
        f = new special_face(v_arr, curr.size(),currStr);
    else
        f = new face(v_arr, curr.size());        
    faces.push_back(*f);

    currStr.clear();
    curr.clear();  
    objects.push_back(f);
}


vertice* getVerticeFromIndex(int index){
    if (index > vertices.size())
    {
        yyerror("vertice not defined yet");
        return nullptr;
    } else {
        auto tmp =  vertices[index];
        return tmp;
    }
}


// ajoute le vertice en checkant s'il existe déjà
void check_add_redundant(double a, double b, double c){
    vertice* v = new vertice(a,b,c,vertices.size()+1);
    for (int i = 0; i < vertices.size(); i++){
        if ((*(vertices[i])) == (*v)) {
            std::cout << "VERTEX " << (i+1) << " = VERTEX " <<  (vertices.size() + 1) << std::endl;
            redundant.push_back(std::make_pair(i+1, (vertices.size() + 1)));
            break;
        }           
    }
    objects.push_back(v);
    vertices.push_back(v);  
}


%}

// ================= //


%code requires {
    // utilie pour les éviter l'erreur "memory exausted"
    // sur les gros fichiers
    #define YYINITDEPTH 400 
    #define YYMAXDEPTH  1000000

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
%token USE_MAT "material usage instruction";
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

obj : OBJECT ID{++nbObject; objects.push_back(new obj_other("o " + std::string($2)));};
|OBJECT FILE_STR{++nbObject; objects.push_back(new obj_other("o " + std::string($2)));};

group : GROUP ID{++nbGroup; objects.push_back(new obj_other("g " + std::string($2)));};

face : triangle | triangle_texture | triangle_normal | triangle_texture_normale;

vertex : VERTEX number number number { check_add_redundant($2 , $3 , $4 );};

normale : NORM number number number { objects.push_back(new obj_other("vn " + std::to_string($2) + " " + std::to_string($3) + " " + std::to_string($4) )); };

texture: TEXTURE number number {objects.push_back(new obj_other("vt " + std::to_string($2) + " " + std::to_string($3) ));};

bibli : MAT_LIB FILE_STR {objects.push_back(new obj_other("mtllib " + std::string($2)));};

use_mat : USE_MAT ID {objects.push_back(new obj_other("usemtl " + std::string($2)));};;

lissage : LISSAGE INTEGER {objects.push_back(new obj_other("s " + $2));}
| LISSAGE OFF {objects.push_back(new obj_other("s off"));};

number : FLOAT {$$ = $1;}| INTEGER {$$ = 0.0 + $1;}

triangle : FACE INTEGER INTEGER list_coord {
    curr.insert(curr.begin(),(getVerticeFromIndex($2 -1)));
    curr.insert(curr.begin(),(getVerticeFromIndex($3 -1)));
    addFace(false);
};

list_coord : INTEGER {curr.push_back(getVerticeFromIndex($1 - 1));}
| INTEGER list_coord {curr.push_back(getVerticeFromIndex($1 - 1));};


triangle_texture : FACE  face_texture face_texture list_face_texture{
    curr.insert(curr.begin(), $2);
    curr.insert(curr.begin() + 1, $3);
    addFace(true);
};

list_face_texture : face_texture  {curr.push_back($1);}
| face_texture list_face_texture  {curr.push_back($1);};

face_texture : INTEGER SLASH INTEGER {$$ = getVerticeFromIndex($1 - 1); currStr.push_back("/" + std::to_string($3));};


triangle_normal : FACE   face_normal face_normal list_face_normal{
    curr.insert(curr.begin(), $2);
    curr.insert(curr.begin() + 1, $3);
    addFace(true);
};

list_face_normal : face_normal {curr.push_back($1);}
| face_normal list_face_normal {curr.push_back($1);};

face_normal : INTEGER SLASH SLASH INTEGER {$$ = getVerticeFromIndex($1 - 1); currStr.push_back("//" + std::to_string($4));};



triangle_texture_normale : FACE face_normal_texture face_normal_texture list_face_normal_texture{
    curr.insert(curr.begin(), $2);
    curr.insert(curr.begin() + 1, $3);
    addFace(true);
};

list_face_normal_texture : face_normal_texture {curr.push_back($1);};
| face_normal_texture list_face_normal_texture {curr.push_back($1);};

face_normal_texture :  INTEGER SLASH INTEGER SLASH INTEGER {$$ = getVerticeFromIndex($1 - 1); currStr.push_back("/" + std::to_string($3) + "/" + std::to_string($5));};

%%


