
@echo off
rem ============================================================================
rem ============================================================================

:main
    call :init
    if errorlevel 1 (exit /b 1)

  rem ------
    rem workaround for QtCreator: set english language for Visual Studio
    set "VSLANG=1033"
  rem ------

    start "%eCOMPILER_TAG%" ^
        qtcreator.exe       ^
        "%eDIR_CMAKE_LIST%\CMakeLists.txt"

    timeout /T 7
exit /b

rem ============================================================================
rem ============================================================================

:init
    call "%~dp0..\init.bat" 
    if errorlevel 1 (
        @echo [ERROR] 'QtCreator' initialization failed
    )
exit /b

rem ============================================================================
rem ============================================================================
