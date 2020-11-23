#include "templatea.hpp"

#include <GL/glew.h>
#include <GLFW/glfw3.h>

bool glewinit(void)
{
    glewExperimental = true;
    return glfwInit();
}