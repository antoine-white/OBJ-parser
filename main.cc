#include <iostream>
#include <vector>
#include <fstream>

#include "geo_objects.hh"
#include "parser.tab.hh"
#include "utils.hh"

using namespace std;

/******* declaration pour parser *******/

vector<serializable *> objects;
vector<vertice *> vertices;
vector<pair<int, int>> redundant;
vector<face> faces;
int nbGroup = 0;
int nbObject = 0;


/******* GESTION ERREURS *******/
extern int yylineno;

void yyerror(const char *msg)
{
    printf("Error line %d :\n %s\n", yylineno, msg);
}

/******* calcul arités *******/

pair<int, int> getArritiesMinMax(vector<face> &faces)
{
    int minSize = 0;
    int maxSize = 0;
    if (faces.size())
    {
        minSize = faces[0].size();
        maxSize = faces[0].size();
        for (int i = 1; i < faces.size(); i++)
        {
            if (faces[i].size() > maxSize)
                maxSize = faces[i].size();
            else if (faces[i].size() < minSize)
                minSize = faces[i].size();
        }
    }
    return make_pair(minSize, maxSize);
}

/******* SERIALISATION *******/

string serialise(){
    
    string serialization_str = "# serialization by obj_parser " + string(__DATE__) + " build \n";
    int count = 1;

    vector<pair<int,vertice*>> new_vertices;
    
    for (auto s : objects)
    {        
        if (vertice *v = dynamic_cast<vertice *>(s)){
            bool r = false;
            for (auto p : redundant)
                if(p.second == v->getNb()){
                    r = true;
                    break;
                }
            if (! r)
            {
                v->updateNb(new_vertices.size() + 1);
                new_vertices.push_back(make_pair(count,v));
                serialization_str += v->to_str() + "\n";   
            }
            count++;
                    
        } else
        if (face *f = dynamic_cast<face *>(s))
        {
            int *nbs = f->nbOfVertices();
            for (int i = 0; i < f->size(); i++)
            {
                for (auto p : redundant)
                    if(p.second == nbs[i]){
                        nbs[i] = p.first;
                        break;
                    }
            }
            vertice** v_arr = new vertice*[f->size()];
            for (int i = 0; i < f->size(); i++){
                for (auto p : new_vertices)
                    if (p.first == nbs[i]){
                        v_arr[i] = p.second;
                        break;
                    }
            }
                
            if (special_face *fs = dynamic_cast<special_face *>(f)){
                special_face tmp(v_arr,f->size(),fs->additionalString());    
                serialization_str += tmp.to_str() + "\n";
            } else {
                face tmp(v_arr,f->size());    
                serialization_str += tmp.to_str() + "\n";
            }
        }
        else
            serialization_str += s->to_str() + "\n";
    }

    return serialization_str ;
}

/******* main *******/

int main(int argc, char** argv)
{
    int res = 0;
    res = yyparse();

    auto arities = getArritiesMinMax(faces);

    for (auto p : redundant)
        if (vertices[p.second]->getNbFace() > 1)
            cout << "Duplicate vertice nb " << p.second << " use "
                 << vertices[p.second]->getNbFace() << " times" << endl;

    cout << (res == 0 ? "0 erreur" : "Problème") << endl;
    cout << "Size vertices: " << vertices.size() << endl;
    cout << "Size faces: " << faces.size() << endl;
    cout << "Face arity min: " << arities.first << endl;
    cout << "Face arity max: " << arities.second << endl;
    cout << "size objects: " << nbGroup << endl;
    cout << "size groups: " << nbObject << endl;
    cout << "redundant vertices: " << redundant.size() << endl;

    if (argc == 2)
    {
        string str_in(argv[1]);
        string file_signature = ".obj";
        if (! ends_with(str_in,file_signature)) 
            str_in += file_signature;
        ofstream out(str_in);
        out << serialise();
        out.close();
    }
    
    for (auto s : objects)
        delete s;

    return EXIT_SUCCESS;
}