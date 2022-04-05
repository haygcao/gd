



<h1 align="center">
  青龙安装Bot监控
  <br>
</h1>


## 1.进入容器内

``` bash
# 进入青龙容器内，“qinglong” 为容器名字。
docker exec -it qinglong /bin/bash
```

## 2.安装依赖

- [x] 一键安装

```
wget https://raw.githubusercontent.com/haygcao/gd/main/install.sh && bash install.sh
```

- [ ] 人工安装

``` bash
# 操作环境，容器内执行。如果一键安装完成，就不用执行这一块。
# 包依赖
apk add zlib zlib-dev libjpeg-turbo libjpeg-turbo-dev gcc python3-dev libffi-dev musl-dev linux-headers

# 模块依赖
pip3 install qrcode==7.3.1 Telethon==1.24.0 requests==2.27.1 Pillow==9.0.0 python-socks==1.2.4 async_timeout==4.0.2 prettytable==3.0.0

# 拉取jbot主要代码
cd /ql/repo && git clone https://github.com/curtinlv/gd.git
cp -a /ql/repo/gd/* /ql/jbot && cp -a /ql/jbot/conf/* /ql/config 
cp -a /ql/jbot/jk_script/* /ql/scripts
mkdir /ql/log/bot

```



## 3.配置tg机器人参数

```bash
# 操作环境，容器内:
# 机器人登录相关参数，存放路径：
## 填写参考：https://raw.githubusercontent.com/curtinlv/gd/main/conf/bot.json
vi /ql/config/bot.json

# 监控频道相关参数，存放路径：
## 填写参考：https://raw.githubusercontent.com/curtinlv/gd/main/conf/diybotset.json
vi /ql/config/diybotset.json

```



## 4.启动机器人

```bash
# 操作环境，容器内:
## 删除历史登录session
rm -f /ql/config/user.session

# 首次启动，按照提示登录tg，填手机号格式0086xxxxxxxx
cd /ql
python3 -m jbot

```

