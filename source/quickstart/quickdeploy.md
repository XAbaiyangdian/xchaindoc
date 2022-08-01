# 快速部署

## 环境准备
- 安装docker：

```shell script
> curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```

- 下载xchain镜像：

  [xchain.tar](https://xchain-1306199973.cos.ap-beijing.myqcloud.com/image/xchain.tar)

- 加载xchain镜像：

```shell script
docker load < xchain.tar   
```
- 查看镜像

```shell script
> docker images
REPOSITORY              TAG        IMAGE ID       CREATED         SIZE
xchain                  latest     22ebd18c8fbe   9 minutes ago   165MB
```

## 部署网络

### 启动创世节点

- 启动创世节点
```shell script
> docker run -d --name xchain1 \
     -v /data/node1/.xcd:/root/.xcd \
     -v /data/node1/.xccli:/root/.xccli \
     -p 26656:26656 \
     -p 26657:26657 \
     xchain:latest

> docker ps
CONTAINER ID   IMAGE           COMMAND                  CREATED         STATUS         PORTS                                                                   NAMES
eface923382c   xchain:latest   "/bin/sh /root/start…"   3 seconds ago   Up 2 seconds   0.0.0.0:26656-26657->26656-26657/tcp, :::26656-26657->26656-26657/tcp   xchain1
```

- 查看节点日志
```shell script
> docker logs -f xchain1
xcd start --rpc.laddr=tcp://0.0.0.0:26657
I[2022-07-04|07:32:58.450] starting ABCI with Tendermint                module=main 
!!!!!!!!NewNode enter, consensusPlugin: pbft 
!!!!!!!!!!createBlockchainReactor, fastsync version: v0 
I[2022-07-04|07:33:03.577] Executed block                               module=state height=1 validTxs=0 invalidTxs=0
I[2022-07-04|07:33:03.583] Committed state                              module=state height=1 txs=0 appHash=3D707D36DF8A8E0E104FBF168F92380DEB8985406D992D4AF50964A04D9E4DE2
I[2022-07-04|07:33:08.594] Executed block                               module=state height=2 validTxs=0 invalidTxs=0
I[2022-07-04|07:33:08.596] Committed state                              module=state height=2 txs=0 appHash=3D707D36DF8A8E0E104FBF168F92380DEB8985406D992D4AF50964A04D9E4DE2
I[2022-07-04|07:33:13.607] Executed block                               module=state height=3 validTxs=0 invalidTxs=0
I[2022-07-04|07:33:13.609] Committed state                              module=state height=3 txs=0 appHash=3D707D36DF8A8E0E104FBF168F92380DEB8985406D992D4AF50964A04D9E4DE2
I[2022-07-04|07:33:18.630] Executed block                               module=state height=4 validTxs=0 invalidTxs=0
I[2022-07-04|07:33:18.632] Committed state                              module=state height=4 txs=0 appHash=3D707D36DF8A8E0E104FBF168F92380DEB8985406D992D4AF50964A04D9E4DE2
```

- 查看节点状态：

```shell script
> docker exec xchain1 xccli status
{
  "node_info": {
    "protocol_version": {
      "p2p": "7",
      "block": "10",
      "app": "0"
    },
    "id": "ce86356fcb03a6f1f9b0296d774dca8daa5f39af",
    "listen_addr": "tcp://0.0.0.0:26656",
    "network": "xachain",
    "version": "1.3.0",
    "channels": "4030382021222300",
    "moniker": "test",
    "other": {
      "tx_index": "on",
      "rpc_address": "tcp://0.0.0.0:26657"
    },
    "validator_addr": "F87AD64DD24129C257FFDE8B76D1F09716A90BF0"
  },
  "sync_info": {
    "latest_block_hash": "8D892C7B37744D89018CAEF3FC401380EF7D2D3A18B5D47A0CDDBA102C1F57B9",
    "latest_app_hash": "3D707D36DF8A8E0E104FBF168F92380DEB8985406D992D4AF50964A04D9E4DE2",
    "latest_block_height": "82",
    "latest_block_time": "2022-07-04T07:39:45.02626088Z",
    "earliest_block_hash": "20BE1477D82EAD9B66C810DA7307C5274ECD119D9F0A52526638DE4EDA531325",
    "earliest_app_hash": "",
    "earliest_block_height": "1",
    "earliest_block_time": "2022-07-04T07:32:56.417565882Z",
    "catching_up": false
  },
  "validator_info": {
    "address": "F87AD64DD24129C257FFDE8B76D1F09716A90BF0",
    "pub_key": {
      "type": "tendermint/PubKeySm2",
      "value": "AwBTnQxuy2rKjpUpZAmLQbvHEgz9AiPqynHUiXENxOwG"
    },
    "voting_power": "100"
  }- 
}
```

### 新建节点并加入网络

- 准备新节点的配置目录
```shell script
> mkdir -p /data/node2/.xcd/config/
```

- 获取要加入网络的创世配置文件
```shell script
> docker cp xchain1:/root/.xcd/config/genesis.json /data/node2/.xcd/config/
```

- 查看创世节点的nodeid
```shell script
> docker exec xchain1 xcd tendermint show-node-id
ce86356fcb03a6f1f9b0296d774dca8daa5f39af
```

- 启动新节点并连接创世节点
```shell script
> docker run -d --name xchain2 \
              -v /data/node2/.xcd:/root/.xcd \
              -v /data/node2/.xccli:/root/.xccli \
              -p 26666:26656 \
              -p 26667:26657 \
              -e NODEORDER=follow \
              --link xchain1:xchain1 \
              xchain:latest --p2p.persistent_peers=ce86356fcb03a6f1f9b0296d774dca8daa5f39af@xchain1:26656
```

这时新节点还未能通过创世节点同步区块，需要将新节点的节点地址加入区块链网络中并赋予peer角色。

- 查看新节点的节点地址
```shell script
> docker exec xchain2 xcd tendermint show-node-address
xchain1ma3sxsnutd9mns4phxj3qkmxtq6ny9jw2xlkvs
```

- 在创世节点发起添加账户交易
```shell script
> docker exec xchain1 xccli tx member addAccount xchain1ma3sxsnutd9mns4phxj3qkmxtq6ny9jw2xlkvs org1 peer --from org1Admin -y
{
  "height": "0",
  "txhash": "BF4381F5F30A9A17151A8211DA3FD2714BCCC8B686E5BD2C1E6119DA398474C4"
}
```

- 查看节点日志
```shell script
> docker logs -f xchain2
I[2022-07-04|08:08:37.851] starting ABCI with Tendermint                module=main 
!!!!!!!!NewNode enter, consensusPlugin: pbft 
!!!!!!!!!!createBlockchainReactor, fastsync version: v0 
E[2022-07-04|08:08:37.894] Can't add peer's address to addrbook         module=p2p err="Cannot add non-routable address ce86356fcb03a6f1f9b0296d774dca8daa5f39af@172.17.0.2:26656"
E[2022-07-04|08:08:40.401] Stopping peer for error                      module=p2p peer="Peer{MConn{172.17.0.2:26656} ce86356fcb03a6f1f9b0296d774dca8daa5f39af out}" err=EOF
E[2022-07-04|08:08:45.422] Stopping peer for error                      module=p2p peer="Peer{MConn{172.17.0.2:26656} ce86356fcb03a6f1f9b0296d774dca8daa5f39af out}" err=EOF
E[2022-07-04|08:08:50.444] Stopping peer for error                      module=p2p peer="Peer{MConn{172.17.0.2:26656} ce86356fcb03a6f1f9b0296d774dca8daa5f39af out}" err=EOF
E[2022-07-04|08:08:55.457] Stopping peer for error                      module=p2p peer="Peer{MConn{172.17.0.2:26656} ce86356fcb03a6f1f9b0296d774dca8daa5f39af out}" err=EOF
E[2022-07-04|08:09:00.469] Stopping peer for error                      module=p2p peer="Peer{MConn{172.17.0.2:26656} ce86356fcb03a6f1f9b0296d774dca8daa5f39af out}" err=EOF
I[2022-07-04|08:09:05.698] Executed block                               module=state height=1 validTxs=0 invalidTxs=0
I[2022-07-04|08:09:05.700] Committed state                              module=state height=1 txs=0 appHash=3D707D36DF8A8E0E104FBF168F92380DEB8985406D992D4AF50964A04D9E4DE2
I[2022-07-04|08:09:05.704] Executed block                               module=state height=2 validTxs=0 invalidTxs=0
I[2022-07-04|08:09:05.705] Committed state                              module=state height=2 txs=0 appHash=3D707D36DF8A8E0E104FBF168F92380DEB8985406D992D4AF50964A04D9E4DE2
I[2022-07-04|08:09:07.118] Executed block                               module=state height=3 validTxs=0 invalidTxs=0
I[2022-07-04|08:09:07.119] Committed state                              module=state height=3 txs=0 appHash=3D707D36DF8A8E0E104FBF168F92380DEB8985406D992D4AF50964A04D9E4DE2
I[2022-07-04|08:09:07.123] Executed block                               module=state height=4 validTxs=0 invalidTxs=0
I[2022-07-04|08:09:07.124] Committed state                              module=state height=4 txs=0 appHash=3D707D36DF8A8E0E104FBF168F92380DEB8985406D992D4AF50964A04D9E4DE2
I[2022-07-04|08:09:07.127] Executed block                               module=state height=5 validTxs=0 invalidTxs=0
I[2022-07-04|08:09:07.128] Committed state                              module=state height=5 txs=0 appHash=3D707D36DF8A8E0E104FBF168F92380DEB8985406D992D4AF50964A04D9E4DE2
I[2022-07-04|08:09:07.133] Executed block                               module=state height=6 validTxs=0 invalidTxs=0
I[2022-07-04|08:09:07.135] Committed state                              module=state height=6 txs=0 appHash=3D707D36DF8A8E0E104FBF168F92380DEB8985406D992D4AF50964A04D9E4DE2
```

拥有两个节点的区块链网络建设完成。