#!/usr/bin/env bash
set -e

daili='https://git.metauniverse-cn.com'

gitPull(){
    echo -e "\n开始更新gd机器人\n"
    rm -rf /ql/data/repo/gd
    cd /ql/data/repo/ && git clone ${daili}/https://github.com/curtinlv/gd.git
    rm -rf /ql/data/repo/dockerbot
    mkdir /ql/data/repo/dockerbot
    ln -sf /ql/data/repo/gd /ql/data/repo/dockerbot/jbot
    pm2 stop jbot && rm -rf /ql/data/jbot/* && cp -a /ql/data/repo/gd/* /ql/data/jbot/ && pm2 start jbot
}

# start

echo
echo -e "\n\t\t\t【更新机器人】\n"
echo
gitPull
echo -e "已完成更新"
