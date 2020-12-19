#include "geo_objects.hh"

bool vertice::operator==(vertice &v) const
{
    return v.a == a && v.b == b && v.c == c;
}
