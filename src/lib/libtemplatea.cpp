#include "templatea.hpp"
#include "templateb.hpp"

namespace templatea
{
    void usetemplatea(void)
    {
        templatea::templatea1 ta1;
        templatea::templatea2 ta2;

        std::cout << "*** using templatea ***" << std::endl;
        std::cout << ta1 << std::endl;
        std::cout << ta2 << std::endl;
        std::cout << "***********************" << std::endl;

        templateb::usetemplateb();
    }
}