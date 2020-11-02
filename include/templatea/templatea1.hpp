#ifndef __TEMPLATEA1__
#define __TEMPLATEA1__

#include <iostream>

namespace templatea
{
    class templatea1
    {
        private:
            std::string _inside;

        public:
            templatea1(void);

            friend std::ostream& operator<<(std::ostream&,
                                            const templatea1&);
    };
}

#endif