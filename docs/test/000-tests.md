
Тестирование функциональности
-----------------------------

[X1]: failed.png    "2021y-01m-11d"
[V1]: success.png   "2021y-01m-11d"

| **ID** | **Команды**            | **0.0.1**    |  
|:------:|:----------------------:|:------------:|  
|  0000  | [version][0]           | [![][V1]][0] |  
|  0001  | [update][1]            | [![][V1]][1] |  
|  0002  | [initial][2]           | [![][V1]][2] |  
|  0003  | [generate all][3]      | [![][V1]][3] |  
|  0010  | [build all][4]         | [![][V1]][4] |  
|  0020  | [install all][5]       | [![][V1]][5] |  
|  0021  | [install PREFIX-1][51] | [![][V1]][5] |  
|  0022  | [install PREFIX-2][52] | [![][V1]][5] |  
|  0030  | [run tests all][6]     | [![][V1]][6] |  
|  0040  | [run VisualStudio][7]  | [![][V1]][7] |  
|  0050  | [run Qtcreator][8]     |              |  

[0]:  #version              "должен распечатать версию движка в консоли"  
[1]:  #update               "обновление настроек движка"  
[2]:  #initial              "обновление запчастей движка"  
[3]:  #generate-all         "генерируем MakeFiles для всех конфигураций"  
[4]:  #build-all            "сборка всех конфигураций"  
[5]:  #install-all          "сбоорка и деплой всех конфигураций"  
[51]: #install-DIR_SOURCES  "сборка с префиксом: PREFIX={DIR_SOURCES}\deploy"  
[52]: #install-DIR_OWNER    "сборка с префиксом: PREFIX={DIR_OWNER}"  
[6]:  #run-tests-all        "запуск тестов для всех конфигураций"  
[7]:  #run-VisualStudio     "запуск Visual Studio 2019"  
[8]:  #run-QtCreator        "запуск QtCreator"  

## version
1. Заходим ы каталог: `eDIR_WORKSPACE/projects/cmdhello/deploy`  
2. Открываем файл: `make.bat`  
3. Исполняем: `call :runVersion`  

Ожидаемый результат:  
  - В консоле должен быть распечатан номер версии движка.  
  - Версия движка должна совпадать с актуальной.  


## update
1. Удаляем: `eDIR_BAT_ENGINE/_cache`  
2. Заходим: `eDIR_WORKSPACE/projects/cmdhello/deploy`  
3. Открываем: `make.bat`  
4. Исполняем: `call :runUpdate`  

Ожидаемый результат:  
  - В консоле мы должны увидеть лог обновления движка.  
  - Лог должен заканчиваться строками:
  ```
  [UPDATE] done!
  [ENGINE] completed successfully  
  ```
  - Должен появиться: `eDIR_BAT_ENGINE/_cache/settings_{USER}-{COMPUTER}.bat`  
    - Содержимое файла: актуальные настройки.  

## initial
1. Удаляем: `eDIR_BAT_ENGINE/_cache`  
2. Заходим: `eDIR_WORKSPACE/projects/cmdhello/deploy`  
3. Открываем: `make.bat`  
4. Исполняем: `call :runInitial`  

