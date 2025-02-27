
// --- workspace/scripts/bat/msvc                            [find_in][main.cpp]
// reconstruct:
//   [2024-02m-09][02:58:33] 004 Kartonagnick    
//   [2023-06m-01][01:54:31] 003 Kartonagnick    
//   [2023-01m-30][19:52:41] 002 Kartonagnick    
//   [2022-08m-05][05:59:37] 001 Kartonagnick    

//==============================================================================
//==============================================================================

#include "cmd.hpp"
#include <tools/env.hpp>

#include <iostream>
#include <cassert>
#include <cstring>
#include <clocale>
#include <string>

int main(int argc, char* argv[])
{
    // "--start:E:\sorted\feedback"  "--S:*" "--D:*" "--F:*" 
    // tools::env::set("ePATH_ROOT", "C:\\Users\\idrisov.d\\work\\workspace");
    // tools::env::set("ePATH_LONG", "C:\\Users\\idrisov.d\\work\\workspace\\..\\long\\workspace");
    // "--start:  ePATH_ROOT\programs\x64; ePATH_LONG\programs\x64;" "--S: mingw*" "--D: mingw*; bin" --debug
    
    //"--start: eSTART" "--mask: %mask%" "--debug" 

    //tools::env::set("eSTART", "E:\\÷веты на подоконнике\\фотоархив\\2024-[01-06]");
    //tools::env::set("eSCAN_INCLUDE", "2024-03m-*");
    //tools::env::set("eSCAN_EXCLUDE", "_*;*драцена*");
    //tools::env::set("eDIRS_INCLUDE", "*мастерска€*;*комод*");
    //tools::env::set("eDIRS_EXCLUDE", "_*");
    //tools::env::set("eFILES_INCLUDE", "*.jpg");
    //tools::env::set("eFILES_EXCLUDE", "_*");

    //--start:eSTART --S:eSCAN_INCLUDE --ES:eSCAN_EXCLUDE --D:eDIRS_INCLUDE --ED:eDIRS_EXCLUDE --sort --debug

    std::locale::global(std::locale(""));
    
    if (!cmd::checkArgument(argc, argv))
        return EXIT_FAILURE;
    
    if (argc < 2)
        return cmd::invalidSyntaxis();
    
    if (argc == 2)
    {
        if(cmd::needShowHelpInfo(argv))
            return EXIT_SUCCESS;
        return cmd::invalidSyntaxis();
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
        std::cerr << "[ERROR] " << e.what() << '\n';
    }

    return EXIT_SUCCESS;
}


#if 0
// "-SRC: ePATH_ROOT/programs/x86;C:/Program Files;C:" "-D: mingw*" --debug
:findProgram64
  set dirs = "-start : ePATH_ROOT\programs\x64\7 - Zip;C:\Program Files\7 - Zip;ePATH_ROOT\programs\x86\7 - Zip;C:\Program Files(x86)\7 - Zip;D:\long\workspace\programs\x64\7 - Zip" "--S:7-Zip*" "--F:7z.exe" "--once" "--dirnames"
  echo[ping - 1]
  find_in.exe "--start:%dirs%" "--S:7-Zip*" "--F:7z.exe" "--once" "--dirnames"
  echo[ping - 2]
#endif

