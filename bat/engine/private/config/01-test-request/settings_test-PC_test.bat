@echo off 
if defined ENGINE_ALREADY_INITIALIZED (exit /b) 
set "ENGINE_ALREADY_INITIALIZED=yes" 
 
rem ......................................................................... 
 
set "eMINGW_32_VERSIONS=810 730 720" 
set "eMINGW_32_LAST=810" 
 
set "eMINGW810_32=C:\long\workspace\programs\x86\mingw-w64\i686-8.1.0-posix-dwarf-rt_v6-rev0\mingw32\bin" 
set "eMINGW730_32=C:\long\workspace\programs\x86\mingw-w64\i686-7.3.0-posix-dwarf-rt_v5-rev0\mingw32\bin" 
set "eMINGW720_32=C:\long\workspace\programs\x86\mingw-w64\i686-7.2.0-posix-dwarf-rt_v5-rev1\mingw32\bin" 
 
rem ............................................................................ 
 
set "eMINGW_64_VERSIONS=810 730 720" 
set "eMINGW_64_LAST=810" 
 
set "eMINGW810_64=C:\long\workspace\programs\x64\mingw-w64\x86_64-8.1.0-posix-seh-rt_v6-rev0\mingw64\bin" 
set "eMINGW730_64=C:\long\workspace\programs\x64\mingw-w64\x86_64-7.3.0-posix-seh-rt_v5-rev0\mingw64\bin" 
set "eMINGW720_64=C:\long\workspace\programs\x64\mingw-w64\x86_64-7.2.0-posix-seh-rt_v5-rev1\mingw64\bin" 
 
rem ............................................................................ 
 
set "eMSVC_32_VERSIONS=2019 2017 2015 2013 2012 2010 2008" 
set "eMSVC_32_LAST=2019" 
 
set "eMSVC2019_32=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsDevCmd.bat" 
set "eMSVC2017_32=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat" 
set "eMSVC2015_32=C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat" 
set "eMSVC2013_32=C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\VsDevCmd.bat" 
set "eMSVC2012_32=C:\Program Files (x86)\Microsoft Visual Studio 11.0\Common7\Tools\VsDevCmd.bat" 
set "eMSVC2010_32=C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\Tools\VsDevCmd.bat" 
set "eMSVC2008_32=C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\Tools\VsDevCmd.bat" 
 
rem ............................................................................ 
 
set "eMSVC_64_VERSIONS=2019 2017 2015 2013 2012 2010 2008" 
set "eMSVC_64_LAST=2019" 
 
set "eMSVC2019_64=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsDevCmd.bat" 
set "eMSVC2017_64=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat" 
set "eMSVC2015_64=C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat" 
set "eMSVC2013_64=C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\VsDevCmd.bat" 
set "eMSVC2012_64=C:\Program Files (x86)\Microsoft Visual Studio 11.0\Common7\Tools\VsDevCmd.bat" 
set "eMSVC2010_64=C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\Tools\VsDevCmd.bat" 
set "eMSVC2008_64=C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\Tools\VsDevCmd.bat" 
 
rem ......................................................................... 
 
set "eALL_COMPILERS=msvc mingw" 
set "eALL_ADDRESS_MODELS=64 32" 
set "eALL_BUILD_TYPES=release debug" 
set "eALL_RUNTIME_CPPS=dynamic static" 
 
rem ......................................................................... 

