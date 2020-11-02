#include "templateb.hpp"

#include "templatea.hpp"

namespace templateb
{
    void usetemplateb(void)
    {
        std::cout << "*** using templateb ***" << std::endl;
        templatea::usetemplatea();
        std::cout << "***********************" << std::endl;
    }
}