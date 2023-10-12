# 命令行部署

## 环境准备
- 节点进程命令行工具

  [xcd](https://github.com/XAbaiyangdian/xchaindoc/raw/master/source/deployment/cmd/xcd)
- 客户端命令行工具

  [xccli](https://github.com/XAbaiyangdian/xchaindoc/raw/master/source/deployment/cmd/xccli)
- 合约依赖的动态库

  [libwasmvm.x86_64.so](https://github.com/XAbaiyangdian/xchaindoc/raw/master/source/deployment/cmd/libwasmvm.x86_64.so)
- 创世节点初始化脚本

  [init_genesis.sh](https://github.com/XAbaiyangdian/xchaindoc/raw/master/source/deployment/cmd/init_genesis.sh)
- 普通节点初始化脚本

  [init_follow.sh](https://github.com/XAbaiyangdian/xchaindoc/raw/master/source/deployment/cmd/init_follow.sh)

- 两个命令行工具移到用户可执行文件目录
```shell script
> mv xcd /usr/local/bin
> mv xccli /usr/local/bin
```
- 加载动态库
```shell script
> mv libwasmvm.x86_64.so /lib & /sbin/ldconfig -v
```

- 初始化脚本的可执行权限
```shell script
> chmod +x init_genesis.sh
> chmod +x init_follow.sh
```
## 部署网络

### 启动创世节点

- 执行初始化脚本
```shell script
> ./init_genesis.sh
```
- 启动创世节点
```shell script
> xcd start --rpc.laddr="tcp://0.0.0.0:26657"
I[2022-08-01|18:10:41.239] starting ABCI with Tendermint                module=main 
!!!!!!!!NewNode enter, consensusPlugin: pbft 
!!!!!!!!!!createBlockchainReactor, fastsync version: v0 
I[2022-08-01|18:10:46.310] Executed block                               module=state height=1 validTxs=0 invalidTxs=0
I[2022-08-01|18:10:46.495] Committed state                              module=state height=1 txs=0 appHash=5113DD54A099F1777BCB18072D08451FE204D31ADF21701BED646E7E73D642D9
```

- 查看节点状态：
```shell script
> xccli status
{
  "node_info": {
    "protocol_version": {
      "p2p": "7",
      "block": "10",
      "app": "0"
    },
    "id": "e5fea26c8872b9c3fda27aa4a864d85bbc9729a7",
    "listen_addr": "tcp://0.0.0.0:26656",
    "network": "xachain",
    "version": "1.3.0",
    "channels": "4030382021222300",
    "moniker": "test",
    "other": {
      "tx_index": "on",
      "rpc_address": "tcp://0.0.0.0:26657"
    },
    "validator_addr": "96CEF0E1715D2263CE14738C34AF544CD88729A5"
  },
  "sync_info": {
    "latest_block_hash": "C6F1B29673855F640D608CF48791F4922AA7FE0234C9CFA8C8E4F4C55F083F53",
    "latest_app_hash": "5113DD54A099F1777BCB18072D08451FE204D31ADF21701BED646E7E73D642D9",
    "latest_block_height": "3",
    "latest_block_time": "2022-08-01T10:10:51.334572035Z",
    "earliest_block_hash": "D35D2ACD79FEAFD10CF70F29D9D789A008AE59E79FE57587CFD343DA8FED1241",
    "earliest_app_hash": "",
    "earliest_block_height": "1",
    "earliest_block_time": "2022-08-01T10:10:38.15978414Z",
    "catching_up": false
  },
  "validator_info": {
    "address": "96CEF0E1715D2263CE14738C34AF544CD88729A5",
    "pub_key": {
      "type": "tendermint/PubKeySm2",
      "value": "AghqcZh8JIcmOrnftJcvQaRiNkYDlJ3ofer5J16A7BmM"
    },
    "voting_power": "100"
  }
}

```

### 新建节点并加入网络（不同宿主机）

- 执行初始化脚本
```shell script
> ./init_follow.sh
```

- 获取要加入网络的创世配置文件
```shell script
> cp [${genesis_home}/.xcd/config/genesis.json] ${current_home}/.xcd/config/
```

- 查看创世节点的nodeid
```shell script
# 在创世节点宿主机执行
> xcd tendermint show-node-id
e5fea26c8872b9c3fda27aa4a864d85bbc9729a7
```

- 启动新节点并连接创世节点
```shell script
# [IP]为创世节点的IP地址
> xcd start --p2p.persistent_peers=e5fea26c8872b9c3fda27aa4a864d85bbc9729a7@[IP]:26656
```

这时新节点还未能通过创世节点同步区块，需要将新节点的节点地址加入区块链网络中并赋予peer角色。

- 查看新节点的节点地址
```shell script
> xcd tendermint show-node-address
xchain1ma3sxsnutd9mns4phxj3qkmxtq6ny9jw2xlkvs
```

- 在创世节点发起添加账户交易
```shell script
# 在创世节点宿主机执行
> xccli tx member addAccount xchain1ma3sxsnutd9mns4phxj3qkmxtq6ny9jw2xlkvs org1 peer --from org1Admin -y
{
  "height": "0",
  "txhash": "BF4381F5F30A9A17151A8211DA3FD2714BCCC8B686E5BD2C1E6119DA398474C4"
}
```

拥有两个节点的区块链网络建设完成。