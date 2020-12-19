#include <vector>

class vertice
{
private:
    double a;
    double b;
    double c;
public:
    vertice(double a1, double a2, double a3) : a(a1), b(a2), c(a3) {};
    bool operator==(vertice& v) const ;
};


class face
{
private:
    vertice** vs;
    int _size;
public:
    // face is not the owner of v pointers
    face(vertice** v, int s) : vs(v), _size(s) {};
    inline int size() const {return _size;}
};

