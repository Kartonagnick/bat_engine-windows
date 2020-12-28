
#include <iostream>

int main(int argc, char* argv[])
{
    std::cout << "hello world\n";
    if(argc > 1)
    {
        std::cout << "arguments:\n";
        for (int i = 1; i != argc; ++i)
            std::cout << i << ") " << argv[i] << '\n';
    }
}

