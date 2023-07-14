# Mrcmd Tool v0.5.8
Этот репозиторий содержит Mrcmd Tool для группировки и запуска unix команд и консольных скриптов.

## Статус проекта
Проект находится на стадии бета-тестирования.

## Быстрый старт
> Для Windows два пути использования утилиты:
> - WSL2 - инструкция по установке находится [здесь](https://github.com/mondegor/mrcmd/blob/master/docs/WIN_WSL_DOCKER_GUIDE.md);
> - GitBash - скачать можно [здесь](https://git-scm.com/download/win);

> Для большинства плагинов утилиты требуется установка Docker:
> - для [Windows](https://docs.docker.com/desktop/install/windows-install/) либо для [WSL2](https://github.com/mondegor/mrcmd/blob/master/docs/WIN_WSL_DOCKER_GUIDE.md);
> - для [Linux](https://docs.docker.com/desktop/install/linux-install/);

### Инсталляция утилиты
- Выбрать рабочую директорию, где должна быть расположена утилита;
- `curl -L -o mrcmd.zip https://github.com/mondegor/mrcmd/archive/refs/tags/latest.zip`
- `unzip mrcmd.zip && rm mrcmd.zip && mv mrcmd-latest mrcmd && chmod +x ./mrcmd/cmd.sh`
- Для Linux, WSL: `sudo bash ./mrcmd/register.sh`
- Для Windows: `register.bat` // ВНИМАНИЕ: запускать из PowerShell или проводника под админом
- `mrcmd state` // проверить, что утилита была установлена

### Инсталляция базовых плагинов
- `curl -L -o mrcmd-plugins.zip https://github.com/mondegor/mrcmd-plugins/archive/refs/tags/latest.zip`
- `unzip mrcmd-plugins.zip && rm mrcmd-plugins.zip && mv mrcmd-plugins-latest mrcmd/plugins`
- `mrcmd state` // проверить, что плагины утилиты были установлены (см. Shared plugins path)

### Пример инициализации нового проекта
- `mkdir test-project && cd test-project`
- `mrcmd init`
- `mrcmd state` // проверка, что проект был инициализирован

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
**Mrcmd Tool** - утилита, написанная на языке bash в строгой нотации. Она предназначена для группировки и запуска unix команд и консольных скриптов. Её архитектура состоит из трёх основных компонентов:
- ядра, которое можно использовать для написания собственных, более надёжных bash скриптов;
- модуля управления небольшими утилитами — плагинами (MPM), предоставляющий общий интерфейс для написания плагинов;
- и контроллера, который, используя ядро, обрабатывает внешние команды и перенаправляет их в модуль MPM;

<img src="https://github.com/mondegor/mrcmd/blob/master/docs/img/mrcmd-architecture.png" width="539">

MPM каждому плагину позволяет решать собственную задачу, для этого предоставляет ему:
- независимое переменное окружение;
- возможность переопределения переменного окружения;
- реализацию групповых команд поддерживаемых утилитой, а также добавление своих собственных команд;
- настройку зависимостей от других плагинов;
- собственную справочную систему;

Тем самым, в каждом плагине скрывается способ решения той или иной задачи. Конкретный проект пользуется только общим интерфейсом утилиты и расширенными возможностями подключённых плагинов.

## Взаимодействие с окружением
<img src="https://github.com/mondegor/mrcmd/blob/master/docs/img/mrcmd-c4.png" width="973">

## Какие возможности даёт
- быстрое локальное разворачивание проекта с использованием групповых команд, таких как `install`, `start` (на базе Docker);
- любой плагин можно подключить к нескольким проектам с изолированными настройками для каждого, они не будут пересекаться;
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
Утилита была апробирована на нескольких проектах, некоторые из них используют микросервисную архитектуру.
Для этих проектов были написаны несколько собственных плагинов:
- один занимается сборкой API спецификаций для каждого из сервисов в виде `yaml` файлов в формате `OpenAPI`;
- другой загружает сервисы проекта из различных репозиториев и разворачивает их на машине разработчика (включая все необходимые внешние ресурсы: БД, очереди и т.д.);

## Сопутствующие проекты
- [Базовый набор плагинов для утилиты Mrcmd](https://github.com/mondegor/mrcmd-plugins)
- [Утилита Mrtesh для тестирования bash скриптов](https://github.com/mondegor/mrtesh)