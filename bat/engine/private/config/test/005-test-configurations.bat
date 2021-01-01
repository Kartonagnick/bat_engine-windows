@echo off
cls

@echo.
@echo.

set "eDIR_OWNER=%~dp0"
set "ePATH_BAT_SCRIPTS=%~dp0..\..\..\.."
set "viewVariables=%ePATH_BAT_SCRIPTS%\tools\view_variables.bat"
rem ============================================================================
rem ============================================================================

call "%~dp0..\configurations.bat" ^
    "eBUILD_CONFIGURATIONS" ^
    "    " 

if errorlevel 1 (@echo [FAILED] & exit /b 1)

@echo [build configurations]
call "%viewVariables%" eBUILD_CONFIGURATIONS
@echo [SUCCESS]
set ePATH_BAT_SCRIPTS=
set viewVariables=

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
rem ............................................................................