Ожидаемый результат:  
  - в консоле мы должны увидеть:  
    - лог обновления `Minimalist`.  
    - лог обновления `Cmd`.  
    - лог обновления движка.  
    - Лог должен заканчиваться строками:
    ```
    [UPDATE] done!
    [INITIAL] completed successfully
    [ENGINE] completed successfully         
    ```
  - Должен появиться: `eDIR_BAT_ENGINE/_cache/settings_{USER}-{COMPUTER}.bat`  
    - Содержимое файла: актуальные настройки.  
  - Должен появиться: `eDIR_BAT_ENGINE/_cache/cmake-minimalist`  
    - Содержимое каталога: [cmake-minimalist](https://github.com/Kartonagnick/cmake-minimalist "репозиторий")  
  - Должен появиться: `eDIR_BAT_ENGINE/_cache/cmd`  
    - Содержимое каталога: [cmake-minimalist](https://github.com/Kartonagnick/cmd-windows "репозиторий")  

## generate-all
1. в файле: `eDIR_WORKSPACE/projects/cmdhello/project.root`
   - выставляем: `INCLUDE_CONFIGURATIONS =`
   - выставляем: `EXCLUDE_CONFIGURATIONS =`
2. Заходим: `eDIR_WORKSPACE/projects/cmdhello/deploy`  
3. Открываем: `make.bat`  
4. Исполняем: `call :generateCmakeMakeFiles`  

Ожидаемый результат:  
  - лог должен заканчиваться строками:  
  ```
  [CMAKE] completed successfully
  [GENERATE] completed successfully
  [ENGINE] completed successfully
  ```
  - в каталоге: `eDIR_WORKSPACE/_build/cmdhello`  
    - должны присутствовать сборки всех конфигураций,
      для всех обнаруженных движком компиляторов.  

## build-all
1. в файле: `eDIR_WORKSPACE/projects/cmdhello/project.root`
   - выставляем: `INCLUDE_CONFIGURATIONS =`
   - выставляем: `EXCLUDE_CONFIGURATIONS =`
2. Заходим: `eDIR_WORKSPACE/projects/cmdhello/deploy`  
3. Открываем: `make.bat`  
4. Исполняем: `call :buildCmakeMakeFiles`  

Ожидаемый результат:  
  - лог должен заканчиваться строками:  
  ```
  [CMAKE] completed successfully
  [BUILD] completed successfully
  [ENGINE] completed successfully
  ```
  - в каталоге: `eDIR_WORKSPACE/_build/cmdhello`  
    - должны присутствовать сборки всех конфигураций,
      для всех обнаруженных движком компиляторов.  

  - в каталоге: `eDIR_WORKSPACE/_products/cmdhello`  
    - должны присутствовать результаты сборок всех конфигураций,
      для всех обнаруженных движком компиляторов.  

## install-all
1. в файле: `eDIR_WORKSPACE/projects/cmdhello/project.root`
   - выставляем: `INCLUDE_CONFIGURATIONS =`
   - выставляем: `EXCLUDE_CONFIGURATIONS =`
2. Заходим: `eDIR_WORKSPACE/projects/cmdhello/deploy`  
3. Открываем: `make.bat`  
4. Исполняем: `call :installCmakeMakeFiles`  

## install-DIR_SOURCES
1. в файле: `eDIR_WORKSPACE/projects/cmdhello/project.root`
   - выставляем: `INCLUDE_CONFIGURATIONS =`
   - выставляем: `EXCLUDE_CONFIGURATIONS =`
2. Заходим: `eDIR_WORKSPACE/projects/cmdhello/deploy`  
3. Открываем: `make-full.bat`  
4. Выставляем: `set "PREFIX={DIR_SOURCES}\deploy"`  
5. Исполняем: `call :installCmakeMakeFiles`  

Ожидаемый результат:  
  - лог должен заканчиваться строками:  
  ```
  [CMAKE] completed successfully
  [INSTALL] completed successfully
  [ENGINE] completed successfully
  ```
  - в каталоге: `eDIR_WORKSPACE/projects/cmdhello/deploy/build`  
    - должны присутствовать сборки всех конфигураций,
      для всех обнаруженных движком компиляторов.  

  - в каталоге: `eDIR_WORKSPACE/projects/cmdhello/deploy/product`  
    - должны присутствовать результаты сборок всех конфигураций,
      для всех обнаруженных движком компиляторов.  

## install-DIR_OWNER
1. в файле: `eDIR_WORKSPACE/projects/cmdhello/project.root`
   - выставляем: `INCLUDE_CONFIGURATIONS =`
   - выставляем: `EXCLUDE_CONFIGURATIONS =`
2. Заходим: `eDIR_WORKSPACE/projects/cmdhello/deploy`  
3. Открываем: `make-full.bat`  
4. Выставляем: `set "PREFIX={DIR_OWNER}"`  
5. Исполняем: `call :installCmakeMakeFiles`  

Ожидаемый результат:  
  - лог должен заканчиваться строками:  
  ```
  [CMAKE] completed successfully
  [INSTALL] completed successfully
  [ENGINE] completed successfully
  ```
  - в каталоге: `eDIR_WORKSPACE/projects/cmdhello/deploy/build`  
    - должны присутствовать сборки всех конфигураций,
      для всех обнаруженных движком компиляторов.  

  - в каталоге: `eDIR_WORKSPACE/projects/cmdhello/deploy/product`  
    - должны присутствовать результаты сборок всех конфигураций,
      для всех обнаруженных движком компиляторов.  

## run-tests-all 
1. в файле: `eDIR_WORKSPACE/projects/cmdhello/project.root`
   - выставляем: `INCLUDE_CONFIGURATIONS =`
   - выставляем: `EXCLUDE_CONFIGURATIONS =`
2. Заходим: `eDIR_WORKSPACE/projects/cmdhello/deploy`  
3. Открываем: `make.bat`  
4. Исполняем: 
   - `call :installCmakeMakeFiles`  
   - `call :runTests`  

Ожидаемый результат:  
  - успешная сборка всех конфигураций.  
  - запуск тестовых программ для всех конфигураций, 
    за исключением mingw с dynamic рантаймом.  
  - в логе должны быть записи вида:  
  ```
  [========= test =========]    
  [TEST] C:/workspace/_products/cmdhello/msvc2019-release-64-static/bin-cmdhello/cmdhello.exe 
  [TEST] C:/workspace/_products/cmdhello/msvc2019-release-64-dynamic/bin-cmdhello/cmdhello.exe 
  [TEST] C:/workspace/_products/cmdhello/msvc2019-release-32-static/bin-cmdhello/cmdhello.exe 
  [TEST] C:/workspace/_products/cmdhello/msvc2019-release-32-dynamic/bin-cmdhello/cmdhello.exe 
   ```
  - лог должен завершиться записями:
  ```
  [========= test =========]
  [RUN-TESTS] completed successfully
  [ENGINE] completed successfully
  ```
  - должен появится дополнительный файл с логом `cmdlog.txt`  
  - файл должен содержать детальный лог запусков всех тестовых программ.  

## run-VisualStudio
1. Заходим: `eDIR_WORKSPACE/projects/cmdhello/deploy`  
3. Открываем: `make.bat`  
4. Исполняем: `call :runVisualStudio`  

Ожидаемый результат:  
  - запуск Visual Studio 2019:  
  - студия должна успешно загрузить проект.  
  - проект должен успешно скомпилироваться.  
  - в каталоге `eDIR_WORKSPACE/_products/cmdhello`  
    должны быть размещены результаты сборки.  

## run-QtCreator
1. Заходим: `eDIR_WORKSPACE/projects/cmdhello/deploy`  
3. Открываем: `make.bat`  
4. Исполняем: `call :runQtCreator`  

Ожидаемый результат:  
  - запуск QtCreator:  
  - проекд должен успешно загрузиться.
  - проект должен успешно скомпилироваться.  
  - в каталоге `eDIR_WORKSPACE/_products/cmdhello`  
    должны быть размещены результаты сборки.  
