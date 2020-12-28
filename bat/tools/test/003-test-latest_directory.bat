
@echo off
cls

@echo.
@echo.

call "%~dp0..\latest_directory.bat" "%~dp0.."

call "%~dp0..\latest_directory.bat" "D:\workspace\program\x86\mingw-w64" CHECKED

@echo [LATEST_DIRECTORY] '%CHECKED%'
@echo [SUCCESS]
exit /b

rem ============================================================================
rem ============================================================================

