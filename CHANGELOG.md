# Mrcmd Tool Changelog
Все изменения в Mrcmd будут документироваться на этой странице.

## 2023-06-16
### Added
- Добавлены функции mrcore_tool_exists и mrcore_validate_tool_required для проверки наличия указанной команды;

## 2023-06-14
### Changed
- Доработаны диаграммы отражающие архитектуру утилиты;

### Fixed
- Исправлена ошибка монтирования директорий в Windows, в связи с этим добавлены функции mrcmd_os_realpath и mrcmd_os_path;
- Доработан register.bat, который позволяет зарегистрировать утилиту в Windows глобально;

## 2023-06-12
### Added
- Добавлены константы MRCORE_DOTENV_DEFAULT, MRCORE_DOTENV_EXPORTED, MRCMD_SHARED_PLUGINS_DIR_DEFAULT;
- Добавлена команда `init`, которая инициализирует текущий проект (создаёт `.env` файл с настройками по умолчанию);
- Добавлена функция `mrcmd_plugins_lib_get_plugin_dir` для получения директории, где лежит плагин по его имени;
- Добавлены файлы `register.bat` и `register.sh` регистрации утилиты, для её использования в глобальном пространстве;

### Changed
- Обновлён экспорт переменных (`export-config`);
- Константы MRCMD_PLUGINS_DIR и APPX_PLUGINS_DIR теперь можно переопределять в `.env` файле;
- Переменную MRCMD_CURRENT_PLUGINS_DIR теперь можно использовать в методе инициализации плагинов (`mrcmd_plugins_{PLUGIN_NAME}_method_init`);
- Доработаны разделы команд `help` и `state`;

### Removed
- Удалена переменная MRCMD_CURRENT_PLUGIN_NAME;
- Удалена лишняя функция `mrcmd_plugins_load_init_methods`;

## 2023-05-27
### Added
- В функциях валидации разрешено задавать пустые параметры;
- В `.editorconfig` добавлены `xml`, `xslt`, `puml` форматы;

## 2023-05-21
### Added
- Добавлены функции: `mrcore_get_shell`, `mrcore_lib_flag_to_int`, `mrcore_lib_rm_resource`, `mrcore_lib_get_var_value`, `mrcore_os_path_win_to_unix`, `mrcore_validate_resource_required`;
- В export_config добавлена, в виде заголовка, информация о системных переменных в экспортируемый файл;
- Добавлена переменная MRCMD_PLUGINS_DIR и параметр `--shared-plugins-dir` для её внешнего управления;

### Changed
- Заменено у плагинов NAME -> CAPTION;
- Обновлён раздел команды `help`;
- Файл переименован и расширен: `tty.sh` -> `os.sh`;

### Fixed
- Исправлено несколько тестов;
- Добавлен отсутствующий оператор function у некоторых методов;

### Removed
- Удалён export в тех переменных, в которых он был не нужен;

## 2023-05-12
### Added
- Добавлена возможность экспорта переменных окружения (`export-config`, `mrcore_dotenv_export_var`);
- MRCMD_PLUGIN_METHODS_SHOW_COMPLETED_ARRAY;

### Changed
- MRCMD_SYSTEM_PLUGIN_METHODS_ARRAY -> MRCMD_PLUGIN_METHODS_ARRAY;
- `mrcmd_plugins_lib_get_plugin_var_value` -> `mrcmd_plugins_lib_get_plugin_var`;

### Fixed
- Добавлено отсутствующее объявление переменной pluginName;
- Опции утилиты теперь только можно добавлять перед командой и сразу после неё;
- Исправлена ошибка при формировании имени функции плагина;

### Removed
- DEBUG_LEVEL_4;

## 2023-05-01
### Fixed
- `pl` -> `pm`;

## 2023-04-23
### Added
- Добавлена поддержка загрузки плагинов с учётом их зависимости от других плагинов;
- Доработаны страницы `help`, `config`, `state`;
- Добавлены новые методы `start`, `stop`;
- Добавлены новые тесты кода;

### Changed
- Произведён рефакторинг кода;