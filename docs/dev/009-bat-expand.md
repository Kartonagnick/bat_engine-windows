
expand
------
Это - процедура макро-подстановки значений переменных вместо самих переменных.  

Внутри фигурных скобочек содержатся имена переменных.  
expand подменяет имена переменных их содержимым.  

Было:

```
    set "DIR_WORKSPACE=C:\workspace" 
    set "NAME_PROJECT=example" 

    set "eDIR_BUILD={DIR_WORKSPACE}\_build\{NAME_PROJECT}" 
```

Стало:

```
    set "eDIR_BUILD=C:\workspace\_build\example" 
```

normalize
---------
Это - процедура нормализации файловых путей.  
Нормализованный путь не содержит одинарных или двойных точек.
