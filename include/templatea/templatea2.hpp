#ifndef __TEMPLATEA2__
#define __TEMPLATEA2__

#include <iostream>

namespace templatea
{
    class templatea2
    {
        private:
            std::string _inside;

        public:
            templatea2(void);

            friend std::ostream& operator<<(std::ostream&,
                                            const templatea2&);
    };
}

#endif