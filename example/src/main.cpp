
#include <example/example.hpp>
#include <iostream>

int main(int argc, char* argv[])
{
    hello();

    if(argc > 1)
    {
        std::cout << "arguments:\n";
        for (int i = 1; i != argc; ++i)
            std::cout << i << ") " << argv[i] << '\n';
    }

    std::cout.setf(std::ios::fixed, std::ios::floatfield); 
    std::cout << 13.54 + 21.78 << '\n';

}

