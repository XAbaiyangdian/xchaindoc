#!/bin/bash
xccliHome=${HOME}/.xccli
xcdHome=${HOME}/.xcd
chainId=xachain

echo "> 清除历史数据"
rm -rf ${xcdHome}
rm -rf ${xccliHome}
echo "> 初始化节点配置"
xcd init test follow --chain-id=${chainId} --home=${xcdHome}
echo "> 配置客户端参数"
xccli config output json --home=${xccliHome}
xccli config indent true --home=${xccliHome}
xccli config trust-node true --home=${xccliHome}
xccli config chain-id ${chainId} --home=${xccliHome}
xccli config keyring-backend test --home=${xccliHome}
echo "注: 需将要加入网络的创世文件拷贝到当前节点的配置目录 ${HOME}/.xcd/config"