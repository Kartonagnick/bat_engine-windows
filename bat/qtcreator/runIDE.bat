@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    if not exist "%eDIR_CMAKE_LIST%\CMakeLists.txt" (
        @echo [ERROR] not found: eDIR_CMAKE_LIST\CMakeLists.txt
        @echo [ERROR] "%eDIR_CMAKE_LIST%\CMakeLists.txt"
        exit /b 1
    )

    if defined eCOMPILER_TAG (
        set "wnd_name=%eCOMPILER_TAG%"
    ) else (
        set "wnd_name=RunQtCreator"
    )

    start "%wnd_name%" cmd /C "%~dp0private/runIDE.bat"

exit /b

rem ============================================================================
rem ============================================================================

:checkParent
    if errorlevel 1 (
        @echo [ERROR] was broken at launch
        exit /b 1
    )
    if not defined eDIR_OWNER (
        cls
        @echo.
        @echo.
        @echo [ERROR] should be run from under the parent batch file
        exit /b 1
    )
exit /b 0

rem ============================================================================
rem ============================================================================
