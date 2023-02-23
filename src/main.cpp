#include <CGAL/Exact_predicates_inexact_constructions_kernel.h>

#include <CGAL/Polyhedron_3.h>
#include <CGAL/Polyhedron_items_with_id_3.h>
#include <CGAL/draw_polyhedron.h>

#include <CGAL/Polygon_mesh_processing/IO/polygon_mesh_io.h>

#include <iostream>
#include <fstream>

typedef CGAL::Exact_predicates_inexact_constructions_kernel             Kernel;
typedef CGAL::Polyhedron_3<Kernel>                                      Polyhedron;

namespace PMP = CGAL::Polygon_mesh_processing;

int main()
{
    Polyhedron ribcage;
    const std::string infile("C:/Users/marti/OneDrive - TU Eindhoven/Documenten/Master/Team Challenge/data/Scoliose/4preopmesh.ply");
    if (!PMP::IO::read_polygon_mesh(infile, ribcage) || !CGAL::is_triangle_mesh(ribcage)){
        std::cout << "PLY file not loaded into mesh!" << std::endl;
        return 1;
    }

    std::cout << "Amount of vertices: " << ribcage.size_of_vertices() << std::endl;
    //CGAL::draw(ribcage);

    return EXIT_SUCCESS;
}