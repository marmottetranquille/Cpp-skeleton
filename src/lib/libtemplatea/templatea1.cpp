#include <iostream>

#include "templatea/templatea1.hpp"

namespace templatea
{
    std::string __templatea1 = "templatea1";

    templatea1::templatea1(void)
    {
        _inside = __templatea1;
    }

    std::ostream& operator<<(std::ostream& stream,
                            const templatea1& in)
    {
        stream << in._inside;
        return stream;
    }
}