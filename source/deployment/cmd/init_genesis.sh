#!/bin/bash
xccliHome=${HOME}/.xccli
xcdHome=${HOME}/.xcd
chainId=xachain

echo "> 清除历史数据"
rm -rf ${xcdHome}
rm -rf ${xccliHome}
echo "> 初始化节点配置"
xcd init test first --chain-id=${chainId} --home=${xcdHome}
echo "> 配置客户端参数"
xccli config output json --home=${xccliHome}
xccli config indent true --home=${xccliHome}
xccli config trust-node true --home=${xccliHome}
xccli config chain-id ${chainId} --home=${xccliHome}
xccli config keyring-backend test --home=${xccliHome}
echo "> 创建客户端用户"
xccli keys add jack --home=${xccliHome}
xccli keys add org1Admin --home=${xccliHome}
echo "> 初始化代币"
xcd add-genesis-account $(xccli keys show jack -a --home=${xccliHome}) 1000000000000stake --home=${xcdHome}
xcd add-genesis-token $(xccli keys show jack -a --home=${xccliHome}) coin 800000000 --home=${xcdHome}
echo "> 设置治理投票参数"
xcd add-genesis-voteparameter --effective_threshold 50 --take_effect_threshold 50 --counting_votes false --home=${xcdHome}
echo "> 初始化网络管理员"
xcd add-genesis-admin $(xccli keys show jack -a --home=${xccliHome}) 100 --home=${xcdHome}
echo "> 初始化组织"
xcd add-genesis-org org1 $(xccli keys show org1Admin -a --home=${xccliHome}) $(xcd tendermint show-node-address --home=${xcdHome}) --home=${xcdHome}
echo "> 初始化验证节点"
xcd add-genesis-validator $(xcd tendermint show-validator --home=${xcdHome}) 100 $(xccli keys show jack -a --home=${xccliHome}) --home=${xcdHome}
echo "> 验证配置文件"
xcd validate-genesis --home=${xcdHome}
