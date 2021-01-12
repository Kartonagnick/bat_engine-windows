
Карта движка
------------
<pre>
       +----------+   +--------+  +---------+
   .---|  initial |---| update |  | ↔ ↕ ⇆ ⇅ |
  |    +----------+   +--------+  +---------+
  |                     ↑  
+-----------+           ;
| run       |      .---'
+-----------+     '
  |              |
  |   +--------------+  +----------+  +----------------+
  |`--| parseCommand |--| settings |--| parseArguments |
  |   +--------------+  +----------+  +----------------+
  |
  |   +-------------------------+  +------------------+  +--------+
  |`--| detect source directory |--| adjust arguments |--| expand |
  |   +-------------------------+  +------------------+  +--------+
  |
  .   +---------------+              +------------+
   `--| call commands |           .--| filtration |
      +---------------+          |   +------------+
        |                        |
        |   +----------+         |    +---------+          +---------------------+
        |`--| generate |--.      | .--| request |       .--| generate-{COMPILER} |
        |   +----------+   |     ||   +---------+      |   +---------------------+
        |                  |     ||                    |
        |   +----------+   |   +---------+  +------+   |   +---------------------+
        |`--| build    |---ɵ--→| configs |--| loop |---ɵ---| build-{COMPILER}    |
        |   +----------+   |   +---------+  +------+   |   +---------------------+
        |                  |                  |        |
        |   +----------+   |                  |        |   +---------------------+
        |`--| install  |--'|                  |         `--| install-{COMPILER}  |
        |   +----------+   |                  |            +---------------------+
        |                  |                  ↓         
        |   +----------+   |                  |
        |`--| clean    |--'| ←---------------'|
        |   +----------+   |                  |
        |                  |                  |         
        |   +----------+   |                  ;
        |`--| runTests |--'  ←---------------'
        |   +----------+        
        |                      +-----------+
        |                   .--| run-msvc  |
        .   +----------+   |   +-----------+
         `--| runIDE   |---|
            +----------+   |   +-----------+
	                    `--| run-mingw |
	                       +-----------+
</pre>

<a href="arch/001-initial.md" title="обновление запчастей движка">initial</a> 
<a href="arch/002-update.md" title="обновление настроек движка">update</a>
<a href="arch/000-run.md" title="запуск движка">run</a>

<a href="arch/003-settings.md" title="настройки движка">settings</a> 
<a href="arch/004-parseCommand.md" title="парсинг команды">parseCommand</a> 
<a href="arch/005-parseArguments.md" title="парсинг атрибутов команды">parseArguments</a>

<a href="arch/006-detect.md" title="поиск каталога исходников">detect source directory</a>
<a href="arch/007-adjust.md" title="обработка аргументов командной строки">adjust arguments</a>
<a href="arch/008-expand.md" title="раскрытие строк форматирования в итоговые пути">expand</a>

<a href="arch/009-call.md" title="запуск команды">call commands</a>

<a href="arch/010-generate.md" title="команда: 'generate'">generate</a>
<a href="arch/011-build.md" title="команда: 'build'">build</a>
<a href="arch/012-install.md" title="команда: 'install'">install</a>
<a href="arch/013-clean.md" title="команда: 'clean'">clean</a>
<a href="arch/014-runTests.md" title="команда: 'runTests'">runTests</a>
<a href="arch/015-runIDE.md" title="команда: 'runIDE'">runIDE</a>

<a href="arch/016-configs.md" title="подготовка списка итоговых конфигураций">configs</a>
<a href="arch/017-request.md" title="обработка запроса конфигурации">request</a>
<a href="arch/018-filtration.md" title="удаление неподдерживаемых конфигураций">filtration</a>

<a href="arch/019-loop.md" title="для каждой конфигурации запускает некоторый скрипт">loop</a>

<a href="arch/runIDE/run-msvc.md" title="запускает Visual Studio">run-msvc</a>
<a href="arch/runIDE/run-mingw.md" title="запускает QtCreator">run-mingw</a>

<a href="arch/cmake/000-generate.md" title="запускает cmake для генерации MakeFiles">generate-{COMPILER}</a>
<a href="arch/cmake/001-build.md" title="запускает cmake для сборки MakeFiles">build-{COMPILER}</a>
<a href="arch/cmake/002-install.md" title="исталяция результатов сборки">install-{COMPILER}</a>
