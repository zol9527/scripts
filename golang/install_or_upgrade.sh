#!/bin/bash

function UpgradeOrInstallGolang() {

    echo "获取最新的go版本"
    release=$(curl --silent https://go.dev/doc/devel/release | grep -Eo 'go[0-9]+(\.[0-9]+)+' | sort -V | uniq | tail -1)
    echo "最新的go版本是: $release"

    go version

    if [ $? -eq 0 ]; then

        echo "go已安装, 即将升级"
        version=$(go version|cut -d' ' -f 3)

        if [[ $version == "$release" ]]; then
            echo "go已经是最新版本, 无需升级"
            exit 0
        fi

        release="${release}.linux-amd64.tar.gz"
        echo "下载最新的go版本: $release"

        tmp=$(mktemp -d)
        cd $tmp || exit 1

        curl -OL https://go.dev/dl/$release
        sudo rm -rf /usr/local/go ; sudo tar -C /usr/local -xzf $release
        rm -rf $tmp

        source ~/.bashrc
        echo "go升级完成"
        go version
        exit 0
    fi

    echo "go未安装, 即将安装"
    release="${release}.linux-amd64.tar.gz"
    
    tmp=$(mktemp -d)
    cd $tmp || exit 1
    curl -OL https://go.dev/dl/$release
    sudo rm -rf /usr/local/go ; sudo tar -C /usr/local -xzf $release
    rm -rf $tmp

    read -p "是否设置环境变量? [y/n]" answer

    if [[ $answer != "y" ]]; then
        echo "go安装完成"
        exit 0
    fi

    echo "正在设置环境变量"
    {
        echo "export GOROOT=/usr/local/go"
        echo "export GOPATH=\$HOME/go"
        echo "export PATH=\$PATH:\$GOROOT/bin"
    } >> ~/.bashrc

    cd ~
    mkdir $HOME/go

    export GOROOT=/usr/local/go
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOROOT/bin
    echo "go安装完成"
    echo '输入: source ~/.bashrc, 让环境生效, 或重新打开终端.'
    go version
    exit 0
}

UpgradeOrInstallGolang
