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

    set "PATH=%eDIR_COMMANDS%;%PATH%"    

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
        set "eMINGW710_32=%eMINGW710_32%"
        
        set "eMINGW640_32=%eMINGW640_32%"
        set "eMINGW630_32=%eMINGW630_32%"
        set "eMINGW620_32=%eMINGW620_32%"
        set "eMINGW610_32=%eMINGW610_32%"
        
        set "eMINGW540_32=%eMINGW540_32%"
        set "eMINGW530_32=%eMINGW530_32%"
        set "eMINGW520_32=%eMINGW520_32%"
        set "eMINGW510_32=%eMINGW510_32%"
        
        set "eMINGW494_32=%eMINGW494_32%"
        set "eMINGW493_32=%eMINGW493_32%"
        set "eMINGW492_32=%eMINGW492_32%"
        set "eMINGW491_32=%eMINGW491_32%"
        set "eMINGW490_32=%eMINGW490_32%"
        
        set "eMINGW485_32=%eMINGW485_32%"
        set "eMINGW484_32=%eMINGW484_32%"
        set "eMINGW483_32=%eMINGW483_32%"
        set "eMINGW482_32=%eMINGW482_32%"
        set "eMINGW481_32=%eMINGW481_32%"

        set "eMINGW1020_64=%eMINGW1020_64%"
        set "eMINGW930_64=%eMINGW930_64%"
        set "eMINGW920_64=%eMINGW920_64%"
        set "eMINGW840_64=%eMINGW840_64%"
        set "eMINGW810_64=%eMINGW810_64%"
        set "eMINGW730_64=%eMINGW730_64%"
        set "eMINGW720_64=%eMINGW720_64%"
        set "eMINGW710_64=%eMINGW710_64%"
        
        set "eMINGW640_64=%eMINGW640_64%"
        set "eMINGW630_64=%eMINGW630_64%"
        set "eMINGW620_64=%eMINGW620_64%"
        set "eMINGW610_64=%eMINGW610_64%"
        
        set "eMINGW540_64=%eMINGW540_64%"
        set "eMINGW530_64=%eMINGW530_64%"
        set "eMINGW520_64=%eMINGW520_64%"
        set "eMINGW510_64=%eMINGW510_64%"

        set "eMINGW494_64=%eMINGW494_64%"
        set "eMINGW493_64=%eMINGW493_64%"
        set "eMINGW492_64=%eMINGW492_64%"
        set "eMINGW491_64=%eMINGW491_64%"
        set "eMINGW490_64=%eMINGW490_64%"
        
        set "eMINGW485_64=%eMINGW485_64%"
        set "eMINGW484_64=%eMINGW484_64%"
        set "eMINGW483_64=%eMINGW483_64%"
        set "eMINGW482_64=%eMINGW482_64%"
        set "eMINGW481_64=%eMINGW481_64%"
    ) 
exit /b

rem ============================================================================
rem ============================================================================

:findProgram64
    set "bit=64"
    set "start="

    set dirs=                                  ^
        eDIR_WORKSPACE\programs\x64\mingw-w64; ^
        eDIR_WORKSPACE\programs\x64\winlibs;   ^
        eDIR_LONG1\programs\x64\mingw-w64;     ^
        eDIR_LONG1\programs\x64\winlibs;       ^
        eDIR_LONG2\programs\x64\mingw-w64;     ^
        eDIR_LONG2\programs\x64\winlibs;       ^
        eDIR_LONG3\programs\x64\mingw-w64;     ^
        eDIR_LONG3\programs\x64\winlibs;       ^
        C:\Program Files;                      ^
        C:\TDM-GCC-64

    set "scan_symptoms=mingw*;*rev*;*posix*;*seh*;*dwarf*;bin"
    for /f "usebackq tokens=* delims=" %%a in (
        `find_in.exe "--start: %dirs%" "--S: %scan_symptoms%" "--F: gcc.exe"`
    ) do (
        call :checkMingw "%%~a"
    )
    rem @echo [x64] done!
exit /b

:findProgram32
    set "bit=32"
    set "start="

    set dirs=                                  ^
        eDIR_WORKSPACE\programs\x86\mingw-w64; ^
        eDIR_WORKSPACE\programs\x86\winlibs;   ^
        eDIR_LONG1\programs\x86\mingw-w64;     ^
        eDIR_LONG1\programs\x86\winlibs;       ^
        eDIR_LONG2\programs\x86\mingw-w64;     ^
        eDIR_LONG2\programs\x86\winlibs;       ^
        eDIR_LONG3\programs\x86\mingw-w64;     ^
        eDIR_LONG3\programs\x86\winlibs;       ^
        C:\Program Files (x86)\mingw-w64;      ^
        C:\TDM-GCC-32

    set "scan_symptoms=mingw*;*rev*;*posix*;*seh*;*dwarf*;bin"
    for /f "usebackq tokens=* delims=" %%a in (
        `find_in.exe "--start: %dirs%" "--S: %scan_symptoms%" "--F: gcc.exe" "--exe32"`
    ) do (
        call :checkMingw "%%~a"
    )
exit /b

:findProgram32Only
    set "bit=32"
    set "start="

    set dirs=                                  ^
        eDIR_WORKSPACE\programs\x86\mingw-w64; ^
        eDIR_WORKSPACE\programs\x86\winlibs;   ^
        eDIR_LONG\programs\x86\mingw-w64;     ^
        eDIR_LONG\programs\x86\winlibs;       ^
        C:\Program Files\mingw-w64;            ^
        C:\TDM-GCC-32

    set "scan_symptoms=mingw*;*rev*;*posix*;*seh*;*dwarf*;bin"
    for /f "usebackq tokens=* delims=" %%a in (
        `find_in.exe "--start: %dirs%" "--S: %scan_symptoms%" "--F: gcc.exe" "--exe32"`
    ) do (
        call :checkMingw "%%~a"
    )
exit /b

rem ============================================================================
rem ============================================================================

:checkMingw
    rem @echo [checkMingw] %~1

    for /F "tokens=1,2,3 delims=.-" %%i in ('"%~1" -dumpversion') do (
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

    if not defined eDIR_COMMANDS (
        if exist "%eDIR_WORKSPACE%\scripts\cmd" (
            set "eDIR_COMMANDS=%eDIR_WORKSPACE%\scripts\cmd"
        ) else (
            call :normalize eDIR_COMMANDS "%~dp0..\..\..\cmd"
        )
    )

    if not exist "%eDIR_COMMANDS%\find_in.exe" (
        @echo [ERROR] 'cmd\find_in' not found
        exit /b 1
    )

exit /b

:normalize
    if defined %~1 (exit /b)
    set "%~1=%~dpfn2"
exit /b

rem ============================================================================
rem ============================================================================

