@echo off & call :checkParent
if errorlevel 1 (exit /b 1)

rem [2022-12m-31][19:00:00] 003 Kartonagnick    
rem [2022-12m-17][19:00:00] 002 Kartonagnick
rem [2022-09m-09][19:00:00] 001 Kartonagnick
rem ============================================================================
rem ============================================================================

:main
  setlocal
  call :setDepth
  set "version=v0.0.3    "
  set "title=Backup"

::set "eDEBUG=ON"
::set "eTRACE=ON"
::set "eSTYLE=typical"
  set "eSTYLE=classic"

  call :view [%title%] run... %version%

  call :viewDebug1 --1-- find WorkSpace...
  call :initWorkspace || call :workSpaceNotFound

::call :viewDebug1 --2-- find git...
::call :initGit  || call :gitNotFound

  call :viewDebug1 --2-- find 7z...
  call :init7z  || goto :failed

  call :viewDebug1 --3-- init params...
  call :initParams || goto :failed

  call :viewDebug1 --4-- make archive...
  call :makeArchive || goto :failed

:success
  call :view [%title%] completed successfully
exit /b 0

:failed
  call :view [%title%] finished with erros
exit /b 1

rem ============================================================================
rem ============================================================================

:makeExcludeList
  set "excludeMasks=%~1"
  set "excludeList="
:loopMakeExcludeList
  for /f "tokens=1* delims=; " %%g in ("%excludeMasks%") do (
    set "excludeMasks=%%~h"
    set "excludeList=%excludeList% -xr!%%g"
  )
  if defined excludeMasks goto :loopMakeExcludeList
exit /b

:showParams
  if not defined eTRACE (exit /b)
::call :viewDebug2 [exc] %excludeList%
  call :viewDebug2 [src] %eDIR_SRC%
  call :viewDebug2 [dst] %eDIR_DST%
  call :viewDebug2 [arc] %eNAME_ARCHIVE%.7z
exit /b

:setClassic
  set "src=%eDIR_SRC%\*"
exit /b

:setTypecal
  set "src=%eDIR_SRC%"
exit /b

:makeArchive
  set "exc=ipch; .vs; *VC.db; *.VC.opendb; *.sdf; .svn; _backup" 
  call :makeExcludeList "%exc%"
  call :showParams

  if "%eSTYLE%" == "classic" (
    call :setClassic
  ) else (
    call :setTypecal
  )

  7z.exe a -y -t7z -ssw -mx9        ^
    "-mmt=%NUMBER_OF_PROCESSORS%"   ^
    %excludeList%                   ^
    "%eDIR_DST%\%eNAME_ARCHIVE%.7z" ^
    "%src%" 
exit /b

rem ============================================================================
rem ============================================================================

:applyFile
  echo %~n1|findstr /r /c:"^_.*" >nul && (exit /b)
  set "eNAME_ARCHIVE=%~n1"
  set "eFILE_VERSION=%~1"
exit /b

:getVersionFile
  set "eNAME_ARCHIVE="
  set "eFILE_VERSION="
  for %%a in ("%eDIR_SRC%\*.ver") do (call :applyFile "%%~a") 
  if defined eNAME_ARCHIVE (exit /b)
  call :setName eNAME_ARCHIVE "%eDIR_SRC%"
exit /b

:setName1
  set "eNAME_ARCHIVE=%eNAME_ARCHIVE%-%eSTAMP%-%eVERSION_NUM%"
exit /b

:setName2
  set "eNAME_ARCHIVE=%eNAME_ARCHIVE%-%eSTAMP%"
exit /b

:initParams
  if not defined eSTYLE (set "eSTYLE=classic")
  call :dateTime "eSTAMP"
  call :normalizeD "eDIR_SRC"  "%~dp0."
  call :normalizeD "eDIR_DST"  "%~dp0_backup"
  call :getVersionFile
  call :getVersion || exit /b 1

  if defined eFILE_VERSION (
    call :setName1
  ) else (
    call :setName2
  )

  if not defined eDEBUG (exit /b)
  call :viewDebug2 TIMESTAMP : %eSTAMP% 
  call :viewDebug2 ARCHIVE   : %eNAME_ARCHIVE%.7z
  call :viewDebug2 DIR_SRC   : %eDIR_SRC%
  call :viewDebug2 DIR_DST   : %eDIR_DST%

  if not defined eTRACE (exit /b)
  call :viewDebug2 F_VERSION : %eFILE_VERSION%
  call :viewDebug2 VERSION   : %eVERSION_TXT% 
  call :viewDebug2 VERSION   : %eVERSION_NUM% 
  call :viewDebug2 STYLE     : %eSTYLE%
exit /b

