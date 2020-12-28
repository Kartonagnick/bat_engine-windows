
rem ============================================================================
rem ============================================================================
setlocal
set "VARIABLE_NAME_SUB=%~1"
if defined %VARIABLE_NAME_SUB% (
    call set "VARIABLE_VALUE_SUB=;%%%VARIABLE_NAME_SUB%%%"
)
set "VARIABLE_NAME_BIG=%~2"
if defined %VARIABLE_NAME_BIG% (
     call set "VARIABLE_VALUE_BIG=;%%%VARIABLE_NAME_BIG%%%"
)
set "VARIABLE_NAME_RES=%~3"
set "VARIABLE_VALUE_RES="

call :synkArray 
endlocal & set "%VARIABLE_NAME_RES%=%VARIABLE_VALUE_RES%"
exit /b
rem ============================================================================
rem ============================================================================

:synkArray
    set "enumerator=%VARIABLE_VALUE_SUB%"
:loopSynkArray
    for /F "tokens=1* delims=;" %%g in ("%enumerator%") do (
        set "enumerator=%%h"
        for /F "tokens=*" %%g in ("%%g") do (
            call :processValue "%%g"
        )
    )
    if defined enumerator (goto :loopSynkArray)
rem ............................................................................
    set "front=%VARIABLE_VALUE_RES:~0,1%"
    if "%front%" == ";" (set "VARIABLE_VALUE_RES=%VARIABLE_VALUE_RES:~1%")

    set "front=%VARIABLE_VALUE_RES:~0,1%"
    if "%front%" == " " (set "VARIABLE_VALUE_RES=%VARIABLE_VALUE_RES:~1%")

exit /b

rem ============================================================================
rem ============================================================================

:processValue
    set "value=%~1"
    @echo %VARIABLE_VALUE_BIG% | >nul find/c "%value%" && (
        set "VARIABLE_VALUE_RES=%VARIABLE_VALUE_RES%; %value%"
    )
exit /b

rem ============================================================================
rem ============================================================================
