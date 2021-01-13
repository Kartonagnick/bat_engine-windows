@echo off & cls & @echo. & @echo.

@echo [START] please wait...
call "%~dp0make.bat" > "%~dp0log.txt" 2>&1
rem call "%~dp0make-full.bat" > "%~dp0log.txt" 2>&1
@echo [DONE]

rem ============================================================================
rem ============================================================================
