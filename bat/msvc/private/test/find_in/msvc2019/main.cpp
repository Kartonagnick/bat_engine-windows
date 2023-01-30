
#include "cmd.hpp"
#include <tools/env.hpp>

#include <iostream>
#include <cassert>
#include <cstring>
#include <string>

int main(int argc, char* argv[])
{
    // "--start:E:\sorted\feedback"  "--S:*" "--D:*" "--F:*" 

    // tools::env::set("ePATH_ROOT", "C:\\Users\\idrisov.d\\work\\workspace");
    // tools::env::set("ePATH_LONG", "C:\\Users\\idrisov.d\\work\\workspace\\..\\long\\workspace");

    for (int i = 0; i != argc; ++i)
        if (!cmd::checkQuotes(argv[i]))
        {
            cmd::view_arguments(argc, argv);
            std::cerr << '\n';
            std::cerr << "[ERROR] invalid 'pair quote'\n";
            std::cerr << "[ERROR] " << i << ") " << argv[i] << '\n';
            return EXIT_FAILURE;
        }
    
    if (argc < 2)
    {
        std::cerr << "invalid syntaxis.\n";
        return EXIT_FAILURE;
    }

    if (argc == 2)
    {
        if (std::strcmp(argv[1], "--help") == 0)
            cmd::options::view_syntaxis();
        else if (std::strcmp(argv[1], "--version") == 0)
            std::cout << cmd::options::version() << '\n';
        else
        {
            std::cerr << "invalid syntaxis.\n";
            return EXIT_FAILURE;
        }

        return EXIT_SUCCESS;
    }

    cmd::options opt(argc, argv);

    if (opt.debug)
        std::cout << opt << '\n';

    try
    {
        cmd::run(opt);
    }
    catch (const ::std::exception& e)
    {
        ::std::cerr << "[ERROR] " << e.what() << '\n';
    }

    return EXIT_SUCCESS;
}

// "-SRC: ePATH_ROOT/programs/x86;C:/Program Files;C:" "-D: mingw*" --debug
#if 0
:findProgram64
set dirs = ^
"-start : ePATH_ROOT\programs\x64\7 - Zip;C:\Program Files\7 - Zip;ePATH_ROOT\programs\x86\7 - Zip;C:\Program Files(x86)\7 - Zip;D:\long\workspace\programs\x64\7 - Zip" "--S:7-Zip*" "--F:7z.exe" "--once" "--dirnames"

@echo[ping - 1]
find_in.exe "--start:%dirs%" "--S:7-Zip*" "--F:7z.exe" "--once" "--dirnames"
@echo[ping - 2]
exit
#endif

