@echo off
rem ============================================================================
rem ============================================================================

:main
    setlocal
    call :findAllVersions
    call :trim eMSVC_32_VERSIONS %eMSVC_32_VERSIONS%
    call :trim eMSVC_64_VERSIONS %eMSVC_64_VERSIONS%
    call :detectLast

    endlocal & (
        set "VS170COMNTOOLS=%VS170COMNTOOLS%"
        set "VS160COMNTOOLS=%VS160COMNTOOLS%"
        set "VS150COMNTOOLS=%VS150COMNTOOLS%"
        set "VS140COMNTOOLS=%VS140COMNTOOLS%"
        set "VS120COMNTOOLS=%VS120COMNTOOLS%"
        set "VS110COMNTOOLS=%VS110COMNTOOLS%"
        set "VS100COMNTOOLS=%VS100COMNTOOLS%"
        set "VS90COMNTOOLS=%VS90COMNTOOLS%"

        set "eMSVC2022_32=%eMSVC2022_32%"
        set "eMSVC2019_32=%eMSVC2019_32%"
        set "eMSVC2017_32=%eMSVC2017_32%"
        set "eMSVC2015_32=%eMSVC2015_32%"
        set "eMSVC2013_32=%eMSVC2013_32%"
        set "eMSVC2012_32=%eMSVC2012_32%"
        set "eMSVC2010_32=%eMSVC2010_32%"
        set "eMSVC2008_32=%eMSVC2008_32%"

        set "eMSVC2022_64=%eMSVC2022_64%"
        set "eMSVC2019_64=%eMSVC2019_64%"
        set "eMSVC2017_64=%eMSVC2017_64%"
        set "eMSVC2015_64=%eMSVC2015_64%"
        set "eMSVC2013_64=%eMSVC2013_64%"
        set "eMSVC2012_64=%eMSVC2012_64%"
        set "eMSVC2010_64=%eMSVC2010_64%"
        set "eMSVC2008_64=%eMSVC2008_64%"

        set "eMSVC_32_VERSIONS=%eMSVC_32_VERSIONS%"
        set "eMSVC_64_VERSIONS=%eMSVC_64_VERSIONS%"
        set "eMSVC_32_LAST=%eMSVC_32_LAST%"     
        set "eMSVC_64_LAST=%eMSVC_64_LAST%"     
    ) 
exit /b 0

rem ============================================================================
rem ============================================================================

:findAllVersions
    call :checkPressent "VS170COMNTOOLS" "2022"
    call :checkPressent "VS160COMNTOOLS" "2019"
    call :checkPressent "VS150COMNTOOLS" "2017"
    call :checkPressent "VS140COMNTOOLS" "2015"
    call :checkPressent "VS120COMNTOOLS" "2013"
    call :checkPressent "VS110COMNTOOLS" "2012"
    call :checkPressent "VS100COMNTOOLS" "2010"
    call :checkPressent "VS90COMNTOOLS"  "2008"
exit /b

rem ============================================================================
rem ============================================================================

:detectLast
    for /f "tokens=1" %%a in ("%eMSVC_32_VERSIONS%") do (
        set "eMSVC_32_LAST=%%a"
    )
    set "eMSVC_64_LAST=%eMSVC_32_LAST%"
exit /b

rem ============================================================================
rem ============================================================================

:checkPressent
    rem %~2 version

    set "VSCOMNTOOLS=%~1"
    set "version=%~2"

    if defined %VSCOMNTOOLS% (
        call :commitBase
        exit /b 0
    )

    if %version% gtr 2015 (
        set "initial=VsDevCmd.bat"
        call :checkNewVersions
        exit /b 0
    )

    set "initial=vsvars32.bat"

    if "%version%" == "2015" (
        (call :saveOldRecord32 "14.0") || (call :saveOldRecord64 "14.0")
        exit /b 0
    )
    if "%version%" == "2013" (
        (call :saveOldRecord32 "12.0") || (call :saveOldRecord64 "12.0")
        exit /b 0
    )
    if "%version%" == "2012" (
        (call :saveOldRecord32 "11.0") || (call :saveOldRecord64 "11.0")
        exit /b 0
    )
    if "%version%" == "2010" (
        (call :saveOldRecord32 "10.0") || (call :saveOldRecord64 "10.0")
        exit /b 0
    )
    if "%version%" == "2008" (
        (call :saveOldRecord32 "9.0") || (call :saveOldRecord64 "9.0")
        exit /b 0
    )

exit /b 0

:checkNewVersions

    (     call :saveNewRecord64 "Community" 
    ) || (call :saveNewRecord64 "Professional"  
    ) || (call :saveNewRecord64 "Enterprise"
    ) || (call :saveNewRecord64 "BuildTools"
    ) || (call :saveNewRecord64 "WDExpress"

    ) || (call :saveNewRecord32 "Community"
    ) || (call :saveNewRecord32 "Professional"
    ) || (call :saveNewRecord32 "Enterprise"
    ) || (call :saveNewRecord32 "BuildTools"
    ) || (call :saveNewRecord32 "WDExpress"
    )

exit /b 0

rem ============================================================================
rem ============================================================================

:commitBase
    set "versions=%versions% %version%"
    set "eMSVC_32_VERSIONS=%eMSVC_32_VERSIONS% %version%"
    set "eMSVC_64_VERSIONS=%eMSVC_64_VERSIONS% %version%"
    set "value=%%%VSCOMNTOOLS%%%%initial%"
    call set "eMSVC%version%_32=%value%"
    call set "eMSVC%version%_64=%value%"
exit /b 

:commit
    set "%VSCOMNTOOLS%=%value%\"
    call :commitBase
exit /b 

:saveOldRecord32
    set "token=C:\Program Files (x86)\Microsoft Visual Studio %~1"    
    call :saveOldRecord
exit /b 

:saveOldRecord64
    set "token=C:\Program Files\Microsoft Visual Studio %~1"    
    call :saveOldRecord
exit /b 

:saveOldRecord
    set "value=%token%\Common7\Tools"
    if not exist "%value%\%initial%" (exit /b 1)
    call :commit
exit /b 0

rem ............................................................................

:saveNewRecord32
    set "edition=%~1"
    set "token=C:\Program Files (x86)\Microsoft Visual Studio\%version%"    
    call :saveNewRecord
exit /b 

:saveNewRecord64
    set "edition=%~1"
    set "token=C:\Program Files\Microsoft Visual Studio\%version%"    
    call :saveNewRecord
exit /b 

:saveNewRecord
    set "value=%token%\%edition%\Common7\Tools"
    if not exist "%value%\%initial%" (exit /b 1)
    call :commit
exit /b 0

rem ............................................................................

:trim
    for /F "tokens=1,*" %%a in ("%*") do (
        call set "%%a=%%b"
    )
exit /b

rem ............................................................................
