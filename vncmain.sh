#!/bin/bash
# Set them to empty is NOT SECURE but avoid them display in random logs.

nohup chisel server --proxy http://localhost &
nohup /usr/sbin/sshd -D &

export VNC_PASSWD=''
export USER_PASSWD=''

export TERM=linux

while true; do
    # 检查进程是否存在
    process=`ps aux | grep 'CQ.\.exe'`
    if [ "$process" == '' ]; then
        # 不存在则重启
        wine ~/coolq/CQ?.exe /account $COOLQ_ACCOUNT
        # 进程退出后等待 30 秒后再检查，避免 CQ 自重启导致误判
        sleep 30
    else
        # 存在则说明是别的途径启动的，多等一会儿吧
        sleep 100
    fi
done
