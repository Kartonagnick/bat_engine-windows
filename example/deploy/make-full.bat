@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem ============================================================================
rem ============================================================================

:main
    setlocal

    rem set "eDEBUG=ON"
    rem  set "PREFIX={DIR_SOURCES}\deploy"
    set "PREFIX={DIR_OWNER}"

    set "IDE=msvc2019:64:debug:dynamic"
    set "order=all"

    rem call :runVersion
    rem call :runUpdate
    rem call :runInitial
    rem call :cleanBuild
    rem call :generateCmakeMakeFiles
    rem call :buildCmakeMakeFiles
    call :installCmakeMakeFiles
    call :runTest

    rem call :runVisualStudio
    rem call :runQtCreator
exit /b

rem ............................................................................

:runVersion
    call "%eDIR_BAT_ENGINE%\run.bat" --version
exit /b

:runUpdate
    call "%eDIR_BAT_ENGINE%\run.bat" --update
exit /b

:runInitial
    call "%eDIR_BAT_ENGINE%\run.bat" --initial
exit /b

:runTest
    call "%eDIR_BAT_ENGINE%\run.bat" ^
        "--runTests: *.exe"          ^
        "--exclude: mingw*-dynamic"  ^
        "--configurations: %order%"
exit /b

rem ............................................................................

:cleanBuild
    call "%eDIR_BAT_ENGINE%\run.bat" ^
        "--clean: %order%"           ^
        "--configurations: %order%"
exit /b

rem ............................................................................

:runQtCreator
    call "%eDIR_BAT_ENGINE%\run.bat" ^
        "--runIDE: QtCreator"
exit /b

rem ............................................................................

:runVisualStudio
    call "%eDIR_BAT_ENGINE%\run.bat"  ^
        "--runIDE: VisualStudio"      ^
        "--configurations: %IDE%"
exit /b

rem ............................................................................

:generateCmakeMakeFiles
    call "%eDIR_BAT_ENGINE%\run.bat"       ^
        "--generate: cmake-makefiles"      ^
        "--dir_sources: {DIR_SOURCES}"     ^
        "--dir_project: %PREFIX%\cmake"    ^
        "--dir_build:   %PREFIX%\build"    ^
        "--dir_product: %PREFIX%\product"  ^
        "--name_project: {NAME_PROJECT}"   ^
        "--configurations: %order%"        ^
        "--defines: UNSTABLE_RELEASE"
exit /b

rem ............................................................................

:buildCmakeMakeFiles
    call "%eDIR_BAT_ENGINE%\run.bat"       ^
        "--build: cmake-makefiles"         ^
        "--dir_sources: {DIR_SOURCES}"     ^
        "--dir_project: %PREFIX%\cmake"    ^
        "--dir_build:   %PREFIX%\build"    ^
        "--dir_product: %PREFIX%\product"  ^
        "--name_project: {NAME_PROJECT}"   ^
        "--configurations: %order%"        ^
        "--defines: UNSTABLE_RELEASE"
exit /b

rem ............................................................................

:installCmakeMakeFiles
    call "%eDIR_BAT_ENGINE%\run.bat"       ^
        "--install: cmake-makefiles"       ^
        "--dir_sources: {DIR_SOURCES}"     ^
        "--dir_project: %PREFIX%\cmake"    ^
        "--dir_build:   %PREFIX%\build"    ^
        "--dir_product: %PREFIX%\product"  ^
        "--name_project: {NAME_PROJECT}"   ^
        "--configurations: %order%"        ^
        "--defines: STABLE_RELEASE"
exit /b

rem ============================================================================
rem ============================================================================

:normalize
    set "%~1=%~dpfn2"
exit /b

:checkParent
    if errorlevel 1 (
        @echo [ERROR] was broken at launch
        exit /b 1
    )
    if not defined eDIR_OWNER (
        @echo off & cls & @echo. & @echo.
        call :normalize eDIR_OWNER "%~dp0."
    )
    if not defined eDIR_BAT_SCRIPTS (
        call :normalize eDIR_BAT_SCRIPTS "%~dp0..\..\bat"
    )
    if not defined eDIR_BAT_ENGINE (
        set "eDIR_BAT_ENGINE=%eDIR_BAT_SCRIPTS%\engine"
    )
exit /b

rem ============================================================================
rem ============================================================================
