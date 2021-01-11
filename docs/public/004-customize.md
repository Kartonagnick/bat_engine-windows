
Кастомизация запуска cmake  
--------------------------

cmake может быть запущен двумя способами: по умолчанию, или кастомный.

По умолчанию выполняется обычный запуск cmake с параметрами,
которые настроенны для каждой конкретной конфигурации,
стандартным для движка способом.  
                                 
Но иногда бывает так, что cmake нужно запускать каким то особенным способом.
В этом случае на помощь приходит кастомизация.  

Идея заключается в том, что если в каталоге, откуда был запущен движок,
присутствует батник с определенным именем, 
то именно ему вручается задача по дальнейшему запуску cmake.
Таким образом, можно использовать разные батники,
в которых можно прописать разные способы запуска cmake.  

У любом сборки можно выделить 3 основных этапа:  
  - генерация MakeFiles.  
  - сборка MakeFiles.  
  - инсталяция.  

При запуске, батник-исполнитель получает два аргумента:  
  - собственно, название этапа сборки.  
  - название компилятора без указания версии:  
```
call "%eDIR_OWNER%\cmake.bat" "generate" "msvc"
call "%eDIR_OWNER%\cmake.bat" "build"    "msvc"
call "%eDIR_OWNER%\cmake.bat" "install"  "msvc"
```

По названию этапа, батник понимает что именно от него требуется.  
Название группы компиляторов опционально.  
Присылается батнику просто, 
что бы избавить его от необходимости вручную парсить `eCOMPILER_TAG`



## Алгоритм работы

1. В каталоге, где был запущен движок (`eDIR_OWNER`) 
осуществляется поиск любого из указанного ниже батника,
именно в том порядке, в котором он указан:
  - `cmake-{COMPILER}.bat`  
  - `cmake-{GROUP}.bat`  
  - `cmake.bat`  

2. Если какой либо из указанных выше батников будет обнаружен,
тогда именно он будет использован для запуска cmake.  

Примеры запуска батника-исполнителя:  
```
call "%eDIR_OWNER%\cmake.bat"          "generate" "msvc"
call "%eDIR_OWNER%\cmake.bat"          "generate" "mingw"
call "%eDIR_OWNER%\cmake-msvc.bat"     "generate" "msvc"
call "%eDIR_OWNER%\cmake-mingw.bat"    "generate" "mingw"
call "%eDIR_OWNER%\cmake-msvc2019.bat" "generate" "msvc"
```

3. В качестве аргументов такой батник-исполнитель получает:  
  - имя команды (generate/build/install)  
  - группу (имя компилятора без указания версии).  

4. Батник должен сгенерировать MakeFile для конфигурации заданной тэгами:  
  - `eCOMPILER_TAG`  - компилятор. Например: `msvc2019`.  
  - `eADDRESS_MODEL` - `32х` или `64х` битная сборка.  
  - `eBUILD_TYPE`    - тип сборки: `debug` или `release`.  
  - `eRUNTIME_CPP`   - способ линковки с рантайм с++: `dynamic` или `static`.  

5. Батник должен использовать `eEXPANDED_SUFFIX` 
при формировании окончательных путей на основе `eDIR_BUILD`, 
или `eDIR_PRODUCT`  

6. Батнику доступны любые управляющие переменные движка.  
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