
@echo off
cls

@echo.
@echo.

set "ePATH_BAT_SCRIPTS=%~dp0..\..\..\.."
set "viewVariables=%ePATH_BAT_SCRIPTS%\tools\view_variables.bat"
rem ============================================================================
rem ============================================================================

set order= ^
    msvc2015: release: 32: dynamic: none; ^
    msvc2017: release: 32: dynamic: none; ^
    mingw810: release: 32: dynamic: none

set support= ^
    msvc2015: release: 32: dynamic: none; ^
    msvc2017: release: 32: dynamic: none

call "%~dp0..\filtration.bat" "order" "support" "result"

call "%viewVariables%" " support:" "support"
@echo.
call "%viewVariables%" " order:" "order"
@echo.
call "%viewVariables%" " work:" "result"

@echo [SUCCESS]

set order=
set support=
set result=

@echo. > tmp_all_variables.txt
for /f "usebackq tokens=*" %%i in (`set`) do (
    @echo %%i >> tmp_all_variables.txt
)

set eEXAMPLE=333
@echo. > tmp_eVARIABLES.txt
for /f "usebackq tokens=*" %%i in (`set e`) do (
    @echo %%i >> tmp_eVARIABLES.txt
)

exit /b

rem ============================================================================
rem ============================================================================

