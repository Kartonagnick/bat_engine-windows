
project.root  
------------

Если этот файл существует, 
то он должен находиться в корне каталога исходников.  


Файл содержит глобальные настройки проекта:  
- [INCLUDE_CONFIGURATIONS](#INCLUDE_CONFIGURATIONS "список поддерживаемых конфигураций")  
- [EXCLUDE_CONFIGURATIONS](#EXCLUDE_CONFIGURATIONS "список неподдерживаемых конфигураций")  
- [VERSION](#VERSION "версия продукта")  

## INCLUDE_CONFIGURATIONS
Задаёт список поддерживаемых проектом конфигураций:
```
INCLUDE_CONFIGURATIONS = msvc-all
INCLUDE_CONFIGURATIONS += "mingw"
```
По умолчанию - `all`

Движок может быть запущен в режиме "собрать всё".  
Однако, в итоговый список конфигураций войдут только и только поддерживаемые конфигурации.  

## EXCLUDE_CONFIGURATIONS
Задаёт список не поддерживаемых проектом конфигураций:
```
EXCLUDE_CONFIGURATIONS = msvc
EXCLUDE_CONFIGURATIONS += "mingw"
```
По умолчанию - не используется.

Движок может быть запущен в режиме "собрать всё".  
Однако, в итоговый список конфигураций войдут только и только поддерживаемые конфигурации.  

## VERSION
Версия продукта.
Можно указать конкретную версию:
```
VERSION = plugin\include\plugin\confbuild.hpp
```
Либо можно указать файл, из которого нужно извлечь версию:
```
VERSION = plugin\include\plugin\confbuild.hpp
```

В файле осуществляется поиск записей:

```
#define dVERSION_MAJOR      1
#define dVERSION_MINOR      2
#define dVERSION_PATCH      3
```

Из которых потом формируется версия: `ver-1.2.3`  
В дальнейшем версия может быть использована в путях `build` или `product`  


