
Синопсис
--------

```
features
 |
 |-- version                               без аргументов
 |
 |-- generate: cmake-makefiles             аргумент опционален
 |    |--- dir_sources: ..\                путь к исходникам              [optional]
 |    |--- dir_project: .\cmake            путь к CMakeLists.txt          [optional]
 |    |--- dir_product: .\product          каталог с результатами сборки  [optional]
 |    |--- name_project: example           имя проекта                    [optional]
 |    |--- defines: STABLE_RELEASE         дефайны препроцессора          [optional]
 |    |--- configurations: msvc            список конфигураций сборки
 |     `-- без оптимизаций. 
 |
 |-- build: cmake-makefiles                аргумент опционален
 |    |--- dir_sources: ..\                путь к исходникам              [optional]
 |    |--- dir_project: .\cmake            путь к CMakeLists.txt          [optional]
 |    |--- dir_product: .\product          каталог с результатами сборки  [optional]
 |    |--- dir_build: .\build              сборочные временные файлы      [optional]
 |    |--- name_project: example           имя проекта                    [optional]
 |    |--- defines: STABLE_RELEASE         дефайны препроцессора          [optional]
 |    |--- configurations: msvc            список конфигураций сборки
 |    |--- сначала запускает generate
 |     `-- без оптимизаций. 
 |
 |-- install: cmake-makefiles
 |    |--- dir_sources: ..\                путь к исходникам              [optional]
 |    |--- dir_project: .\cmake            путь к CMakeLists.txt          [optional]
 |    |--- dir_product: .\product          каталог с результатами сборки  [optional]
 |    |--- dir_build: .\build              сборочные временные файлы      [optional]
 |    |--- name_project: example           имя проекта                    [optional]
 |    |--- defines: STABLE_RELEASE         дефайны препроцессора          [optional]
 |    |--- configurations: msvc            список конфигураций сборки
 |    |--- сначала запускает build
 |     `-- без оптимизаций. 
 |
 |-- runTest: *.exe
 |    |--- dir_product: .\product          каталог с результатами сборки  [optional]
 |    |--- exclude: mingw*-dynamic
 |    |--- configurations: all
 |     `-- оптимизация, если задан режим all
 |
 |-- clean: all
 |    |--- dir_build: .\build              сборочные временные файлы      [optional]
 |    |--- configurations: all
 |    |--- конфигурация и аргумент команды взаимозаменяемые
 |     `-- оптимизация, если задан режим all
 |
 |-- run: QtCreator
 |    |--- dir_project: .\cmake            путь к CMakeLists.txt          [optional]
 |    |--- для работы нужен только eDIR_CMAKE_LISTS
 |     `-- не нуждается в конфигурации
 |
 |-- run: VisualStudio
 |    |--- dir_build: .\build              сборочные временные файлы      [optional]
 |    |--- configurations: msvc
 |     `-- использует значение только первой конфигурации
```
