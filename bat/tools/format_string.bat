@echo off
cls
@echo.
@echo.

rem example expand format_string

rem ============================================================================
rem ============================================================================

:main
    set "eTARGET_TYPE=lib"
    set "eBUILD_TYPE=release"
    set "eADDRESS_MODEL=32"
    set "eRUNTIME_CPP=dynamic"
    set "eTARGET_NAME=example"

    set "eSUFFIX=plugins/{TARGET_TYPE}-{BUILD_TYPE}-{ADDRESS_MODEL}-{RUNTIME_CPP}/{TARGET_NAME}/additional" 

    set "eEXPAND_VARIABLES=TARGET_NAME TARGET_TYPE BUILD_TYPE ADDRESS_MODEL RUNTIME_CPP"

    rem documentation:
    rem   - prefix for variables
    rem   - format string 
    rem   - list of variables to replace
    rem   - name of output variable
    call :format_string "e" "%eSUFFIX%" "%eEXPAND_VARIABLES%" "eOUTPUT"

    @echo.
    @echo [eOUTPUT] ... "%eOUTPUT%"
exit /b

rem ============================================================================
rem ============================================================================

:format_string
    setlocal
    set "prefix=%~1"
    set "src_text=%~2"
    set "var_collection=%~3"
    set "var_output=%~4"

    for %%a in (%var_collection%) do (
        if defined %prefix%%%~a (
            call :expand_value %%~a
        ) else (
            call :expand_empty %%~a
        )
    )
    endlocal & set "%var_output%=%src_text%"
exit /b

rem .........................................................................

:expand_value
    call set "value=%%e%~1%%"
    call set "src_text=%%src_text:{%~1}=%value%%%"
exit /b

rem .........................................................................

:expand_empty
    call set "src_text=%%src_text:-{%~1}=%%"
    call set "src_text=%%src_text:.{%~1}=%%"
    call set "src_text=%%src_text:{%~1}-=%%"
    call set "src_text=%%src_text:{%~1}.=%%"

    call set "src_text=%%src_text:/{%~1}/=/%%"
    call set "src_text=%%src_text:/{%~1}=/%%"
    call set "src_text=%%src_text:{%~1}=%%"
exit /b

rem .........................................................................


