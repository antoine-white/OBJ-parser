%{
#include <iostream>
#include "utils.hh"
extern int yylex();
%}

// ================= //

%locations

%define parse.error verbose

%union {
	char ident[255];
	double value;
    int ivalue;
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

%token<ivalue> INTEGER "integer";
%token<value> FLOAT "float";
%token<ident> FILE_STR "file path";
%token<ident> ID "identifiant";

%start root

%%

root : instr root|

instr: vertex | normale | texture | bibli | use_mat | lissage| face;

face : triangle | triangle_texture | triangle_normal | triangle_texture_normale;

vertex : VERTEX number number number;

normale : NORM number number number;

texture: TEXTURE number number;

bibli : MAT_LIB FILE_STR;

use_mat : USE_MAT ID;

lissage : LISSAGE INTEGER| LISSAGE OFF;

number : FLOAT | INTEGER

triangle : FACE number number number;

triangle_texture : FACE  face_texture face_texture face_texture;

face_texture : number SLASH number ;

triangle_normal : FACE   face_normal face_normal face_normal;

face_normal : number SLASH SLASH number;

triangle_texture_normale : FACE face_normal_texture face_normal_texture face_normal_texture

face_normal_texture :  number SLASH number SLASH number

%%


