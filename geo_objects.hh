#include <vector>
#include <iostream>
#include <string>

struct serializable
{
    virtual std::string to_str() const = 0;
};

class obj_other : public serializable
{
    std::string s;

public:
    obj_other(std::string ss) : s(ss) {}
    std::string to_str() const { return s; }
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
    vertice(double a1, double a2, double a3, int n) : a(a1), b(a2), c(a3), nb(n) { nbFace = 0; };
    bool operator==(vertice &v) const { return v.a == a && v.b == b && v.c == c; }
    void addFace() { nbFace++; }
    int getNbFace() const { return nbFace; }
    int getNb() const { return nb; }
    void updateNb(int n) {nb = n;}
    std::string to_str() const
    {
        return "v " + std::to_string(a) + " " + std::to_string(b) + " " + std::to_string(c);
    }
};

class face : public serializable
{
protected:
    vertice **vs;
    int _size;

public:
    // face is not the owner of v pointers
    face(vertice **v, int s) : vs(v), _size(s)
    {
        for (int i = 0; i < _size; i++)
            vs[i]->addFace();
    };
    inline int size() const { return _size; }
    std::string to_str() const
    {
        std::string s = "f ";
        for (int i = 0; i < _size; i++)
            s += " " + std::to_string(vs[i]->getNb());
        return s;
    }
    int *nbOfVertices() const
    {
        int *res = new int[_size];
        for (int i = 0; i < _size; i++)
            res[i] = vs[i]->getNb();
        return res;
    }
};

class special_face : public face
{
    std::vector<std::string> s;
public:
    special_face(vertice **v, int s, std::vector<std::string> additionalString) : face(v,s), s(additionalString) {};
    std::string to_str() const
    {
        std::string res = "f ";
        for (int i = 0; i < _size; i++)
            res += " " + std::to_string(vs[i]->getNb()) + s[i];
        return res;
    }
    std::vector<std::string> additionalString() const {return s;}
};
