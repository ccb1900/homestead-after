#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.
echo '开始执行自定义命令\n'
#####中国镜像配置####################
registry=`yarn config get registry`
if [ "$registry"x == "https://registry.npm.taobao.org"x ]; then
    echo 'yarn镜像已经是淘宝镜像\n'
else
    yarn config set registry 'https://registry.npm.taobao.org'
    echo 'yarn镜像修改成功\n'
fi


echo '修改npm镜像\n'
registry=`npm config get registry`
if [ "${registry}x" == "https://registry.npm.taobao.orgx" ]; then
    echo 'npm镜像已经是淘宝镜像\n'
else
    npm --registry=https://registry.npm.taobao.org
    echo 'npm镜像修改成功\n'
fi

echo '修改composer镜像\n'
composer config -g repo.packagist composer https://packagist.phpcomposer.com

####软件安装与更新#############
echo '修改软件源为阿里的\n'
file="/etc/apt/sources.list.bak"
if [ ! -f "$file" ]; then
    echo '修改中。。。\n'
    sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
    block="
deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
    "
    sudo echo "$block" > "/tmp/sources.list"
    sudo mv /tmp/sources.list /etc/apt/sources.list ##修改成功了
else
    echo '已经是阿里的了\n'##已经是阿里的了
fi
echo '安装zsh\n'
if command -v zsh >/dev/null 2>&1; then
  echo 'zsh已经安装\n'
else
  echo 'zsh，不存在的\n'
  sudo apt install zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
echo '更新软件\n'
sudo apt update
sudo apt upgrade -y
sudo apt autoremove
echo '修改默认shell\n'###未生效哦，没有权限。。。
chsh -s /usr/bin/zsh
zsh
