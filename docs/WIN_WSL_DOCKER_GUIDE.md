## Инструкция по установке Ubuntu + Docker + Go под Windows на WSL2

**Перед началом установки, скопируйте текущий документ, замените все ниже приведённые переменные на свои значения, и приступайте к установке:**
<pre>
Vars:
  {linux_name} = Ubuntu 20.04.5 LTS
  {image_name} = Ubuntu-20.04
  {wsl_dir} = d:\wsl\Ubuntu-20.04
  {backup_dir} = d:\backup\wsl\Ubuntu-20.04
  {wsl_swap_file} = d:\\wsl\\Ubuntu-20.04\\swap.vhdx (ВАЖНО: только двойные слеши)
  {user_login} = ivan_ivanov
  {user_email} = ivan.ivanov@localhost
  {user_name_lastname} = Ivan Ivanov
</pre>

### 1. Перед установкой Linux обновить WSL
> **ПОДРОБНЕЕ:**\
> https://learn.microsoft.com/en-us/windows/wsl/install

- Зайти на https://learn.microsoft.com/en-us/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package
- Скачать и установить `WSL2 Linux kernel update package for x64 machines` (wsl_update_x64.msi)
- Зайти в `Windows PowerShell`
- Запустить `wsl --update` // обновление wsl2
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
- `mkdir -p /home/{user_login}/work`
- `mkdir -p /home/{user_login}/work/.cache`

#### 3.4. Добавление настроек пользователя устанавливаемых при входе в консоль (OPTIONAL)
- `mcedit /home/{user_login}/.bashrc`

Добавить в конец файла:
<pre>
export EDITOR=mcedit
cd /home/{user_login}/work 
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
# Run system/service manager, check: systemctl list-unit-files --type=service
[boot]
systemd = true

# Set the user when launching a distribution with WSL
[user]
default = {user_login}
</pre>

> **ПОДРОБНЕЕ:**\
> https://docs.microsoft.com/en-us/windows/wsl/wsl-config

#### 3.6. Настройки GIT
- `git config --global user.email "{user_email}"`
- `git config --global user.name "{user_name_lastname}"`
- `git config --global core.autocrlf input`
- `git config --global core.quotepath off`

- `touch /home/{user_login}/work/.gitignore_global` (OPTIONAL)
- `git config --global core.excludesfile "/home/{user_login}/work/.gitignore_global"` (OPTIONAL)

#### 3.7. Вывод текущей ветки GIT в консоли (OPTIONAL)
- `sudo mcedit /home/{user_login}/.bashrc`

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
> - благодаря опции `systemd = true` в `wsl.conf` команду `sudo service docker start` больше не нужно
> - будет запускать каждый раз при запуске wsl. Но для этого нужно хотя бы раз запустить
> - докер контейнер для того чтобы был создан docker.socket;
> - для `Windows 11` есть возможность в `wsl.conf` прописывать команду, которая будет выполнена при запуске wsl:
> <pre>
> [boot]
> command = service docker start
> </pre>

#### 5. Настройка .wslconfig для эффективной работы wsl и регулирования потребления ресурсов 
> **ПОДРОБНЕЕ:**\
> https://learn.microsoft.com/en-us/windows/wsl/wsl-config

На хостовой машине в директории %USERPROFILE% нужно разместить файл `.wslconfig`, предварительно выставив в нём приемлемые значения параметров:
<pre>
# Settings apply across all Linux distros running on WSL 2
[wsl2]

# Limits VM memory to use no more than N GB, this can be set as whole numbers using GB or MB, default is 50% of available RAM
memory=6GB

# Sets the VM to use N virtual processors, default is the same number of logical processors on Windows
processors=2

# Sets amount of swap storage space to N GB, default is 25% of available RAM
swap=3GB

# Sets swapfile path location, default is %USERPROFILE%\AppData\Local\Temp\swap.vhdx
swapfile={wsl_swap_file}
</pre>

#### 6. Установка и настройка Go (OPTIONAL)
> **ПОДРОБНЕЕ:**\
> https://www.jetbrains.com/help/go/how-to-use-wsl-development-environment-in-product.html

