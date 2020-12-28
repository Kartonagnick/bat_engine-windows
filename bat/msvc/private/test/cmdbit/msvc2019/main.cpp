
#if 0

#include <stdio.h>
#include <fstream>      // std::fstream
#include <iostream>
#include <stdio.h>
#include <string.h>
#include <cassert>



char Header[0x200] = {};
char Elf32Magic  [20] = "\x7f\x45\x4c\x46\01";  //7F 45 4C 46  01 // ELF32 
char Elf64Magic  [20] = "\x7f\x45\x4c\x46\02";  //7F 45 4C 46  02 // ELF64
char Win32Magic  [20] = "\x50\x45\x00\x00\x4C\x01";// PE32
char Win64Magic  [20] = "\x50\x45\x00\x00\x64\x86";// PE64

char PeHeader[20] = {};
void CheckWinHeader(){
  int k = 0;
  for (int i = 0; i < 0x200; i++)
  {
   if(Header[i] == 0x50 && Header[i+1] == 0x45) // PE     
     {

      for(int j = i; j < i + 6; j++)
      {
        PeHeader[k] = Header[j];
        k++;
       //printf("%hhx", Header[j]); 
      }
     }
  }
}


int main(int argc, char* argv[]){

    (void)argc;

    std::cout << "file: " << argv[1] << '\n';

  std::fstream fs; 
  fs.open (argv[1], std::fstream::in|std::fstream::binary);
  assert(fs);
  fs.read( Header , 0x200);
 
  if(memcmp ( Header, Elf32Magic, 5 ) == 0 ){
    printf("ELF 32 Match Found ! \n");
  }
  if(memcmp ( Header, Elf64Magic, 5 ) == 0 ){
    printf("Elf 64 Match Found ! \n");
  }

  CheckWinHeader();

  if(memcmp ( &PeHeader, Win32Magic, 6 ) == 0 ){
    printf("Win 32 Match Found ! \n");
  }

  if(memcmp ( &PeHeader, Win64Magic, 6 ) == 0 ){
    printf("Win 64 Match Found ! \n");
  }
}
#endif


#include <iostream>
#include <tools/bitexe.hpp>

int main(int argc, char* argv[])
{
    if (argc < 2)
    {
        std::cerr << "invalid syntaxis.\n";
        return EXIT_FAILURE;
    }

    try
    {
        //std::cout << "(debug) check: " << argv[1] << "\n";

        using En = fsystem::eBIT_MODEL;
        const auto re = fsystem::check_bit_model(argv[1]);
        if (re == En::eBIT_32_ELF || re == En::eBIT_32_WIN)
            std::cout << "32\n";
        else if (re == En::eBIT_64_ELF || re == En::eBIT_64_WIN)
            std::cout << "64\n";
        else
            std::cout << "unknown\n";
    }
    catch (const std::exception& e)
    {
        std::cerr << "main(std::exception): " << e.what() << '\n';
    }
}
