@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    set "eMINGW_32_LAST=0"
    set "eMINGW_32_VERSIONS= "

    set "eMINGW_64_LAST=0"
    set "eMINGW_64_VERSIONS= "

    setlocal

        call :normalize eDIR_LONG1 "C:\long\workspace"
        call :normalize eDIR_LONG2 "D:\long\workspace"
        call :normalize eDIR_LONG3 "%eDIR_WORKSPACE%\..\long\workspace"

        if defined ProgramFiles(x86) (
            call :findProgram64
            call :findProgram32
        ) else (
            call :findProgram32Only
        )

        call :sortVersions eMINGW_64_VERSIONS
        call :sortVersions eMINGW_32_VERSIONS

        call :trim eMINGW_64_VERSIONS %eMINGW_64_VERSIONS%
        call :trim eMINGW_32_VERSIONS %eMINGW_32_VERSIONS%

        rem call :viewDebug

    endlocal & (
        set "eMINGW_32_VERSIONS=%eMINGW_32_VERSIONS%"
        set "eMINGW_64_VERSIONS=%eMINGW_64_VERSIONS%"
        set "eMINGW_32_LAST=%eMINGW_32_LAST%"     
        set "eMINGW_64_LAST=%eMINGW_64_LAST%"     

        set "eMINGW1020_32=%eMINGW1020_32%"
        set "eMINGW930_32=%eMINGW930_32%"
        set "eMINGW920_32=%eMINGW920_32%"
        set "eMINGW840_32=%eMINGW840_32%"
        set "eMINGW810_32=%eMINGW810_32%"
        set "eMINGW730_32=%eMINGW730_32%"
        set "eMINGW720_32=%eMINGW720_32%"

        set "eMINGW1020_64=%eMINGW1020_64%"
        set "eMINGW930_64=%eMINGW930_64%"
        set "eMINGW920_64=%eMINGW920_64%"
        set "eMINGW840_64=%eMINGW840_64%"
        set "eMINGW810_64=%eMINGW810_64%"
        set "eMINGW730_64=%eMINGW730_64%"
        set "eMINGW720_64=%eMINGW720_64%"
    ) 

exit /b

:viewDebug
    @echo.
    @echo [eMINGW_64_VERSIONS] ... '%eMINGW_64_VERSIONS%'
    @echo [eMINGW_64_LAST] ....... '%eMINGW_64_LAST%'

    for %%a in (%eMINGW_64_VERSIONS%) do (
        call :viewVersion "%%~a" 64
    )

    @echo.
    @echo [eMINGW_32_VERSIONS] ... '%eMINGW_32_VERSIONS%'
    @echo [eMINGW_32_LAST] ....... '%eMINGW_32_LAST%'

    for %%a in (%eMINGW_32_VERSIONS%) do (
        call :viewVersion "%%~a" 32
    )
exit /b

:viewVersion
    set "bit=%~2"
    call set "val=%%eMINGW%~1_%bit%%%"
    @echo [%~1] %val%
exit /b

rem ============================================================================
rem ============================================================================

:findProgram64
rem    @echo [x64] ...
    set "bit=64"
    set PATH_ARRAY[1]=%eDIR_WORKSPACE%\programs\x64
    set PATH_ARRAY[2]=%eDIR_LONG1%\programs\x64
    set PATH_ARRAY[3]=%eDIR_LONG2%\programs\x64
    set PATH_ARRAY[4]=%eDIR_LONG3%\programs\x64
    set PATH_ARRAY[5]=C:\Program Files
    set PATH_ARRAY[6]=C:\TDM-GCC-64
    set PATH_ARRAY[7]=C:
    set PATH_ARRAY[8]=...end...
    call :findProgram PATH_ARRAY ePATHS_64_MINGW
exit /b

:findProgram32
rem    @echo [x86] ...
    set "bit=32"
    set PATH_ARRAY[1]=%eDIR_WORKSPACE%\programs\x86
    set PATH_ARRAY[2]=%eDIR_LONG1%\programs\x86
    set PATH_ARRAY[3]=%eDIR_LONG2%\programs\x86
    set PATH_ARRAY[4]=%eDIR_LONG3%\programs\x86
    set PATH_ARRAY[5]=C:\Program Files (x86)
    set PATH_ARRAY[6]=C:\TDM-GCC-32
    set PATH_ARRAY[7]=C:
    set PATH_ARRAY[8]=...end...
    call :findProgram PATH_ARRAY ePATHS_32_MINGW
exit /b

:findProgram32Only
    rem @echo [OS-32] ...
    set "bit=32"
    set PATH_ARRAY[1]=%eDIR_WORKSPACE%\programs\x86
    set PATH_ARRAY[2]=%eDIR_LONG%\programs\x86
    set PATH_ARRAY[3]=C:\Program Files
    set PATH_ARRAY[4]=C:\TDM-GCC-32
    set PATH_ARRAY[5]=C:
    set PATH_ARRAY[6]=...end...
    call :findProgram PATH_ARRAY ePATHS_32_MINGW
