
@echo off
cls
@echo.
@echo.
rem ============================================================================
rem ============================================================================

:main
    setlocal

    set "PATH=%~dp0..\..\..\..\cmd; %PATH%"
    rem set m1=.git; .svn
    set m1=
    set m2=Release; release; release32; release64
    set m3=Debug; debug; debug32; debug64
    set m4=RelWithDebInfo; MinSizeRel
    set m5=.vs; *.suo; *.ncb; *.sdf; ipch; *.VC.db; *.aps
    set m6=_cache*.bat
    set mask=%m1%; %m1%; %m2%; %m3%; %m4%; %m5%; %m6%;

    set s1=_*
    set s2=google*; boost*; mingw* 
    set s3=external*; product*; programs; cmake*;
    set scan_exclude=%s1%; %s2%; %s3%

    garbage.exe                ^
        "-start: %~dp0."       ^
        "--mask: %mask%"       ^
        "--es: %scan_exclude%" ^
        "--debug" "--test"

exit /b

rem ============================================================================
rem ============================================================================

