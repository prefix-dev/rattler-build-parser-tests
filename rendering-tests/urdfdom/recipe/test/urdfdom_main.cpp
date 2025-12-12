#include <urdf_parser/urdf_parser.h>

#include <cstdlib>
#include <iostream>

int main()
{   
    urdf_export_helpers::URDFVersion urdfver("1.2");
    std::cerr << "Version extracted from string: " 
              << urdfver.getMajor() << "."
              << urdfver.getMinor() << std::endl;
    
    return EXIT_SUCCESS;
}