#### 6.1. Установка Go
- Перед этим желательно выбрать свежий дистрибутив https://go.dev/dl/;
- Далее в wsl запустить закачку и распаковку дистрибутива:  
  - `wget https://go.dev/dl/go1.23.3.linux-amd64.tar.gz`;
  - `tar -C /usr/local -xzf go1.23.3.linux-amd64.tar.gz`;
  - `rm ./go1.23.3.linux-amd64.tar.gz`;

#### 6.2. Добавление Go переменных устанавливаемых при входе в консоль
- `mkdir /home/{user_login}/work/.cache/golang`
- `mcedit /home/{user_login}/.bashrc`

- Добавить в конец файла:
<pre>
export GOROOT=/usr/local/go
export GOPATH=$HOME/work/.cache/golang
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
</pre>

Инсталляция и настройка системы завершена.

#### 7. Windows команды управления образами Linux для их быстрого бекапа и развёртывания
> **ПОДРОБНЕЕ:**\
> https://drupeople.ru/article/kak-izmenit-raspolozhenie-virtualnogo-diska-docker-windows

**Команды для `Windows PowerShell`:**
1. `wsl --list -v` // список подключённых к wsl образов Linux
2. `wsl --update` // обновление wsl2
3. `wsl --set-default-version 2` // установка wsl2 (бывает, что по умолчанию используется wsl1)
4. `wsl --shutdown` // остановка всех запущенных образов Linux
5. `wsl --export {image_name} "{backup_dir}\{image_name}.tar"` // экспорт бэкапа указанного образа Linux (только в состоянии Stopped), где {image_name} - название образа из wsl --list, {backup_dir} - директория куда будет выгружен бекап образа
6. `wsl --import {image_name} "{wsl_dir}" "{backup_dir}\{image_name}.tar" --version 2` // импорт бэкапа указанного образа Linux, где {image_name} - название образа из wsl --list, {wsl_dir} - директория где будет находиться образ, {backup_dir} - директория к бэкапу образа
7. `wsl --unregister {image_name}` // удаление указанного образа Linux, где {image_name} - название образа

**Команды для `Windows CMD` (от имени администратора):**
Для монтирования директории WSL, необходимо сделать следующее:
`mklink /D {windows_dir} \\wsl.localhost\{image_name}\home\{user_login}\work`, где {windows_dir}=C:\sample_work_dir

#### 8. Связь хостовой машины с WSL (сетевые настройки)

**Команды для `Windows PowerShell`:**
1. `wsl hostname -I` // ${WSL_IP} - выделенный IP для wsl (как правило, первый в списке)
2. `http://${WSL_IP}:8080` // открывает WSL ресурс на 8080 порту
3. `netsh interface portproxy show v4tov4` // выводит список проброшенных портов с хостовой машины на WSL
4. `netsh interface portproxy add v4tov4 listenport=8080 listenaddress=0.0.0.0 connectport=8080 connectaddress=${WSL_IP}` // пробрасывает 8080 порт на ${WSL_IP}
5. `netsh interface portproxy delete v4tov4 listenport=8080 listenaddress=0.0.0.0` // удаляет проброшенный 8080 порт

**Команды для `WSL (Linux)`:**
1. `ip route show`; // выделенные IP для wsl + doker
2. `ip add | grep eth0`; // выделенный IP для wsl
3. `ip add | grep docker0`; // выделенный IP для doker

#### 9. Создание бекапа Linux системы + перенос Linux системы на любой диск (по умолчанию разворачивается на диске C):
- остановить wsl систему (команда 7.4);
- создать бекап (команда 7.5) и убедиться, что он создан;
- удалить установленную wsl систему (команда 7.7);
- развернуть систему из бекапа в нужной директории (команда 7.5); 

Это позволяет делать независимые Linux образы для разных проектов и быстро возвращаться к ним.

### 10. Подключение к Docker из вне
Добавить в файл /etc/docker/daemon.json:
<pre>
{"hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"]}
</pre>

> **ПОДРОБНЕЕ:**\
> https://stackoverflow.com/questions/63416280/how-to-expose-docker-tcp-socket-on-wsl2-wsl-installed-docker-not-docker-deskt

> Проблемы пользователей хостовой машины и докер контейнера:\
> https://jtreminio.com/blog/running-docker-containers-as-current-host-user/
