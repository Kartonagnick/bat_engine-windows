@echo off
rem ============================================================================
rem ============================================================================

:main
    rem %~1 source-text
    rem %~2 dst-variable
    if not defined eEXPAND_VARIABLES (call :init)
    call :formatString "e" "%~1" "%eEXPAND_VARIABLES%" "%~2"
exit /b

rem ============================================================================
rem ============================================================================

:init
    set "exp1=DIR_WORKSPACE DIR_SOURCES DIR_PROJECT DIR_BUILD DIR_PRODUCT NAME_PROJECT"
    set "exp2=TARGET_NAME TARGET_TYPE COMPILER_TAG BUILD_TYPE ADDRESS_MODEL RUNTIME_CPP"
    set "eEXPAND_VARIABLES=%exp1% %exp2%"
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
    set "src_text=%src_text:/=\%"
    endlocal & set "%var_output%=%src_text%"
exit /b

:expandValue
    call set "value=%%e%~1%%"
    call set "src_text=%%src_text:{%~1}=%value%%%"
exit /b

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

