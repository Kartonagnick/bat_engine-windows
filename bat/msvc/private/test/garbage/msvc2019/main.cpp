
#include "cmd.hpp"

#include <iostream>
#include <cassert>
#include <cstring>
#include <string>

int main(int argc, char* argv[])
{
    for (size_t i = 0; i != argc; ++i)
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
