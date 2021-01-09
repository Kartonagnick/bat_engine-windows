
rem ============================================================================
rem ============================================================================

:toLower
    set "VARIABLE_NAME="
    set "VARIABLE_VALUE="
    for /F "tokens=1,*" %%a in ("%*") do (
        set "VARIABLE_NAME=%%a"
        set "VARIABLE_VALUE=%%b"
    )
    if not defined VARIABLE_NAME (
        @echo [ERROR] 'VARIABLE_NAME' not defined
        goto :toLowerFailed
    )
    if not defined VARIABLE_VALUE (
        set "VARIABLE_VALUE=" 
        goto :toLowerSuccess
    )
    for %%j in ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i"
                "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r"
                "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z") do (
        call set "VARIABLE_VALUE=%%VARIABLE_VALUE:%%~j%%"
    )
:toLowerSuccess
    set "%VARIABLE_NAME%=%VARIABLE_VALUE%"
    set "VARIABLE_VALUE="
    set "VARIABLE_NAME="
exit /b
:toLowerFailed
    set "VARIABLE_VALUE="
    set "VARIABLE_NAME="
exit /b 1

rem ============================================================================
rem ============================================================================

:toLowerEx 
    set "VARIABLE_NAME=%~1"
    call set "VARIABLE_VALUE=%%%VARIABLE_NAME%%%"
    call :toLower %VARIABLE_NAME% %VARIABLE_VALUE% 
exit /b

rem ============================================================================
rem ============================================================================

