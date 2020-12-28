@echo off

rem ============================================================================
rem ============================================================================

set "SUBSTRING=%~1"
set "BIGSTRING=%~2"

if not defined SUBSTRING (set "SUBSTRING=hello")
if not defined BIGSTRING (set "BIGSTRING=hello world")

call set "CHECKSTRN=%%BIGSTRING:%SUBSTRING%=%%"

rem @echo [SUBSTRING] '%SUBSTRING%'
rem @echo [BIGSTRING] '%BIGSTRING%'
rem @echo [CHECKSTRN] '%CHECKSTRN%'

if "%CHECKSTRN%" == "%BIGSTRING%" (
rem    @echo [NOT]
    exit /b 1
)
rem @echo [YES]
exit /b 0

rem ============================================================================
rem ============================================================================

