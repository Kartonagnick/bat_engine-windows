@echo off
cls

@echo.
@echo.

set cfg= ^
    msvc2015: release: 32: dynamic: none; ^
    msvc2015: release: 32: static: none; ^
    msvc2017: release: 32: dynamic: none; ^
    mingw830: release: 32: static: none

call "%~dp0..\view_variables.bat" 
call "%~dp0..\view_variables.bat" cfg 
call "%~dp0..\view_variables.bat" cfg "configs" "-@ #)"
call "%~dp0..\view_variables.bat" cfg "configs" "-@)"
call "%~dp0..\view_variables.bat" cfg "configs" "~"

@echo. ###
call "%~dp0..\view_variables.bat" cfg "" " -- #)"
@echo. ***
call "%~dp0..\view_variables.bat" cfg "~" " -- #)"
@echo. +++
call "%~dp0..\view_variables.bat" cfg "  caption:" "    ...#)"

exit /b

rem ============================================================================
rem ============================================================================

