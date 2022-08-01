#!/bin/bash
xcclihome=${HOME}/.xccli
xcdhome=${HOME}/.xcd

echo "> 清除历史数据"
rm -rf ${xcdhome}
rm -rf ${xcclihome}
echo "> 初始化节点配置"
xcd init test first --chain-id=xachain --home=${xcdhome}
echo "> 配置客户端参数"
xccli config output json --home=${xcclihome}
xccli config indent true --home=${xcclihome}
xccli config trust-node true --home=${xcclihome}
xccli config chain-id xachain --home=${xcclihome}
xccli config keyring-backend test --home=${xcclihome}
echo "> 创建客户端用户"
xccli keys add jack --home=${xcclihome}
xccli keys add org1Admin --home=${xcclihome}
echo "> 初始化代币"
xcd add-genesis-account $(xccli keys show jack -a --home=${xcclihome}) 1000000000000stake --home=${xcdhome}
xcd add-genesis-token $(xccli keys show jack -a --home=${xcclihome}) coin 800000000 --home=${xcdhome}
echo "> 设置治理投票参数"
xcd add-genesis-voteparameter --effective_threshold 50 --take_effect_threshold 50 --counting_votes false --home=${xcdhome}
echo "> 初始化网络管理员"
xcd add-genesis-admin $(xccli keys show jack -a --home=${xcclihome}) 100 --home=${xcdhome}
echo "> 初始化组织"
xcd add-genesis-org org1 $(xccli keys show org1Admin -a --home=${xcclihome}) $(xcd tendermint show-node-address --home=${xcdhome}) --home=${xcdhome}
echo "> 初始化验证节点"
xcd add-genesis-validator $(xcd tendermint show-validator --home=${xcdhome}) 100 $(xccli keys show jack -a --home=${xcclihome}) --home=${xcdhome}
echo "> 验证配置文件"
xcd validate-genesis --home=${xcdhome}
