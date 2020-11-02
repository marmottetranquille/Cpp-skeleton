#include "templatec.hpp"

#include "templateb.hpp"

#include <iostream>

namespace templatea
{
    extern std::string __templatea1;
}

namespace templatec
{
    void usetemplatec(void)
    {
        std::cout << "*** using templatec ***" << std::endl;
        templateb::usetemplateb();
        std::cout << templatea::__templatea1;
        std::cout << "***********************" << std::endl;
    }
}