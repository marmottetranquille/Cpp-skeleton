#include <iostream>

#include "templatea/templatea2.hpp"

namespace templatea
{
    std::string __templatea2 = "templatea2";

    templatea2::templatea2(void)
    {
        _inside = __templatea2;
    }

    std::ostream& operator<<(std::ostream& stream,
                            const templatea2& in)
    {
        stream << in._inside;
        return stream;
    }
}