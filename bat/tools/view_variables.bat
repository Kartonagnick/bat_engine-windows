@echo off

setlocal
    set "DESCRIPTION=%~1"
    set "VARIABLE_NAME=%~2"

    if not defined VARIABLE_NAME (set "VARIABLE_NAME=PATH" )
    call set "VARIABLE_VALUE=%%%VARIABLE_NAME%%%"

    if not defined DESCRIPTION (
        call :tokenizeVariableWD
        exit /b
    )

    if "%DESCRIPTION%" == "#)" (
        call :tokenizeVariableWD
        exit /b
    )

rem ============================================================================
rem ============================================================================

:tokenizeVariableD
    if not defined %VARIABLE_NAME% (
        @echo %DESCRIPTION% 'no data' 
        exit /b 0
    )
    set "stringVariableValues=%VARIABLE_VALUE%"
:loopTokenizeVariableD
    for /F "tokens=1* delims=;" %%g in ("%stringVariableValues%") DO (
        for /F "tokens=*" %%g in ("%%g") do (
            @echo %DESCRIPTION% '%%g' 
        )
        set "stringVariableValues=%%h"
    )
    if defined stringVariableValues (goto :loopTokenizeVariableD)
endlocal
exit /b 0

rem ============================================================================
rem ============================================================================

:tokenizeVariableWD
    if not defined %VARIABLE_NAME% (
        @echo -- 'no data' 
        exit /b 0
    )
    set index=0
    set "stringVariableValues=%VARIABLE_VALUE%"
:loopTokenizeVariableWD
    set /a index=%index%+1
    for /F "tokens=1* delims=;" %%g in ("%stringVariableValues%") DO (
        for /F "tokens=*" %%g in ("%%g") do (
            @echo   %index%^) '%%g' 
        )
        set "stringVariableValues=%%h"
    )
    if defined stringVariableValues (goto :loopTokenizeVariableWD)
endlocal
exit /b 0

rem ============================================================================
rem ============================================================================
