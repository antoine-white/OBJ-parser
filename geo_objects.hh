#include <vector>
#include <iostream>
#include <string>

struct serializable{ 
    virtual std::string to_str() const = 0;
};

class obj_other  : public serializable
{
    std::string s;
public:
    obj_other(std::string ss) : s(ss) {}
    std::string to_str() const {return s;}
};


class face;
class vertice : public serializable
{
private:
    double a;
    double b;
    double c;
    int nbFace;
    int nb;
public:
    vertice(double a1, double a2, double a3, int n) : a(a1), b(a2), c(a3) , nb(n) {nbFace = 0;};
    inline bool operator==(vertice &v) const { return v.a == a && v.b == b && v.c == c;}
    inline void addFace(){
        nbFace++;
    }
    inline int getNbFace() const {return nbFace;}
    inline int getNb() const {return nb;}
    std::string to_str() const{
        return "v " + std::to_string(a) + " " + std::to_string(b) + " " + std::to_string(c);
    }
};


class face : public serializable
{
private:
    vertice** vs;
    int _size;
public:
    // face is not the owner of v pointers
    face(vertice** v, int s) : vs(v), _size(s) {
        for (int i = 0; i < _size; i++){
            vs[i]->addFace();
        }
    };
    inline int size() const {return _size;}
    inline bool isIn(vertice* v){ 
        for (int i = 0; i < _size; i++)
            if (v == vs[i])
                return true;
        return false;       
    }
    std::string to_str() const{
        std::string s = "f ";
        for (int i = 0; i < _size; i++)
            s += " " + std::to_string(vs[i]->getNb());
        return s;
    }
};

