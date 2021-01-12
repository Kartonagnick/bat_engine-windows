﻿
Первая сборка
-------------

Изначально движок проектировался под заказ [WorkSpace](https://github.com/Kartonagnick/workspace).  
Поэтому, эффективнее всего движок работает именно в связке с этой средой.  
Однако, bat_engine - независимая разработка, поэтому, он может функционировать и сам по себе.  

Главная задача движка - осуществлять сборку множества конфигураций, 
множеством компиляторов. 

Предполагается, что в будущем движок будет поддерживать множество различных форматов проектов.
Однако, в настоящий момент поддерживается только работа с cmake.

Движок подгатавливает среду для очередного компилятора, и запускает cmake, 
который в свою очередь запускает особый сценарий "умной сборки" - [Minimalist](https://github.com/Kartonagnick/cmake-minimalist).
Так же, как и bat_engine, Mimimalist проектировался под заказ [WorkSpace](https://github.com/Kartonagnick/workspace).  
И тоже следует идеалогии WorkSpace: максимально автоматизирует рутину. 
Minimalist умеет в автоматическом режиме определять состав исходников целей сборки, 
и тп.

Комплексное решение: `workspace + bat_engine + minimalist = комфорт` значительно упрощает обслуживание кодовой базы.  
Пример:  

## Сборка `hello_world`

1. Для начала нужно [скачать и установить](000-get_started.md) сам движок.  
   Для примера пусть он будет установлен в каталог `C:\bat_engine`  

2. Нам понадобится проект, который мы будем собирать.  
3. Допустим, это - простенький `hello_world`  
   со следующей классической структурой:  

   ```
   C:\
    |--- bat_engine
     `-- hello_world
          |--- include
           `-- src
   ```

4. Создадим подкаталог `deploy`,
   в котором мы будем размещать артефакты сборки.  
   У нас должно получиться:  
   
   ```
   C:\
    |--- bat_engine
     `-- hello_world
          |--- deploy
          |     |--- cmake
          |     |     `-- CMakeLists.txt
          |      `-- make.bat
          |--- include
           `-- src
   ```

   Где:  
     - CMakeLists.txt - сценарий cmake  
     - make.bat - нужен для запуска движка.  

5. Содержимое make.bat  

   ```
    set "eDIR_BAT_ENGINE=C:\bat_engine\bat\engine"

    call "%eDIR_BAT_ENGINE%\run.bat"  ^
        "--install: cmake-makefiles"  ^
        "--configurations: all"

    call "%eDIR_BAT_ENGINE%\run.bat"  ^
        "--runTests"
   ```

6. Заходим в каталог `C:\hello_world\deploy`  
7. Запускаем сборку: `make.bat`  

8. Движок обнаружит все компиляторы на данном компьютере, 
   и выполнит сборку всех конфигураций.  

9. PROFIT ???!!!  