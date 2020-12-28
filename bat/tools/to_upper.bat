
rem ============================================================================
rem ============================================================================

:toUpper 
    set "VARIABLE_NAME="
    set "VARIABLE_VALUE="
    for /F "tokens=1,*" %%a in ("%*") do (
        set "VARIABLE_NAME=%%a"
        set "VARIABLE_VALUE=%%b"
    )
    if not defined VARIABLE_NAME (
        @echo [ERROR] 'VARIABLE_NAME' not defined
        goto :failedToUpper
    )
    if not defined VARIABLE_VALUE (
        set "VARIABLE_VALUE=" 
        goto :successToUpper
    )

    for %%j in ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I"
                "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R"
                "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z") do (
        call set "VARIABLE_VALUE=%%VARIABLE_VALUE:%%~j%%"
    )
:successToUpper
    set "%VARIABLE_NAME%=%VARIABLE_VALUE%"
    set "VARIABLE_VALUE="
    set "VARIABLE_NAME="
exit /b
:failedToUpper
    set "VARIABLE_VALUE="
    set "VARIABLE_NAME="
exit /b

rem ============================================================================
rem ============================================================================

:toUpperEx 
    set "VARIABLE_NAME=%~1"
    call set "VARIABLE_VALUE=%%%VARIABLE_NAME%%%"
    call :toUpper "%VARIABLE_VALUE%" "%VARIABLE_NAME%"
exit /b

rem ============================================================================
rem ============================================================================
