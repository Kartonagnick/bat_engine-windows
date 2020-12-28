@echo off
cls 
@echo.
@echo.

:main
    call :findRoot

    setlocal
    set "eEXPAND_VARIABLES=PATH_TO_WORKSPACE PATH_CMAKE_MODULE PATH_TO_SOURCES"

    set "ePATH_TO_WORKSPACE=C:\Users\idrisov.d\work\preliminary\workspace"
    set "ePATH_CMAKE_MODULE=C:\Users\idrisov.d\work\preliminary\workspace\scripts\cmake"
    set "ePATH_TO_SOURCES=C:\Users\idrisov.d\work\preliminary\workspace\projects\cmdenv"

    set "input=settings.cmake.in"
    set "output=settings.cmake"

    set "first="
    call :dataTime
    del /Q "%output%" >nul 2>nul
    for /f "usebackq tokens=*" %%i in ("%input%") do (
rem        @echo [line] "%%i"
        call :formatString "e" "%%~i" "%eEXPAND_VARIABLES%" "line"
        call :writeLine 
    )
    endlocal
exit /b

rem ============================================================================
rem ============================================================================

:writeLine 
rem    @echo [save] "%line%"

    if not defined first (
        set "line=# %genDataTime%. WorkSpace project."
        set "first=ON"
    )

    @echo %line% >> "%output%"
exit /b

:formatString
    setlocal
    set "prefix=%~1"
    set "src_text=%~2"
    set "var_collection=%~3"
    set "var_output=%~4"

    for %%a in (%var_collection%) do (
        if defined %prefix%%%~a (
            call :expandValue %%~a
        ) else (
            call :expandEmpty %%~a
        )
    )
    call set "src_text=%src_text:\=/%"
    endlocal & set "%var_output%=%src_text%"
exit /b

rem .........................................................................

:expandValue
    call set "value=%%e%~1%%"
    call set "src_text=%%src_text:{%~1}=%value%%%"
exit /b

rem .........................................................................

:expandEmpty
    call set "src_text=%%src_text:-{%~1}=%%"
    call set "src_text=%%src_text:.{%~1}=%%"
    call set "src_text=%%src_text:{%~1}-=%%"
    call set "src_text=%%src_text:{%~1}.=%%"

    call set "src_text=%%src_text:/{%~1}/=/%%"
    call set "src_text=%%src_text:/{%~1}=/%%"
    call set "src_text=%%src_text:{%~1}=%%"
exit /b

rem ============================================================================
rem ============================================================================

:dataTime
    setlocal
    for /f %%a in ('WMIC OS GET LocalDateTime ^| find "."') do (
        set DTS=%%a  
    )

    set YY=%DTS:~0,4%
    set MM=%DTS:~4,2%
    set DD=%DTS:~6,2%

    set HH=%DTS:~8,2%
    set MIN=%DTS:~10,2%
    set SS=%DTS:~12,2%
    set MS=%DTS:~15,3%

    set "curDate=%YY%y-%MM%m-%DD%d"
    set "curTime=%HH%h-%MIN%minuts"
    set "genDataTime=%curDate%_%curTime%"

    endlocal & set "genDataTime=%DD%.%MM%.%YY%"
exit /b 

rem ============================================================================
rem ============================================================================

:findRoot
    if defined ePATH_ROOT (exit /b)
    if not defined eROOT_SYMTHOMS (
        set "eROOT_SYMTHOMS=3rd_party;programs"
    ) 
    set "DRIVE=%CD:~0,3%"
    pushd "%CD%"
:loopFindRoot
    call :checkSymptomsFindRoot
    if errorlevel 1 (
        if "%DRIVE%" == "%CD%" goto :failedFindRoot
        cd ..
        goto :loopFindRoot
    ) ELSE (
        goto :successFindRoot
    )
exit /b

:successFindRoot
    set "ePATH_ROOT=%CD%"
    popd
exit /b 

:failedFindRoot
    popd
exit /b 1

rem ============================================================================
rem ============================================================================

:checkSymptomsFindRoot
    set "enumerator=%eROOT_SYMTHOMS%"
:loopCheckSymptoms
    for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
        for /F "tokens=*" %%a in ("%%a") do (
            if not exist "%CD%\%%a" exit /b 1
        )
        set "enumerator=%%b"
    )
    if defined enumerator goto :loopCheckSymptoms
exit /b 

rem ============================================================================
rem ============================================================================


