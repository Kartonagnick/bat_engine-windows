
@echo off
call :checkParent
if errorlevel 1 (exit /b 1)
rem ============================================================================
rem ============================================================================

:main
    setlocal
    set "filename=%~1"
    if not defined filename (
        call :createFile "%~dp0_cache.bat"
        if errorlevel 1 (exit /b)
    )
    call "%~dp0private\find.bat"

    call :saveVariables
    call :saveInfo 32
    call :saveInfo 64

    endlocal & (
        set "VS170COMNTOOLS=%VS170COMNTOOLS%"
        set "VS160COMNTOOLS=%VS160COMNTOOLS%"
        set "VS150COMNTOOLS=%VS150COMNTOOLS%"
        set "VS140COMNTOOLS=%VS140COMNTOOLS%"
        set "VS120COMNTOOLS=%VS120COMNTOOLS%"
        set "VS110COMNTOOLS=%VS110COMNTOOLS%"
        set "VS100COMNTOOLS=%VS100COMNTOOLS%"
        set "VS90COMNTOOLS=%VS90COMNTOOLS%"

        set "eMSVC2022_32=%eMSVC2022_32%"
        set "eMSVC2019_32=%eMSVC2019_32%"
        set "eMSVC2017_32=%eMSVC2017_32%"
        set "eMSVC2015_32=%eMSVC2015_32%"
        set "eMSVC2013_32=%eMSVC2013_32%"
        set "eMSVC2012_32=%eMSVC2012_32%"
        set "eMSVC2010_32=%eMSVC2010_32%"
        set "eMSVC2008_32=%eMSVC2008_32%"

        set "eMSVC2022_64=%eMSVC2019_22%"
        set "eMSVC2019_64=%eMSVC2019_64%"
        set "eMSVC2017_64=%eMSVC2017_64%"
        set "eMSVC2015_64=%eMSVC2015_64%"
        set "eMSVC2013_64=%eMSVC2013_64%"
        set "eMSVC2012_64=%eMSVC2012_64%"
        set "eMSVC2010_64=%eMSVC2010_64%"
        set "eMSVC2008_64=%eMSVC2008_64%"

        set "eMSVC_32_VERSIONS=%eMSVC_32_VERSIONS%"
        set "eMSVC_64_VERSIONS=%eMSVC_64_VERSIONS%"
        set "eMSVC_32_LAST=%eMSVC_32_LAST%"     
        set "eMSVC_64_LAST=%eMSVC_64_LAST%"     
    ) 

exit /b

:createFile
    set "filename=%~1"
    if not exist "%filename%\.." (mkdir "%filename%\.." >nul 2>nul)
    @echo. > "%filename%"
    if errorlevel 1 (
        @echo [ERROR] can not create: '%filename%'
        exit /b 1
    )
exit /b

rem ============================================================================
rem ============================================================================

:saveVariables
    call :saveVariable "VS170COMNTOOLS" "2022"
    call :saveVariable "VS160COMNTOOLS" "2019"
    call :saveVariable "VS150COMNTOOLS" "2017"
    call :saveVariable "VS140COMNTOOLS" "2015"
    call :saveVariable "VS120COMNTOOLS" "2013"
    call :saveVariable "VS110COMNTOOLS" "2012"
    call :saveVariable "VS100COMNTOOLS" "2010"
    call :saveVariable "VS90COMNTOOLS"  "2008"
exit /b

:saveVariable
    rem %~1 - variable. example: VS160COMNTOOLS
    rem %~2 - version. example: 2019
    call set "value=%%%~1%%"
    if defined %~1 (
        @echo set "%~1=%value%" >> "%filename%"
    )
exit /b

rem ============================================================================
rem ============================================================================

:saveMSVCInit
    call set "value=%%eMSVC%~1_%~2%%"
    @echo set "eMSVC%~1_%~2=%value%" >> "%filename%"
exit /b

:saveInfo
    rem %~1 bit
    if not defined eMSVC_%~1_VERSIONS (
        @echo [WARNING] 'eMSVC_%~1_VERSIONS' not defined
        exit /b
    )

    @echo. >> "%filename%"
    call :saveSepparator
    @echo. >> "%filename%"

    call set "versions=%%eMSVC_%~1_VERSIONS%%"
    call set "last=%%eMSVC_%~1_LAST%%"

    @echo set "eMSVC_%~1_VERSIONS=%versions%" >> "%filename%"
    @echo set "eMSVC_%~1_LAST=%last%" >> "%filename%"
    @echo. >> "%filename%"
    for %%a in (%versions%) do (call :saveMSVCInit "%%~a" %~1)
exit /b

rem ============================================================================
rem ============================================================================

:saveSepparator
    @echo rem ............................................................................ >> "%filename%"
exit /b

rem ============================================================================
rem ============================================================================

:checkParent
    if errorlevel 1 (
        @echo [ERROR] was broken at launch
        exit /b 1
    )
    if not defined eDIR_OWNER (
        @echo off
        cls
        @echo.
        @echo.
        @echo [UPDATE] MSVC
    )
exit /b 0

rem ============================================================================
rem ============================================================================