:getVersion
  if not exist "%eFILE_VERSION%" (
    set "eVERSION_TXT=0.0.0"
    set "eVERSION_NUM=000"
    exit /b
  )
  set "major=0"
  set "minor=0"
  set "patch=0"
  for /F "tokens=*" %%a in ('findstr /rc:".*_MAJOR" "%eFILE_VERSION%"') do (call :tag major %%a)
  for /F "tokens=*" %%a in ('findstr /rc:".*_MINOR" "%eFILE_VERSION%"') do (call :tag minor %%a)
  for /F "tokens=*" %%a in ('findstr /rc:".*_PATCH" "%eFILE_VERSION%"') do (call :tag patch %%a)
  set "eVERSION_TXT=%major%.%minor%.%patch%"
  set "eVERSION_NUM=%major%%minor%%patch%"
exit /b 0

:tag
  for /F "tokens=1,*" %%a in ("%*") do (
    set "tag=%%a" 
    call :expand %%b
  )
exit /b

:expand
  set "v=%*"
  set v=%v:"=%
  set "v=%v:set=%"
  set "v=%v:(=%"
  set "v=%v:)=%"
  for %%a in (%v%) do (call :apply %%a)
exit /b

:apply
  if 1%1 EQU +1%1 (set "%tag%=%1")
exit /b

rem ............................................................................

:initWorkspace
 (call :findWorkspace) || (call :findWorkspace "C:\workspace") || (exit /b 1)
  call :viewDebug2 found: %eDIR_WORKSPACE%
exit /b

:workSpaceNotFound
  call :viewDebug2 WorkSpace: not found
exit /b 0

rem ............................................................................

:initGit32
  set "dir[0]=C:\Program Files\Git\bin"
  set "dir[1]=C:\Program Files\SmartGit\git\bin"
  if defined eDIR_WORKSPACE (
    set "dir[2]=%eDIR_WORKSPACE%\programs\x32\Git\bin"
    set "dir[3]=%eDIR_WORKSPACE%\programs\x32\SmartGit\git\bin" 
  )
exit /b

:initGit64
  set "dir[0]=C:\Program Files\Git\bin"
  set "dir[1]=C:\Program Files\SmartGit\git\bin"
  if defined eDIR_WORKSPACE (
    set "dir[2]=%eDIR_WORKSPACE%\programs\x64\Git\bin"
    set "dir[3]=%eDIR_WORKSPACE%\programs\x64\SmartGit\git\bin" 
  )
  set "dir[4]=C:\Program Files (x86)\Git\bin"
  set "dir[5]=C:\Program Files (x86)\SmartGit\git\bin"

  if defined eDIR_WORKSPACE (
    set "dir[6]=%eDIR_WORKSPACE%\programs\x86\Git\bin"
    set "dir[7]=%eDIR_WORKSPACE%\programs\x86\SmartGit\git\bin" 
  )
exit /b

:initGit
  setlocal
  if defined ProgramFiles(x86) (call :initGit64) else (call :initGit32)
 (call :findProgram "git.exe" "eDIR_GIT") || (exit /b 1)
  call :viewDebug2 found: %eDIR_GIT%
  set "PATH=%PATH%;%eDIR_GIT%"
  endlocal & (
    set "eDIR_GIT=%eDIR_GIT%"
    set "PATH=%PATH%"
  )
exit /b

:gitNotFound
  call :viewDebug2 git: not found
exit /b 0

rem ............................................................................

:init7z32
  set "dir[0]=C:\Program Files\7-Zip"
  if not defined eDIR_WORKSPACE (exit /b)
  set "dir[1]=%eDIR_WORKSPACE%\programs\x32\7-Zip"
exit /b

:init7z64-1
  set "dir[0]=C:\Program Files\7-Zip"
  set "dir[1]=%eDIR_WORKSPACE%\programs\x64\7-Zip"
  set "dir[2]=C:\Program Files (x86)\7-Zip"
  set "dir[3]=%eDIR_WORKSPACE%\programs\x86\7-Zip"
exit /b

:init7z64-2
  set "dir[0]=C:\Program Files\7-Zip"
  set "dir[2]=C:\Program Files (x86)\7-Zip"
exit /b

:init7z64
  if defined eDIR_WORKSPACE (
    call :init7z64-1
  ) else (
    call :init7z64-2
  )
exit /b

:init7z
  setlocal
  if defined ProgramFiles(x86) (call :init7z64) else (call :init7z32)
 (call :findProgram "7z.exe" "eDIR_7Z") || (exit /b 1)
  call :viewDebug2 found: %eDIR_7Z%
  set "PATH=%PATH%;%eDIR_7Z%"
  endlocal & (
    set "eDIR_7Z=%eDIR_7Z%"
    set "PATH=%PATH%"
  )
