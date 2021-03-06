﻿
task  
--------------------------------------------------------------------------------

Основная идея: проект не должен быть прибит гвоздями 
к какому то одному таск-треккеру.  
Он всегда должен быть готов к миграции в другую систему.  

Что бы не зависеть от прихотей такс-треккеров, 
копии всех задач должны храниться в нашем репозитории.  
Такой подход гарантирует, что при миграциях на другие системы, 
история задач не пострадает.  

Порядок создания задач:  
--------------------------------------------------------------------------------

1. Сначала задача создаётся в таск-треккере.  

2. Когда разработчик принимает задачу в разработку, 
   то он первым делом создаёт отдельную ветку с таким же названием, 
   как в треккере.  
   Например, в треккере на github задача (issue) назвается: `#1 example`  
   Разработчик создает ветку: `#1_example`  

3. В своей ветке, в каталоге `docs\tasks`, разработчик создаёт файл задачи.  
   Имя файла задаётся в формате: `{data}-{id}-{name}.md`  
     `{data}` - дата создания задачи.  
     `{id}`   - числовой номер задачи.  
     `{name}` - текстовое имя задачи.  
   Например: `2021y-01m-04d-00002-workflow.md`  
     `2021y-01m-04d` - дата, когда задача была принята в разработку.  
     `00022` - номер задачи.  
     `workflow` - текстовое имя задачи.  

4. Содержимое файла задачи дублирует описание задачи из треккера.  

5. Однако, в самом начале файла описывается шапка задачи:  
   - дата, когда исполнитель начал работу.  
   - дата, когда исполнитель закончил работу.  
   - время, которое было затраченно на задачу (опционально)  
   - имя исполнителя.  

   Пример: `2021y-01m-04d-00002-workflow.md`  

```
[2021y-01m-04d][2021y-01m-04d](10 min) Kartonagnick
---

workflow - документ, который описывает принцип организации рабочего процесса.
Он должен содержать ответы на вопросы:

Как именно осуществляется процесс разработки?
(словесное описание)

Что конкретно, и в какой последовательности должны делать разработчики?
(регламент)

А так же, документ должен содержать ответы на вопросы:
  1. Что такое "один рабочий цикл" ?
  2. Из каких этапов он состоит ?
  3. Как создавать задачу?
  4. Как правильно работать с гитом:
  4.1. Когда и как создавать ветки ?
  4.2. Что писать в комментариях к коммитам ?
  4.3. Когда и как вливать изменения в master ?
  4.4. Как правильно изменять значение версии продукта ?
  5. Как правильно фиксировать историю развития проекта ?
```

Означает:
 - задача была созданна: `2021y-01m-04d`  
 - номер задачи: `00002`  
 - название задачи: `workflow`  
 - задача была запущена: `[2021y-01m-04d]`  
 - задача была завершена: `[2021y-01m-04d]`  
 - было затрачено времени: `(10 min)`  
 - исполнитель: `Kartonagnick`  
 - текст задачи задан в форме чек-листа  

6. Если дата окончания не указана, значит задача еще не завершена.  
   Когда разработчик начинает работу над задачей, он выставляет только дату начала.  
   Дата окончания добавляется отдельным, последним коммитом.  

7. Если задача была переоткрыта, 
   тогда в шапку задачи добавляется новая запись открытия задачи.  
   (возможно с новым исполнителем)  
   Пример:  

   ```
   [2021y-01m-04d][2021y-01m-04d](10 min) Kartonagnick
   [2021y-01m-05d][2021y-01m-05d](05 min) Kartonagnick
   ---
   ```

   Первая запись - когда задача была исполнена первый раз.  
   Вторая запись - когда задача была переоткрыта.  

8. По мере увеличения количества задач, количество файлов будет расти.  
   Для удобства навигации старые задачи можно (и нужно) архивировать.  
   Архивы располагаются здесь же - в подкаталогах.  
   Например:  
   ```
   docs\tasks
    |--- 2020
    |     `-- archive.7z
    |
     `-- 2021y-01m-04d-00002-workflow.md
   ```
   В примере выше, `2020` - подкаталог, который содержит архив задач за 2020 год.  

9. При описании некоторых задач могут понадобиться дополнительные материалы.  
   Например - картинки. Они должны храниться здесь же, в каталоге `docs/dev`  
   На треккерах же всегда размещаем ссылку или копию.  


