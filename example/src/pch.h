
#pragma once

#ifdef _MSC_VER
    #ifdef STABLE_RELEASE
        #pragma message("Build stable release version")
    #else
        #pragma message("Build development version")
    #endif
#endif

#include <iostream>