![图1：首次登录授权个人tg](https://raw.githubusercontent.com/curtinlv/gd/main/img/p1.png)

### ∆出现以上提示，即登录成功，按`ctrl+c `终止，继续以下操作：

```bash
# 通过pm2 后台启动，除了登录验证外，建议使用pm2启动机器人
cd /ql/data/jbot/
pm2 start ecosystem.config.js #第一次启动是这样启动，后续启动参考底部相关命令

# 查看日志：看看有没有报错。
tail -100f /ql/log/bot/run.log
#终止查看日志 按 Ctrl+C


```

​																

- [x] 如tg机器人给你发以下信息，证明你填写的机器人参数是正确的∆。

![图2：完成登录，tg机器人发通知](https://raw.githubusercontent.com/curtinlv/gd/main/img/p2.png)

- [x] 发送【user?】 给你的机器人，有以下回复，证明你通过号码成功授权登录。

![图3：测试1](https://raw.githubusercontent.com/curtinlv/gd/main/img/p3.png)

- [x] 在所监控的频道发出变量，机器人会马上通知：

![图4：测试2](https://raw.githubusercontent.com/curtinlv/gd/main/img/p4.png)



<h1 align="center">
  恭喜你，部署已完成。
  <br>
</h1>






```bash
#################### 相关命令 ####################
操作环境：进入容器内
## 查看机器人运行状态
pm2 status jbot

## 启动机器人：
pm2 start jbot

## 停止机器人
pm2 stop jbot

## 重启机器人
pm2 restart jbot

```



## 更新 

- 2022.3.28 
  - 新增自定义监控配置文件，详见 conf/jk.json

```bash
首次更新方式：
1、以发送机器人命令方式：
# 下载自定义监控配置文件 jk.json
/cmd cd /ql/config && wget https://git.metauniverse-cn.com/https://raw.githubusercontent.com/curtinlv/gd/main/conf/jk.json
# 更新user.py
/cmd cd /ql/jbot/user && rm -f user.py  && wget https://git.metauniverse-cn.com/https://raw.githubusercontent.com/curtinlv/gd/main/user/user.py
# 更新 utils.py
/cmd cd /ql/jbot/diy && rm -f utils.py  && wget https://git.metauniverse-cn.com/https://raw.githubusercontent.com/curtinlv/gd/main/diy/utils.py
# 重启机器人生效
/restart

2.ssh进入容器方式：
# 下载自定义监控配置文件 jk.json
cd /ql/repo/gd && git pull  && cp -a /ql/repo/gd/conf/jk.json /ql/config
# 更新user.py
rm -f /ql/jbot/user/user.py && cp -a /ql/repo/gd/user/user.py /ql/jbot/user/user.py
# 更新 utils.py
rm -f /ql/jbot/diy/utils.py && cp -a /ql/repo/gd/diy/utils.py /ql/jbot/diy/utils.py
# 重启机器人生效
pm2 restart jbot


PS：后续只需修改 jk.json 配置文件，自己定义变量监控和应对执行脚本即可。修改完，需重启机器人生效。


```

* 2022.4.3  (v1.1)

  - 增加队列

  - 修复开卡变量配置问题
  - 增加机器人指令 /upgd  #更新监控程序

  ```bash
  PS:第一次的部署的按照上面教程即可，以下命令仅适合部署过的。
  #【更新方法1】进入容器：
  docker exec -it qinglong /bin/bash
  #停止机器人
  pm2 stop jbot
  #更新代码
  rm -rf /ql/repo/gd
  cd /ql/repo/ && git clone https://git.metauniverse-cn.com/https://github.com/curtinlv/gd.git
  rm -rf /ql/jbot/*
  cp -a /ql/repo/gd/* /ql/jbot/
  #启动机器人
  pm2 start jbot
  
  #【更新方法2】发给机器人指令, 这是一行命令，整行复制，不能换行！
  /cmd rm -rf /ql/repo/gd && cd /ql/repo/ && git clone https://git.metauniverse-cn.com/https://github.com/curtinlv/gd.git && pm2 stop jbot ; rm -rf /ql/jbot/* && cp -a /ql/repo/gd/* /ql/jbot/ ; pm2 start jbot
  
  #适配青龙，以防重启后失效
  rm -rf /ql/repo/dockerbot
  mkdir /ql/repo/dockerbot
  ln -sf /ql/repo/gd /ql/repo/dockerbot/jbot
  echo 'apk add zlib zlib-dev libjpeg-turbo libjpeg-turbo-dev gcc python3-dev libffi-dev musl-dev linux-headers' >>/ql/config/extra.sh
  echo 'pip3 install qrcode==7.3.1 Telethon==1.24.0 requests==2.27.1 Pillow==9.0.0 python-socks==1.2.4 async_timeout==4.0.2 prettytable==3.0.0' >>/ql/config/extra.sh
  echo 'cd /ql/jbot  && pm2 start ecosystem.config.js' >>/ql/config/extra.sh
  echo 'cd /ql/ && pm2 start jbot' >>/ql/config/extra.sh
  
  #2.12新版路径临时解决方法
  ln -sf /ql/data/scripts /ql/
  
  ```


* 2022.4.4 (v1.2)

  * 增加监控明细查询
  * 修复 /upgd （指令更新监控程序，后续本仓库更新，可直接通过此指令一键更新。）

  ```bash
  PS:第一次的部署的按照上面教程即可，以下命令仅适合部署过的。
  #【更新方法1】进入容器：
  docker exec -it qinglong /bin/bash
  # 直接复制执行，这是一条命令，不能换行。
  rm -rf /ql/repo/gd && cd /ql/repo/ && git clone https://git.metauniverse-cn.com/https://github.com/curtinlv/gd.git && pm2 stop jbot ; rm -rf /ql/jbot/* && cp -a /ql/repo/gd/* /ql/jbot/ ; pm2 start jbot
  
  #【更新方法2】发给机器人指令, 这是一行命令，整行复制，不能换行！
  /cmd rm -rf /ql/repo/gd && cd /ql/repo/ && git clone https://git.metauniverse-cn.com/https://github.com/curtinlv/gd.git && pm2 stop jbot ; rm -rf /ql/jbot/* && cp -a /ql/repo/gd/* /ql/jbot/ ; pm2 start jbot
  
  ```

* 2022.4.4(v1.2.1)

  * 新增一键更新脚本

  ```bash
  #本地执行
  bash update.sh
  # 一键更新
  cd /ql && wget https://raw.githubusercontent.com/curtinlv/gd/main/update.sh && nohup bash update.sh 2>&1 >/ql/log/bot/up.log &
  
  #查看更新日志
  tail -100f /ql/log/bot/up.log
  #取消查看日志
  Ctrl+C
  ```

* 2022.4.5(v1.2.2)

  * 增加队列判断去重，解决同时触发同一变量多加符合问题！

  ```bash
  发送指令给机器人更新
  /upgd
  
  或一键更新
  cd /ql && rm -f update.sh* && wget -q https://git.metauniverse-cn.com/https://raw.githubusercontent.com/curtinlv/gd/main/update.sh && nohup bash update.sh 2>&1 >/ql/log/bot/up.log &
  ```

  

# 特别感谢
- 脚本的写作参考了:
  - [SuMaiKaDe](https://github.com/SuMaiKaDe) 的 [bot](https://github.com/SuMaiKaDe/bot) 仓库
  - [chiupam](https://github.com/chiupam) 的 [JD_Diy](https://github.com/chiupam/JD_Diy) 仓库
  - [msechen](https://github.com/msechen) 的 [jdrain](https://github.com/msechen/jdrain) 仓库
  - 未完待定
