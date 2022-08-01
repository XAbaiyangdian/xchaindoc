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


## 单节点部署

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

## 多节点部署

- 安装 jq：
```shell script
ubuntu:
> apt install jq -y

centos:
> yum install jq -y
```

- 获取脚本:

  [xchain_net.sh](https://github.com/XAbaiyangdian/xchaindoc/raw/master/source/deployment/xchain_net.sh)

- 脚本可执行权限:
```shell script
> chmod +x xchain_net.sh
```

- 启动多节点网络:
```shell script
> ./xchain_net.sh up
=================================================
up xchain_net
=================================================
start xchain1
886786a656ee0ac84aee3278e678d49b14d4456cb67a5ec0c1bd980238e5ed2b
start xchain2
0bd7befb7dcfbb017db2e963aa662e908dafcafebe919da833ecfd9feeb5e10b
{
  "height": "0",
  "txhash": "969B524B6EB0D2EB174B455A1123AF9E8B8B68357E65D73152E4356F94824133"
}
start xchain3
7bfb209c37270cfb6326d561daf3b9e60033a885ef16a3e131223cfc06841615
{
  "height": "0",
  "txhash": "02E476FB1D58AA80C2C4888F2A022DEFC6B8A759DC28BBD1DC03DE62CB517069"
}
start xchain4
3ae874132bbcc80e3f092b6c378c84e10f21c0dc6d1c51b18d6266fc1d43225c
{
  "height": "0",
  "txhash": "40D8529CCEF7017DFE127DC00AA1F9826C2DAB9FE3F659BD106E106507D299A0"
}
{
  "height": "0",
  "txhash": "9969B9A712AB88DD223E88659EA26C16701331DB6F156F41FD69FAA88F3ED211"
}
{
  "height": "0",
  "txhash": "6BE7CA852A9E4E01F855F928A61A2A177256F4C8BB4D80646C2E643852B24B5B"
}
{
  "height": "0",
  "txhash": "6EAA41C7F7DD8551051CEE25C7AD7C66CF4EBE45D5EBD47016AA15F54C9A79C4"
}
```

- 查看网络
```shell script
> docker ps
CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS                                                                                          NAMES
3ae874132bbc   xchain:latest   "/bin/sh /root/start…"   17 seconds ago   Up 16 seconds   0.0.0.0:26646->26656/tcp, :::26646->26656/tcp, 0.0.0.0:26647->26657/tcp, :::26647->26657/tcp   xchain4
7bfb209c3727   xchain:latest   "/bin/sh /root/start…"   22 seconds ago   Up 21 seconds   0.0.0.0:26636->26656/tcp, :::26636->26656/tcp, 0.0.0.0:26637->26657/tcp, :::26637->26657/tcp   xchain3
0bd7befb7dcf   xchain:latest   "/bin/sh /root/start…"   27 seconds ago   Up 26 seconds   0.0.0.0:26626->26656/tcp, :::26626->26656/tcp, 0.0.0.0:26627->26657/tcp, :::26627->26657/tcp   xchain2
886786a656ee   xchain:latest   "/bin/sh /root/start…"   37 seconds ago   Up 35 seconds   0.0.0.0:26616->26656/tcp, :::26616->26656/tcp, 0.0.0.0:26617->26657/tcp, :::26617->26657/tcp   xchain1
```

- 关闭网络
```shell script
> ./xchain_net.sh down
=================================================
down xchain_net
=================================================
down xchain1
xchain1
xchain1
down xchain2
xchain2
xchain2
down xchain3
xchain3
xchain3
down xchain4
xchain4
xchain4
```



