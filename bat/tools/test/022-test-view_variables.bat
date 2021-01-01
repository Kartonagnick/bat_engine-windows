@echo off
cls

@echo.
@echo.

rem print empty line at the end

set cfg= ^
    msvc2015: release: 32: dynamic: none; ^


call "%~dp0..\view_variables.bat" cfg 

exit /b

rem ============================================================================
rem ============================================================================

