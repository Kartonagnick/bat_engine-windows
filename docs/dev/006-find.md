﻿
Поиск по симптомам
------------------

Симптомы - список имен файлов или каталогов.  

Суть:  
Если в текущем каталоге присутствуют все симптомы, 
значит текущий каталог - именно тот, что мы ищем.  

Если же в нем не хватает нужных нам симптомов, 
тогда продолжаем поиск в родительском каталоге.  

Поиск продолжается до тех пор, пока не будет обнаружен нужный каталог,
либо пока не дойдёт до корнегово каталога диска.  
В последнем случае поиск завершается неудачей.  


Поиск корневого каталога WorkSpace  
----------------------------------
Переменная: `eDIR_WORKSPACE`.  
Симптомы: `eWORKSPACE_SYMPTOMS=3rd_party;programs`


Поиск каталога исходного кода  
-----------------------------  
Переменная: `eDIR_SOURCES`.  
Симптомы:  
  - `include;deploy`  
  - `src;source;sources;project.root`  


Поиск CMakeLists.txt  
--------------------
Переменная: `eDIR_CMAKE_LIST`.  
Поиск выполняется последовательно в следующих местах:  
1. eDIR_OWNER/CMakeLists.txt  
2. eDIR_OWNER/cmake/CMakeLists.txt  
3. eDIR_SOURCES/deploy/CMakeLists.txt  
4. eDIR_SOURCES/deploy/cmake/CMakeLists.txt  


