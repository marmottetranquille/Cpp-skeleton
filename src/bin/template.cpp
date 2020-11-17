#include "template.hpp"

#include "templateb.hpp"

#include <iostream>

int main(int argn, char* args[])
{
    if (!glewinit())
        std::cout << "glfw could not be initialized" << std::endl;
    templateb::usetemplateb();
}
