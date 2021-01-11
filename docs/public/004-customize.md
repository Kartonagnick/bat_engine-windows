
Кастомизация запуска cmake  
--------------------------

В каталоге, где был запущен движок (`eDIR_OWNER`),
в порядке, в котором батники указанны ниже,
производится поиск любого из них:
  - `cmake-{COMPILER}.bat`  
  - `cmake-{GROUP}.bat`  
  - `cmake.bat`  


Если какой либо из указанных выше батников будет обнаружен,
тогда именно он будет использован для запуска cmake.  

Примеры запуска батника-исполнителя:  
```
call "%eDIR_OWNER%\cmake.bat"          "generate" "msvc"
call "%eDIR_OWNER%\cmake.bat"          "generate" "mingw"
call "%eDIR_OWNER%\cmake-msvc.bat"     "generate" "msvc"
call "%eDIR_OWNER%\cmake-mingw.bat"    "generate" "mingw"
call "%eDIR_OWNER%\cmake-msvc2019.bat" "generate" "msvc"
```

В качестве аргументов такой батник-исполнитель получает:  
  - имя команды (generate/build/install)  
  - группу (имя компилятора без указания версии).  

Батник должен сгенерировать MakeFile для конфигурации заданной тэгами:  
  - `eCOMPILER`      - компилятор. Например: `msvc2019`.  
  - `eADDRESS_MODEL` - `32х` или `64х` битная сборка.  
  - `eBUILD_TYPE`    - тип сборки: `debug` или `release`.  
  - `eRUNTIME_CPP`   - способ линковки с рантайм с++: `dynamic` или `static`.  

Батник должен использовать `eEXPANDED_SUFFIX` 
при формировании окончательных путей на основе `eDIR_BUILD`, 
или `eDIR_PRODUCT`  

Батникe доступны любые управляющие переменные.  
Такие как:  
  - `eDIR_BAT_SCRIPTS` - каталог скриптов на языке bat  
  - `eDIR_CMAKE_LIST` - каталог, где находится CMakeLists.txt  
  - и др.  

## Пример содержимого батника для msvc:

```
    if "%eADDRESS_MODEL%" == "64" (
        set "append=-A x64"
    ) else (
        set "append=-A Win32"
    )                            

    set "eDIR_BUILD=%eDIR_BUILD%\%eEXPANDED_SUFFIX%"

    cmake.exe ^
        -H"%eDIR_CMAKE_LIST%" ^
        -B"%eDIR_BUILD%"      ^
        -G"%eGENERATOR%"      ^
        -D"CMAKE_BUILD_TYPE=%eBUILD_TYPE%" ^
        %append%

    if errorlevel 1 (@echo [ERROR] 'cmake.exe' failed)
```

## Пример содержимого батника для mingw:

```
    call "%eDIR_BAT_SCRIPTS%\mingw\get_version.bat" ^
        "%eCOMPILER_TAG%" ^
        "%eADDRESS_MODEL%"

    if errorlevel 1 (
        @echo [ERROR] initialize 'mingw' failed
        exit /b 1
    )
    set "PATH=%eINIT_COMPILER%;%PATH%"

    set "eDIR_BUILD=%eDIR_BUILD%\%eEXPANDED_SUFFIX%"

    cmake.exe ^
        -H"%eDIR_CMAKE_LIST%" ^
        -B"%eDIR_BUILD%"      ^
        -G"%eGENERATOR%"      ^
        -D"CMAKE_BUILD_TYPE=%eBUILD_TYPE%"

    if errorlevel 1 (@echo [ERROR] 'cmake.exe' failed)
```