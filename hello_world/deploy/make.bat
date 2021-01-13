@echo off 
cls

rem set eDEBUG=ON
set "eDIR_OWNER=%~dp0"
set "eDIR_BAT_ENGINE=C:\bat_engine\bat\engine"
set "order=msvc:64:debug:dynamic"
rem set "order=all"

call "%eDIR_BAT_ENGINE%\run.bat" ^
    "--install: cmake-makefiles" ^
    "--configurations: %order%"

call "%eDIR_BAT_ENGINE%\run.bat" "--runTests"

rem ============================================================================
rem ============================================================================

