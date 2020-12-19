%{
#include <iostream>
#include "utils.hh"
extern int yylex();
%}

// ================= //

%define parse.error verbose

%union {
	char ident[255];
	double value;
    int ivalue;
}

%token VERTEX TEXTURE NORM SLASH OFF USE_MAT LISSAGE MAT_LIB FACE;

%token<ivalue> INTEGER "integer";
%token<value> FLOAT;
%token<ident> ID FILE_STR;

%start root

%%

root : instr root|

instr: vertex | normale | texture | bibli | use_mat | lissage| face;

face : triangle | triangle_texture | triangle_normal | triangle_texture_normale;

triangle : FACE number number number;

triangle_texture : FACE number SLASH number  number SLASH number  number SLASH number ;



triangle_normal : FACE number SLASH SLASH number  number SLASH SLASH number  number SLASH SLASH number ;

triangle_texture_normale : FACE number SLASH number SLASH number

vertex : VERTEX number number number;

normale : NORM number number number;

texture: TEXTURE number number;

bibli : MAT_LIB FILE_STR;

use_mat : USE_MAT ID;

lissage : LISSAGE INTEGER| LISSAGE OFF;

number : FLOAT | INTEGER

%%


