
@echo off 
if defined ENGINE_SETTINGS_ALREADY_INITIALIZED (exit /b) 
set "ENGINE_SETTINGS_ALREADY_INITIALIZED=yes" 
 
rem ============================================================================
rem ============================================================================

:main
    @echo [SETTINGS] start ...
    set "main_settings=%~dp0_cache\settings_%computername%_%username%.bat"    

    if not exist "%main_settings%" (
        call "%~dp0update.bat" "%main_settings%" 
        if errorlevel 1 (goto failed)
    ) else (
        @echo   loading... done!
    )
    call "%main_settings%"
    if errorlevel 1 (goto failed)
:success
    @echo [SETTINGS] completed successfully
exit /b 0

:failed
    @echo [SETTINGS] finished with erros
exit /b 1

rem ============================================================================
rem ============================================================================

