#!/bin/bash

function Install() {
    echo "下载最新的 glider 版本"

    echo "检查 golang 是否存在"

    go version
    # 检查 golang 
    if [ $? -eq 0 ] ; then
        echo "golang 已安装"
    else
        echo "golang 未安装"

        read -p "是否安装 golang (y/n): " isInstallGolang
        if [ $isInstallGolang == "y" ] ; then
            # 安装 golang
            curl -sSL https://raw.githubusercontent.com/zol9527/scripts/main/golang/install_or_upgrade.sh > ~/install_golang.sh && bash ~/install_golang.sh
        else
            echo "退出安装"
            exit 0
        fi
    fi

    # 下载 glider
    echo "准备下载 glider"

    go install github.com/nadoo/glider@latest
}

Install
