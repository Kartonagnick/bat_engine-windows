@echo off
call :checkParent
if errorlevel 1 (exit /b 1)

rem 1  if argument is 'QtCreator' ------> run\run-mingw.bat
rem 2  if argument is 'mingw' ----------> run\run-mingw.bat
rem 3  if argument is 'VisualStudio' ---> request 'msvc'
rem 2  request configurations
rem 3  recursieve loop "run\run-%eCOMPILER_TAG%.bat"

rem ============================================================================
rem ============================================================================
:main
    @echo [RUN] %eCOMMAND%: %eARGUMENT%

    if "%eARGUMENT%" == "QtCreator" (
        call "%~dp0run\run-mingw.bat"
        if errorlevel 1 (goto :failed)
        goto :success
    )
    if "%eARGUMENT%" == "mingw" (
        call "%~dp0run\run-mingw.bat"
        if errorlevel 1 (goto :failed)
        goto :success
    )

    if "%eARGUMENT%" == "VisualStudio" (
        call :runVisualStudio
        if errorlevel 1 (goto :failed)
        goto :success
    )

    if "%eARGUMENT%" == "msvc" (
        call :runVisualStudio
        if errorlevel 1 (goto :failed)
        goto :success
    )

    @echo [ERROR] unknown runner: '%eARGUMENT%'
    goto :failed
:success
    @echo [RUN] completed successfully
exit /b 0

:failed
    @echo [RUN] finished with erros
exit /b 1

rem ============================================================================
rem ============================================================================

:runVisualStudio
    if not defined eCONFIGURATIONS (
        set "eCONFIGURATIONS=%eARGUMENT%"
    )

    call "%~dp0cmake\ajust.bat"
    if errorlevel 1 (exit /b)

    call "%~dp0loop.bat" "run\run-msvc" 
exit /b

rem ============================================================================
rem ============================================================================

:checkParent
    if errorlevel 1 (
        @echo [ERROR] was broken at launch
        exit /b 1
    )
    if not defined eDIR_OWNER (
        @echo off
        @echo [ERROR] should be run from under the parent batch file
        exit /b 1
    )
exit /b

rem ============================================================================
rem ============================================================================