exit /b

rem ============================================================================
rem ============================================================================

:checkExist
::call :viewDebug3 check: %~1\%~2
  if not exist "%~1\%~2" (exit /b 1)
  call :normalizeD "%~3" "%~1"
exit /b 0

:findProgram
  set "var=%~3"
  if not defined var (set "var=dir")
  for /F "usebackq tokens=2 delims==" %%a in (`set "%var%[" 2^>nul`) do (
    call :checkExist "%%~a" "%~1" "%~2" && exit /b 
  )
  call :view1 [ERROR] not found: %~1
exit /b 1

rem ============================================================================
rem ============================================================================

:findWorkspace
  if defined eDIR_WORKSPACE (exit /b)
  if not defined eWORKSPACE_SYMPTOMS (
    set "eWORKSPACE_SYMPTOMS=3rd_party;programs"
  ) 
  setlocal
  set "dir_start=%~1"
  if not defined dir_start (set "dir_start=%CD%")
  if not exist "%dir_start%" (goto :findWorkspaceFailed)
  set "DRIVE=%dir_start:~0,3%"
  pushd "%dir_start%" 
:loopFindWorkspace
  call :checkWorkspaceSymptoms
  if not errorlevel 1    (goto :findWorkspaceSuccess)
  if "%DRIVE%" == "%CD%" (goto :findWorkspaceFailed )
  cd ..
  goto :loopFindWorkspace
exit /b

:findWorkspaceSuccess
  endlocal & set "eDIR_WORKSPACE=%CD%"
  popd
exit /b 0

:findWorkspaceFailed
  popd
exit /b 1

rem ............................................................................

:checkWorkspaceSymptoms
  set "enumerator=%eWORKSPACE_SYMPTOMS%"
:loopWorkspaceSymptoms
  for /F "tokens=1* delims=;" %%a in ("%enumerator%") do (
    for /F "tokens=*" %%a in ("%%a") do (
      if not exist "%CD%\%%a" exit /b 1
    )
    set "enumerator=%%b"
  )
  if defined enumerator goto :loopWorkspaceSymptoms
exit /b 

rem ============================================================================
rem ============================================================================

:dateTime
  rem %~1 variable name 

  setlocal
  for /f %%a in ('WMIC OS GET LocalDateTime ^| find "."') do (set "DTS=%%~a")
  if errorlevel 1 (@echo [ERROR] 'WMIC' finished with error & exit /b 1)

  set "YY=%DTS:~0,4%"
  set "MM=%DTS:~4,2%"
  set "DD=%DTS:~6,2%"

  set "HH=%DTS:~8,2%"
  set "MIN=%DTS:~10,2%"
  set "SS=%DTS:~12,2%"
::set "MS=%DTS:~15,3%"

  set "curDate=%YY%-%MM%m-%DD%"
  set "curTime=%HH%h-%MIN%m"
  set "curDateTime=[%curDate%][%curTime%]"
  endlocal & set "%~1=%curDateTime%"
exit /b 

rem ============================================================================
rem ============================================================================

:setDepth
  if defined eINDENT (set /a "eINDENT+=1") else (set "eINDENT=0")
  set "eDEEP0="
  for /l %%i in (1, 1, %eINDENT%) do (
    call set "eDEEP0=  %%eDEEP0%%"
  )
  set "eDEEP1=  %eDEEP0%"
  set "eDEEP2=  %eDEEP1%"
  set "eDEEP3=  %eDEEP2%"
exit /b

:view
  @echo %eDEEP0%%*
exit /b

:view1
  @echo %eDEEP1%%*
exit /b

:view2
  @echo %eDEEP2%%*
exit /b

:viewDebug1
  if not defined eDEBUG (exit /b)
  @echo %eDEEP1%%*
exit /b

:viewDebug2
  if not defined eDEBUG (exit /b)
  @echo %eDEEP2%%*
exit /b

:viewDebug3
  if not defined eDEBUG (exit /b)
  @echo %eDEEP3%%*
exit /b

rem ............................................................................

:trim
  for /F "tokens=1,*" %%a in ("%*") do (call set "%%a=%%b")
exit /b

:normalizeD
  set "%~1=%~dpfn2"
exit /b

:setName
  set "%~1=%~n2"
exit /b

:setValue
  if defined %~1 (exit /b)
  set "%~1=%~2"
exit /b

:setOwnerD
  if defined eDIR_OWNER (exit /b)
  @echo off & cls & @echo. & @echo.
  call :normalizeD eDIR_OWNER "%~dp0."
exit /b

:checkParent
  if errorlevel 1 (@echo [ERROR] was broken at launch & exit /b 1)
  call :setOwnerD
exit /b

rem ============================================================================
rem ============================================================================
