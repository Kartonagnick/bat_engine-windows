@echo off

:main 
    setlocal
    set "VARNAME=%~1"
    set "DESCRIPTION=%~2"
    set "ELEMENT=%~3"

    if not defined VARNAME (set "VARNAME=PATH")

    if not defined ELEMENT (
        set "ELEMENT=  #)"
        if not defined DESCRIPTION (set "DESCRIPTION=%VARNAME%")
    )

    if not "%ELEMENT%" == "~" (
        call :viewNormalized "%VARNAME%" "%DESCRIPTION%" "%ELEMENT%"
    ) else (
        call :viewNormalizedWE "%VARNAME%" "%DESCRIPTION%" "%ELEMENT%"
    )

exit /b
rem ============================================================================
rem ============================================================================

:viewElement
    call :trim value %~1
    call set "elem=%%ELEMENT:#=%index%%%"
    @echo %elem% %value%
exit /b

:viewNormalized
    setlocal
    set index=0
    set "VARNAME=%~1"
    set "DESCRIPTION=%~2"
    set "ELEMENT=%~3"
    if defined DESCRIPTION (
        if not "%DESCRIPTION%" == "~" (@echo %DESCRIPTION%)
    ) 
    call set "VARVAL=%%%VARNAME%%%"
    if not defined VARVAL (@echo -- 'no data' & exit /b)
:loopView
    set /a index=%index%+1
    for /F "tokens=1* delims=;" %%a in ("%VARVAL%") do (
        call :viewElement "%%~a"
        set "VARVAL=%%b"
    )
    if defined VARVAL (goto :loopView)
exit /b

:viewElement
    call :trim value %~1
    call set "elem=%%ELEMENT:#=%index%%%"
    @echo %elem% %value%
exit /b

rem ............................................................................

:viewElementWE
    call :trim value %~1
    @echo %value%
exit /b

:viewNormalizedWE
    setlocal
    set "VARNAME=%~1"
    set "DESCRIPTION=%~2"
    if defined DESCRIPTION (
        if not "%DESCRIPTION%" == "~" (@echo %DESCRIPTION%)
    ) 
    call set "VARVAL=%%%VARNAME%%%"
    if not defined VARVAL (@echo -- 'no data' & exit /b)
:loopViewWE
    for /F "tokens=1* delims=;" %%a in ("%VARVAL%") do (
        call :viewElementWE "%%~a"
        set "VARVAL=%%b"
    )
    if defined VARVAL (goto :loopViewWE)
exit /b

rem ============================================================================
rem ============================================================================

:trim
    for /F "tokens=1,*" %%a in ("%*") do (
        call set "%%a=%%b"
    )
exit /b 0

rem ============================================================================
rem ============================================================================
