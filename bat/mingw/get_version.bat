@echo off
rem ============================================================================
rem ============================================================================

:main
    setlocal

    set "version=%~1"
    set "bit=%~2"

    if not defined bit (set bit=64)


    call "%~dp0init.bat"
    if errorlevel 1 (exit /b 1)

    if not defined eMINGW_%bit%_LAST (
        @echo [ERROR] address-model '%bit%' not support
        exit /b 1
    )

    call :toLower version %version%

    if defined version (set "version=%version:mingw=%") 
    if not defined version (call set "version=%%eMINGW_%bit%_LAST%%") 

    rem @echo [get] mingw%version%-%bit%

    call :getThisversion 
    if errorlevel 1 (
        @echo [ERROR] mingw%version%-%bit% not found
    )

    endlocal & (
        set "eMINGW_32_VERSIONS=%eMINGW_32_VERSIONS%"
        set "eMINGW_32_LAST=%eMINGW_32_LAST%"

        set "eMINGW_64_VERSIONS=%eMINGW_64_VERSIONS%"
        set "eMINGW_64_LAST=%eMINGW_64_LAST%"

        set "eCOMPILER_TAG=%eCOMPILER_TAG%"
        set "eGENERATOR=%eGENERATOR%"
        set "eBOOST_TOOLSET=%eBOOST_TOOLSET%"
        set "eINIT_COMPILER=%eINIT_COMPILER%"
    )
exit /b

rem ============================================================================
rem ============================================================================

:getThisversion 
    set "VARIABLE_NAME=eMINGW%version%_%bit%"
    if not defined %VARIABLE_NAME% (exit /b 1)
    call set "eINIT_COMPILER=%%%VARIABLE_NAME%%%"
    set "eCOMPILER_TAG=mingw%version%"
    set "eGENERATOR=MinGW Makefiles"
    set "eBOOST_TOOLSET=gcc"
exit /b

rem ============================================================================
rem ============================================================================

:toLower
    set "VARIABLE_NAME="
    set "VARIABLE_VALUE="
    for /F "tokens=1,*" %%a in ("%*") do (
        set "VARIABLE_NAME=%%a"
        set "VARIABLE_VALUE=%%b"
    )
    if not defined VARIABLE_NAME (
        @echo [ERROR] 'VARIABLE_NAME' not defined
        goto :failedToLower
    )
    if not defined VARIABLE_VALUE (
        set "VARIABLE_VALUE=" 
        goto :successToLower
    )
    for %%j in ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i"
                "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r"
                "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z") do (
        call set "VARIABLE_VALUE=%%VARIABLE_VALUE:%%~j%%"
    )
:successToLower
    set "%VARIABLE_NAME%=%VARIABLE_VALUE%"
    set "VARIABLE_VALUE="
    set "VARIABLE_NAME="
exit /b
:failedToLower
    set "VARIABLE_VALUE="
    set "VARIABLE_NAME="
exit /b 1

rem ============================================================================
rem ============================================================================



