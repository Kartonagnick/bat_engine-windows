@echo off
rem ============================================================================
rem ============================================================================

:main
    rem %~1 dst-variable
    rem %~2 source-text
    call :init
    call :formatString "e" "%~1" "%eEXPAND_VARIABLES%" "%~2"
exit /b

rem ============================================================================
rem ============================================================================

:init
    if defined eEXPAND_VARIABLES (exit /b)
    setlocal
    set "exp1=DIR_OWNER DIR_WORKSPACE DIR_SOURCE DIR_PROJECT DIR_BUILD DIR_PRODUCT NAME_PROJECT"
    set "exp2=VERSION TARGET_NAME TARGET_TYPE COMPILER_TAG BUILD_TYPE ADDRESS_MODEL RUNTIME_CPP"
    set "exp3=BUILD_ID"
    endlocal & set "eEXPAND_VARIABLES=%exp1% %exp2% %exp3%"
exit /b

:formatString
    setlocal
    set "prefix=%~1"
    set "var_output=%~2"
    set "var_collection=%~3"
    set "src_text=%~4"

    if not defined src_text (exit /b)

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

