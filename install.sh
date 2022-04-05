#!/usr/bin/env bash
set -e

daili='https://git.metauniverse-cn.com/'

install_depend(){
    echo -e "\n1.开始安装所需依赖\n"
    echo -e "#机器人所需依赖" >>/ql/data/config/extra.sh
    # 包依赖
    apk add zlib zlib-dev libjpeg-turbo libjpeg-turbo-dev gcc python3-dev libffi-dev musl-dev linux-headers
    # 模块依赖
    pip3 install qrcode==7.3.1 Telethon==1.24.0 requests==2.27.1 Pillow==9.0.0 python-socks==1.2.4 async_timeout==4.0.2 prettytable==3.0.0

    if [ `grep "#机器人所需依赖" /ql/data/config/extra.sh` ];then
        echo "已设置重启青龙自动启动机器人"
    else
        echo -e "解决重启青龙后，jbot失效问题~"
        echo 'apk add zlib zlib-dev libjpeg-turbo libjpeg-turbo-dev gcc python3-dev libffi-dev musl-dev linux-headers' >>/ql/data/config/extra.sh
        echo 'pip3 install qrcode==7.3.1 Telethon==1.24.0 requests==2.27.1 Pillow==9.0.0 python-socks==1.2.4 async_timeout==4.0.2 prettytable==3.0.0' >>/ql/data/config/extra.sh
        echo 'cd /ql/data/jbot  && pm2 start ecosystem.config.js' >>/ql/data/config/extra.sh
        echo 'cd /ql/data/ && pm2 start jbot' >>/ql/data/config/extra.sh
    fi

}

gitPull(){
    echo -e "\n2.开始拉取所需代码\n"
    if [ ! -d /ql/data/jbot ]; then
        mkdir /ql/data/jbot
    else
        rm -rf /ql/data/jbot/*
    fi

    if [ ! -d /ql/data/scripts ];then
        # 青龙新版文件路径
        ln -sf /ql/data/data/scripts /ql/data/
    fi

    cd /ql/data/repo && git clone ${daili}https://github.com/curtinlv/gd.git
    cp -a /ql/data/repo/gd/* /ql/data/jbot && cp -a /ql/data/jbot/conf/* /ql/data/config && cp -a /ql/data/jbot/jk_script/* /ql/data/scripts
    rm -rf /ql/data/repo/dockerbot
    mkdir /ql/data/repo/dockerbot && ln -sf /ql/data/repo/gd /ql/data/repo/dockerbot/jbot
    if [ ! -d /ql/data/log/bot ]; then
        mkdir /ql/data/log/bot
    fi

}

# start

echo
echo -e "\n\t\t\t【青龙安装Bot监控】\n"
echo
if [ -f /ql/data/jbot/user/user.py ];then
    echo -e "\n你已部署，请启动即可:\ncd /ql\npython3 -m jbot\n\n或参考本仓库第3-4步:\nhttps://github.com/curtinlv/gd/blob/main/README.md\n"
    echo -e "如果需要重新部署，请复制以下命令执行："
    echo -e "\nrm -rf  /ql/data/jbot/*  &&   bash  install.sh\n"
    exit 0
fi
install_depend
gitPull
echo -e "\n*******************\n所需环境已部署完成\n*******************\n"
echo -e "请配置tg机器人参数，再启动机器人即可。\n参考本仓库第3-4步:\nhttps://github.com/curtinlv/gd/blob/main/README.md "
