
@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    set "version=%~1"
    set "bit=%~2"

    rem by default 'version' - latest Visual Studio 
    rem by default 'bit'     - x64

    if not defined bit (set "bit=64")

    call "%~dp0init.bat"
    if errorlevel 1 (exit /b 1)

    if not defined eMSVC_%bit%_LAST (
        @echo [ERROR] address-model '%bit%' not support
        exit /b 1
    )

    if defined version (
        set "version=%version:msvc=%"
    )

    if not defined version (
        call set "version=%%eMSVC_%bit%_LAST%%"
    ) 

    rem @echo [get] msvc%version%-%bit%

    set "eCOMPILER_TAG="
    set "eINIT_COMPILER="
    set "eGENERATOR="
    set "eBOOST_TOOLSET="

    call :getThisVersion 
    if errorlevel 1 (
        @echo [ERROR] msvc%version% [%bit% bits] not found
        exit /b 1
    )
exit /b 0
	
rem ============================================================================
rem ============================================================================

:getThisVersion 
    if "%version%" == "2022" (
        call :getVersion2022
        exit /b
    )
    if "%version%" == "2019" (
        call :getVersion2019
        exit /b
    )
    if "%version%" == "2017" (
        call :getVersion2017
        exit /b
    )
    if "%version%" == "2015" (
        call :getVersion2015
        exit /b
    )
    if "%version%" == "2013" (
        call :getVersion2013
        exit /b
    )
    if "%version%" == "2012" (
        call :getVersion2012
        exit /b
    )
    if "%version%" == "2010" (
        call :getVersion2010
        exit /b
    )
    if "%version%" == "2008" (
        call :getVersion2008
        exit /b
    )
exit /b 1

rem ============================================================================
rem ============================================================================

:getVersion2022
    if not defined VS170COMNTOOLS (exit /b 1)
    set "eCOMPILER_TAG=msvc2022"
    set "eINIT_COMPILER=%VS170COMNTOOLS%VsDevCmd.bat"
    set "eGENERATOR=Visual Studio 17 2022"
    set "eBOOST_TOOLSET=vc143"
exit /b

:getVersion2019
    if not defined VS160COMNTOOLS (exit /b 1)
    set "eCOMPILER_TAG=msvc2019"
    set "eINIT_COMPILER=%VS160COMNTOOLS%VsDevCmd.bat"
    set "eGENERATOR=Visual Studio 16 2019"
    set "eBOOST_TOOLSET=vc142"
exit /b

:getVersion2017
    if not defined VS150COMNTOOLS (exit /b 1)
    set "eCOMPILER_TAG=msvc2017"
    set "eINIT_COMPILER=%VS150COMNTOOLS%VsDevCmd.bat"
    set "eGENERATOR=Visual Studio 15 2017"
    set "eBOOST_TOOLSET=vc141"
exit /b

:getVersion2015
    if not defined VS140COMNTOOLS (exit /b 1)
    set "eCOMPILER_TAG=msvc2015"
    set "eINIT_COMPILER=%VS140COMNTOOLS%vsvars32.bat"
    set "eGENERATOR=Visual Studio 14 2015"
    set "eBOOST_TOOLSET=vc14"
exit /b

:getVersion2013
    if not defined VS120COMNTOOLS (exit /b 1)
    set "eCOMPILER_TAG=msvc2013"
    set "eINIT_COMPILER=%VS120COMNTOOLS%vsvars32.bat"
    set "eGENERATOR=Visual Studio 12 2013"
    set "eBOOST_TOOLSET=vc12"
exit /b

:getVersion2012
    if not defined VS110COMNTOOLS (exit /b 1)
    set "eCOMPILER_TAG=msvc2012"
    set "eINIT_COMPILER=%VS110COMNTOOLS%vsvars32.bat"
    set "eGENERATOR=Visual Studio 11 2012"
    set "eBOOST_TOOLSET=vc11"
exit /b

:getVersion2010
    if not defined VS100COMNTOOLS (exit /b 1)
    set "eCOMPILER_TAG=msvc2010"
    set "eINIT_COMPILER=%VS100COMNTOOLS%vsvars32.bat"
    set "eGENERATOR=Visual Studio 10 2010"
    set "eBOOST_TOOLSET=vc10"
exit /b

:getVersion2008
    if not defined VS90COMNTOOLS (exit /b 1)
    set "eCOMPILER_TAG=msvc2008"
    set "eINIT_COMPILER=%VS90COMNTOOLS%vsvars32.bat"
    set "eGENERATOR=Visual Studio 9 2008"
    set "eBOOST_TOOLSET=vc9"
exit /b

rem ============================================================================
rem ============================================================================

:checkParent
    if errorlevel 1 (
        @echo [ERROR] was broken at launch
        exit /b 1
    )
exit /b 0

rem ============================================================================
rem ============================================================================
