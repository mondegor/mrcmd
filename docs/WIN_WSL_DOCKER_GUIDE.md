## Инструкция по установке Ubuntu + Docker под Windows на WSL2

**Перед началом установки, скопируйте текущий документ, замените все ниже приведённые переменные на свои значения, и приступайте к установке:**
<pre>
Vars:
  {linux_name} = Ubuntu 20.04.5 LTS
  {image_name} = Ubuntu-20.04
  {wsl_dir} = d:\wsl\Ubuntu-20.04\
  {backup_dir} = d:\backup\wsl\Ubuntu-20.04
  {user_name} = ivanov
  {user_email} = ivan.ivanov@localhost
  {user_name_lastname} = Ivan Ivanov
</pre>

### 1. Перед установкой Linux обновить WSL
> **ПОДРОБНЕЕ:**\
> https://learn.microsoft.com/en-us/windows/wsl/install

- Зайти на https://learn.microsoft.com/en-us/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package
- Скачать и установить `WSL2 Linux kernel update package for x64 machines` (wsl_update_x64.msi)
- Зайти в `Windows PowerShell`
- Запустить `wsl --set-default-version 2` // установка wsl2 по умолчанию

### 2. Установка Linux
- Зайти в Магазин Microsoft, найти необходимый дистрибутив Linux `{linux_name}`, скачать его и установить

> **ПОДРОБНЕЕ:**
> - Как включить подсистему Linux в Windows 10: https://4te.me/post/windows-ubuntu/
> - https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configuration-setting-for-wslconfig
> - https://rdevelab.ru/blog/no-category/post/wsl2-setup-for-development

> **ВАЖНО:**\
> Файловые системы установленных виртуальных машин доступны через сетевой адрес `\\wsl$`\
> Это позволяет обратиться к конкретному образу `\\wsl$\{image_name}` и смонтировать его как обычную сетевую папку

### 3. Базовая установка и настройка

#### 3.1 Обновление пакета инсталляции
- `sudo apt-get update`

> **WARNING:**\
> Если проблемы с интернетом, то скорее всего дело в `/etc/resolv.conf`

#### 3.2 Установка оболочки MC вместе с редактором (OPTIONAL)
- `sudo apt install mc`

#### 3.3 Создание рабочей директории
- `mkdir -p /home/{user_name}/work`
- `mkdir -p /home/{user_name}/work/.cache`

#### 3.4. Добавление настроек пользователя устанавливаемых при входе в консоль (OPTIONAL)
- `mcedit /home/{user_name}/.bashrc`

Добавить в конец файла:
<pre>
export EDITOR=mcedit
cd /home/{user_name}/work 
</pre>

- `sudo mcedit /root/.bashrc`

Добавить в конец файла:
<pre>
export EDITOR=mcedit
</pre>

#### 3.5. Настройки wsl
- `sudo mcedit /etc/wsl.conf`

Добавить настройки:
<pre>
[user]
default = {user_name}
</pre>

> **ПОДРОБНЕЕ:**\
> https://docs.microsoft.com/en-us/windows/wsl/wsl-config

#### 3.6. Настройки GIT
- `git config --global user.email "{user_email}"`
- `git config --global user.name "{user_name_lastname}"`
- `git config --global core.autocrlf input`
- `git config --global core.quotepath off`

- `touch /home/{user_name}/work/.gitignore_global` (OPTIONAL)
- `git config --global core.excludesfile "/home/{user_name}/work/.gitignore_global"` (OPTIONAL)

#### 3.7. Вывод текущей ветки GIT в консоли (OPTIONAL)
- `sudo mcedit /home/{user_name}/.bashrc`

Найти блок кода:
<pre>
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
</pre>

Закомментировать его и вставить ниже другой блок:
<pre>
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]$(parse_git_branch)\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)\$ '
fi
</pre>

#### 3.8. Установка make утилиты (OPTIONAL)
- `sudo apt install make`

#### 3.9. установка net-tools утилиты (OPTIONAL)
- `sudo apt install net-tools`
- `ifconfig` // проверка, что утилита установилась

### 4. Установка и настройка Docker
> **ПОДРОБНЕЕ:**\
> https://docs.docker.com/engine/install/ubuntu/

#### 4.1 Установка Docker
- `sudo apt-get update`
- `sudo apt-get install ca-certificates curl gnupg lsb-release`

- `sudo mkdir -m 0755 -p /etc/apt/keyrings`
- `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg`

- `echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null`

- `sudo apt-get update`
- `sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`
- `sudo usermod -aG docker ${USER}`

