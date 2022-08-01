#!/bin/bash
xcclihome=${HOME}/.xccli
xcdhome=${HOME}/.xcd

echo "> 清除历史数据"
rm -rf ${xcdhome}
rm -rf ${xcclihome}
echo "> 初始化节点配置"
xcd init test follow --chain-id=xachain --home=${xcdhome}
echo "> 配置客户端参数"
xccli config output json --home=${xcclihome}
xccli config indent true --home=${xcclihome}
xccli config trust-node true --home=${xcclihome}
xccli config chain-id xachain --home=${xcclihome}
xccli config keyring-backend test --home=${xcclihome}
echo "注: 需将要加入网络的创世文件拷贝到当前节点的配置目录 ${HOME}/.xcd/config"