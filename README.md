# Mrcmd Tool v0.5.0
Этот репозиторий содержит Mrcmd утилиту для группировки и запуска unix утилит, консольных скриптов и т.д.

## Статус проекта
Проект находится на стадии бета-тестирования.

## Быстрый старт

> Для Windows два пути использования утилиты:
> - WSL2, инструкция по установке находится [здесь](https://github.com/mondegor/mrcmd-plugins/blob/master/docs/WIN_WSL_DOCKER_GUIDE.md);
> - GitBash, скачать можно [здесь](https://git-scm.com/download/win);

> Для большинства плагинов утилиты требуется установка Docker
> - [для Windows](https://www.docker.com/products/docker-desktop/) либо [WSL2+Docker](https://github.com/mondegor/mrcmd-plugins/blob/master/docs/WIN_WSL_DOCKER_GUIDE.md);
> - [для Linux](https://docs.docker.com/desktop/install/linux-install/);

### Инсталляция утилиты
- `cd {PARENT_DIR}` // сначала перейти в директорию, где будет расположена утилита
- `curl -L -o mrcmd.zip https://github.com/mondegor/mrcmd/archive/refs/tags/latest.zip`
- `unzip mrcmd.zip && rm mrcmd.zip && mv mrcmd-latest mrcmd`
- `bash ./mrcmd/register.sh` (for Linux)
- `register.bat` (for Windows, ВНИМАНИЕ: запускать из PowerShell или проводника под админом)
- `mrcmd state`

### Инсталляция базовых плагинов
- `cd mrcmd`
- `curl -L -o mrcmd-plugins.zip https://github.com/mondegor/mrcmd-plugins/archive/refs/tags/latest.zip`
- `unzip mrcmd-plugins.zip && rm mrcmd-plugins.zip && mv mrcmd-plugins-latest plugins`
- `mrcmd state`

### Создание нового проекта
- `mkdir test-project`
- `cd test-project`
- `mrcmd init`

## Основные команды
- `mrcmd help` - помощь в контексте текущего проекта;
- `mrcmd state` - общее состояние текущего проекта;
- `mrcmd init` - инициализация нового проекта;

## Групповые команды
- `mrcmd config` - текущая конфигурация всех подключённых плагинов;
- `mrcmd export-config` - выгрузка текущей конфигурации всех подключённых плагинов в `.env.export`;
- `mrcmd install` - установка ресурсов тех плагинов, которые реализовали данную команду;
- `mrcmd start` - запуск сервисов тех плагинов, которые реализовали данную команду;
- `mrcmd stop` - остановка сервисов тех плагинов, которые реализовали данную команду;
- `mrcmd uninstall` - удаление ресурсов тех плагинов, которые реализовали данную команду;

## Подключение базовых плагинов
По умолчанию **Mrcmd** не содержит в себе плагины, она от них вообще не зависит, но без них она совершенно бесполезна.
Чтобы установить к ней базовые плагины, необходимо:
- скачать и распаковать проект `https://github.com/mondegor/mrcmd-plugins` (с учётом версии) в директорию утилиты с названием `plugins`;
- либо вызывать утилиту со следующей опцией `mrcmd --shared-plugins-dir {DIR}`, где {DIR} - местоположение необходимых плагинов;
- либо в файле `.env` проекта установить переменную `MRCMD_PLUGINS_DIR={DIR}`;

## Описание проекта
**Mrcmd** - утилита, написанная на языке bash в строгой нотации. Её архитектура состоит из двух компонентов:
- ядра, которое можно использовать для написания собственных, более надёжных bash скриптов;
- системы управления небольшими утилитами — плагинами (SMP), предоставляющая общий интерфейс для их управления;

<img src="https://github.com/mondegor/mrcmd/tree/master/docs/img/mrcmd-module.png" width="400" height="207">

SMP каждому плагину позволяет решать собственную задачу, для этого предоставляет ему:
- независимое переменное окружение;
- возможность переопределения переменного окружения;
- реализацию групповых команд поддерживаемых утилитой, а также добавление своих собственных команд;
- настройку зависимостей от других плагинов;
- собственную справочную систему;

Тем самым, в каждом плагине скрывается способ решения той или иной задачи. Конкретный проект пользуется только общим интерфейсом утилиты и расширенными возможностями подключённых плагинов.

## Взаимодействие утилиты с её окружением
<img src="https://github.com/mondegor/mrcmd/tree/master/docs/img/mrcmd.png" width="1024" height="884">

## Какие возможности даёт
- быстрое локальное разворачивание проекта с использованием групповых команд, таких как install, start (на базе Docker);
- любой плагин можно подключить к нескольким проектам с изолированными настойками для каждого, они не будут пересекаться;
- реализация плагинов под конкретный проект со специфической функциональностью;
- возможность просмотра текущего переменного окружения всех плагинов для каждого проекта, выгрузка этого окружения в `.env.export`;
- централизованная система помощи вместе с общим дизайном команд помогут быстро разобраться как работает тот или иной плагин;
- встроенные инструменты для отладки утилиты, возможность просмотра текущего состояния утилиты (загруженные плагины, проблемы зависимостей);
- с помощью специального плагина имеется возможность подробной информации о каждом плагине (какие методы реализует, какие зависимости использует);
- на подобии make файла, можно описать персональные плагины, в которые будут убраны все вспомогательные, часто используемые команды используемые при разработке;
- создание интерфейсных команд, содержимое которых с течением времени меняется, например: создать бд, создать модель и т.д.;
- использование в качестве исследовательской деятельности, когда нужно быстро проверить ту или иную технологию с конкретными версиями;
- уменьшение сложности системы за счёт её распределения по плагинам, позволяющее быстро локализовывать и устранять проблемы;

## Опыт внедрения
Утилита была апробирована на нескольких проектах, в одном из которых используется микросервисная архитектура.
Для этого проекта было написано несколько плагинов:
- первый собирает из фрагментов API спецификации проекта: общую и для каждого сервиса отдельно, далее сохраняет их в виде yaml файлов в формате OpenAPI;
- второй загружает сервисы проекта из различных репозиториев, инсталлирует их и запускает на машине разработчика;

## Вспомогательные проекты
- Базовый набор плагинов для утилиты: https://github.com/mondegor/mrcmd-plugins
- Утилита для тестирования bash скриптов: https://github.com/mondegor/mrtesh