> **ВНИМАНИЕ:**\
> После установки докера, могут возникнуть проблемы с интернетом, в `/etc/resolv.conf` начинает записываться DNS связанный с докером;
> Может помочь настройка в `wsl.conf` (https://docs.microsoft.com/en-us/windows/wsl/wsl-config):
> <pre>
> [network]
> generateResolvConf = false
> </pre>
> А также перезайти в консоль и создать `/etc/resolv.conf` и в нём прописать `DNS 8.8.8.8`,
> Но он не всегда работает, тогда нужно прописать DNS возвращаемый VPN или роутером
> (гарантированно подходит старый DNS содержащийся в `/etc/resolv.conf` до установки докера)

#### 4.2 Для поддержки команды docker-compose (OPTIONAL)
- `echo 'docker compose "$@"' | sudo tee /usr/bin/docker-compose > /dev/null`
- `sudo chmod +x /usr/bin/docker-compose`

#### 4.3 Проверка, что Docker установился
- `docker version`
- `docker compose version`
- `docker-compose version` // может сразу не сработать, тогда необходимо перезайти в консоль

#### 4.4 Запуск Docker Daemon и его проверка
> **ПОДРОБНЕЕ:**
> - https://docs.docker.com/engine/reference/commandline/dockerd/
> - https://docs.docker.com/config/daemon/systemd/#custom-docker-daemon-options

- `sudo service docker start` // может сразу не сработать, тогда необходимо перезайти в консоль
- `sudo cat /var/log/docker.log`

> **ВАЖНО**:
> - команду `sudo service docker start` необходимо запускать каждый раз при старте Linux
> - или можно создать файл `/etc/init-wsl`, поместить туда `service docker start`,
далее создать bat файл со стартом виртуалки, например: `wsl -d {image_name} -u root /etc/init-wsl`
> - для `Windows 11` есть решение проще, достаточно в `wsl.conf` добавить:
> <pre>
> [boot]
> command = service docker start
> </pre>

#### 5. Установка и настройка Go (OPTIONAL)
> **ПОДРОБНЕЕ:**\
> https://www.jetbrains.com/help/go/how-to-use-wsl-development-environment-in-product.html

#### 5.1. Установка Go
- `wget https://go.dev/dl/go1.22.6.linux-amd64.tar.gz`
- `tar -C /usr/local -xzf go1.22.6.linux-amd64.tar.gz`

#### 5.2. Добавление Go переменных устанавливаемых при входе в консоль
- `mkdir /home/{user_name}/work/.cache/golang`
- `mcedit /home/{user_name}/.bashrc`

- Добавить в конец файла:
<pre>
export GOROOT=/usr/local/go
export GOPATH=$HOME/work/.cache/golang
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
</pre>

Инсталляция и настройка системы завершена.

#### 6. Windows команды управления образами Linux для их быстрого бекапа и развёртывания
> **ПОДРОБНЕЕ:**\
> https://drupeople.ru/article/kak-izmenit-raspolozhenie-virtualnogo-diska-docker-windows

**Команды для `Windows PowerShell`:**
1. `wsl --list -v` // список образов Linux
2. `wsl --set-default-version 2` // установка wsl2 (бывает, что по умолчанию используется wsl1)
3. `wsl --shutdown` // остановка всех запущенных образов Linux
4. `wsl --export {image_name} "{backup_dir}\{image_name}.tar"` // экспорт бэкапа указанного образа Linux (только в состоянии Stopped), где {image_name} - название образа из wsl --list, {backup_dir} - директория куда будет выгружен бекап образа
5. `wsl --import {image_name} "{wsl_dir}" "{backup_dir}\{image_name}.tar" --version 2` // импорт бэкапа указанного образа Linux, где {image_name} - название образа из wsl --list, {wsl_dir} - директория где будет находиться образ, {backup_dir} - директория к бэкапу образа
6. `wsl --unregister {image_name}` // удаление указанного образа Linux, где {image_name} - название образа

**Команды для `Windows CMD` (от имени администратора):**
Для монтирования директории WSL, необходимо сделать следующее:
`mklink /D {windows_dir} \\wsl.localhost\{image_name}\home\{user_name}\work`, где {windows_dir}=C:\sample_work_dir

#### 7. Связь хостовой машины с WSL (сетевые настройки)

**Команды для `Windows PowerShell`:**
1. `wsl hostname -I` // ${WSL_IP} - wsl's IP (как правило, первый в списке)
2. `http://${WSL_IP}:8080` // пример открытия WSL ресурса по 8080 порту
3. `netsh interface portproxy show v4tov4` // список проброшенных портов с хостовой машины на WSL;
4. `netsh interface portproxy add v4tov4 listenport=8080 listenaddress=0.0.0.0 connectport=8080 connectaddress=${WSL_IP}` // пример проброски 8080 порта на ${WSL_IP};
5. `netsh interface portproxy delete v4tov4 listenport=8080 listenaddress=0.0.0.0` // пример удаления 8080 порта;

**Команды для `WSL (Linux)`:**
1. `ip route show`; // wsl's + doker's IP
2. `ip add | grep eth0`; // wsl's IP
3. `ip add | grep docker0`; // doker's IP

#### 8. Создание бекапа Linux системы
- остановить систему (команда 5.3);
- создать бекап (команда 5.4);
- убедиться, что бекап создан;

#### 9. Перенос Linux системы на любой другой диск (по умолчанию устанавливается на диск C):
- проделать все шаги пункта 5;
- удалить установленную систему (команда 5.6);
- развернуть систему из бекапа в нужной директории (команда 5.5); 

### 10. Установка и настройка проекта в Linux системе
- установить любой проект, который нужен на виртуальной машине;
- сделать бэкап проекта;
- начать использовать;

Это позволяет делать независимые Linux образы для разных проектов и быстро возвращаться к ним.

### 11. Подключение к Docker из вне
Добавить в файл /etc/docker/daemon.json:
<pre>
{"hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"]}
</pre>

> **ПОДРОБНЕЕ:**\
> https://stackoverflow.com/questions/63416280/how-to-expose-docker-tcp-socket-on-wsl2-wsl-installed-docker-not-docker-deskt

> Проблемы пользователей хостовой машины и докер контейнера:\
> https://jtreminio.com/blog/running-docker-containers-as-current-host-user/
