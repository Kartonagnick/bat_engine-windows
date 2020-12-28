@echo off
cls

@echo.
@echo.
call "%~dp0..\view_variables.bat"
@echo [TEST] done

set "PATH32=C:MinGW;C:\ololo\bin"
@echo.
@echo.
call "%~dp0..\view_variables.bat" "[TOKEN]" "PATH32"
@echo [TEST] done

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