exit /b

:findProgram
    set "index=1"
    set "arr=%~1"
    set "res=%~2"
:findProgramLoop
    call set "value=%%%arr%[%index%]%%"
    if "%value%" == "" (goto :findProgramLoopNext)
    if "%value%" == "...end..." exit /b
    call :findMingw_w64 "%value%"
    call :findMingw_winlibs "%value%"
:findProgramLoopNext
    set /a "index=%index%+1"
goto :findProgramLoop

:findMingw_w64
    for /D %%a  in ("%~1\mingw*") do (call :visitMingw "%%~a")
    if exist "%~1\bin" (
        call :visitMingw "%~1\bin"
    )
exit /b

:findMingw_winlibs
    for /D %%a  in ("%~1\winlibs*") do (call :visitMingw "%%~a")
    if exist "%~1\bin" (
        call :visitMingw "%~1\bin"
    )
exit /b

:visitMingw
    rem @echo [ENTER] "%~1"
    pushd "%~1"
    for /f "delims=" %%f in ('dir /b /a-d /s gcc.exe 2^>nul') do (
        call :checkMingw "%%~f"
    )
    popd 
exit /b

:checkMingw
    rem @echo   -- %~1
    goto :skipCheckBitModel

    call :checkBitModel "%~1" bit_gcc
    if defined bit_gcc (
        if not "%bit%" == "%bit_gcc%" (
            @echo [CANCEL][expected = %bit%][real = %bit_gcc%] "%~1"
            exit /b
        )
    )
:skipCheckBitModel

    for /F "tokens=1,2,3 delims=." %%i in ('"%~1" -dumpversion') do (
        set "version=%%i%%j%%k"
    )
    if errorlevel 1 (
        @echo [WARNING] error detected. skip
        exit /b
    )

    rem @echo   [found] %version%

    call set "list=%%eMINGW_%bit%_VERSIONS%%"
    call set "checked=%%list:%version%=%%"
    if not "%checked%" == "%list%" (
        @echo   [SKIP] mingw-%version%: already processed
        @echo   [SKIP] "%~1"
        exit /b
    )

    set "eMINGW_%bit%_VERSIONS=%version% %list%"

    call :normalizePath "%~1\.." eMINGW%version%_%bit%

    call set "last_version=%%eMINGW_%bit%_LAST%%"
    if %version% GTR %last_version% (
        set "eMINGW_%bit%_LAST=%version%"
    )
exit /b

:checkBitModel
    if not defined ePROGRAM_CMDBIT (
        set "%~2="
        exit /b
    )
    pushd "%ePATH_CMD%"
    for /f "usebackq tokens=*" %%a in (`cmdbit.exe "%~1" 2^>nul`) do (
        set "%~2=%%a"
    )
    popd
exit /b

rem ============================================================================
rem ============================================================================

:concatString
    rem %~1 name of variable
    rem %~2 value
    call set "%~1=%~2 %%%~1%%"
exit /b

:sortVersions
    set "coll=%~1"
    call set "val=%%%coll%%%"
    for %%a in (%val%) do (set sort_mingw[%%a]=dimmy)
    set "%coll%="
    for /F "tokens=2 delims=[]" %%a in ('set "sort_mingw[" 2^>nul') do (
        call :concatString "%coll%" "%%~a"
    )
    for %%a in (%val%) do (set sort_mingw[%%a]=)
exit /b

rem ============================================================================
rem ============================================================================

:normalizePath
    set "RETVAL=%~dpfn1"
:removeEndedSlash
    set "last=%RETVAL:~-1%"
    if "%last%" == "\" (
        set "RETVAL=%RETVAL:~0,-1%"
        goto :removeEndedSlash
    )
    if "%last%" == "/" (
        set "RETVAL=%RETVAL:~0,-1%"
        goto :removeEndedSlash
    )
    set "%~2=%RETVAL%"
exit /b

rem ============================================================================
rem ============================================================================

:trim
    set "trimResult=%*"
    for /f "tokens=1,*" %%a in ("%trimResult%") do (
        call set "%%a=%%b"
    )
exit /b

rem ============================================================================
rem ============================================================================

:checkParent
    if errorlevel 1 (
        @echo [ERROR] was broken at launch
        exit /b 1
    )
    call :normalize eDIR_WORKSPACE "%~dp0..\..\..\.."
    call :normalize eDIR_COMMANDS "%~dp0..\..\..\cmd"

    if exist "%eDIR_COMMANDS%\cmdbit.exe" (
        set "ePROGRAM_CMDBIT=%eDIR_COMMANDS%\cmdbit.exe"
    )

exit /b

:normalize
    if defined %~1 (exit /b)
    set "%~1=%~dpfn2"
exit /b

rem ============================================================================
rem ============================================================================

