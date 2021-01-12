@echo off & cls & @echo. & @echo.

@echo [START] please wait...
rem call "%~dp0make.bat" > "%~dp0log.txt" 2>&1
call "%~dp0make-full.bat" > "%~dp0log.txt" 2>&1
@echo [DONE]
rem ============================================================================
rem ============================================================================
