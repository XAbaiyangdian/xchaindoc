# 启动网络

加载xchain-alone的docker镜像：

```shell
docker load < xchain-alone.tar   
```

```
> docker load < xchain-alone.tar
bacd3af13903: Loading layer [======================>] 75.27 MB/75.27 MB    9069f84dbbe9: Loading layer [======================>] 15.36 kB/15.36 kB   f6253634dc78: Loading layer [======================>] 3.072 kB/3.072 kB  919ad0064c90: Loading layer [======================>] 88.77 MB/88.77 MB   c600d131639c: Loading layer [======================>]  12.6 MB/12.6 MB     5f70bf18a086: Loading layer [======================>] 1.024 kB/1.024 kB     
Loaded image: xchain-alone:1.0.0
```

```shell
>docker images
REPOSITORY         TAG           IMAGE ID         CREATED          SIZE
xchain-alone       1.0.0         1c8c76fe6c7e     12 days ago      173.1 MB
```

启动docker镜像：

```shell
docker run -d --name=xchain xchain-alone:1.0.0
```

```shell
>docker run -d --name=xchain xchain-alone:1.0.0
f54752ddbd9b050d70615053bcc0bd290b36fff5318256247aa68dca1288df25

>docker ps
CONTAINER ID        IMAGE                COMMAND                  CREATED                  STATUS           PORTS                NAMES
b8fee4e6a926        xchain-alone:1.0.0   "/bin/sh /opt/xchain/"   Less than a second ago   Up 3 seconds     26656-26658/tcp      xchain
```

进入docker镜像：

```shell
docker exec -it xchain /bin/bash
```

查看xchain网络状态，一个简单的单点部署XChain网络场景已随docker启动，该网络包括网络管理组（NetworkOrg）和4个level 1组织（Org），网络管理组有4个网络管理员，每个组织各有1个管理员和1个节点（peer）。配置文件和启动文件已预定义，你无需修改这些配置。：

```
xccli status
```

```
root@f54752ddbd9b:/opt# xccli status
{
  "node_info": {
    "protocol_version": {
      "p2p": "7",
      "block": "10",
      "app": "0"
    },
    "id": "1563d78a654fbcd238f5bd6acf3700f066544561",
    "listen_addr": "tcp://0.0.0.0:26656",
    "network": "xchain",
    "version": "0.33.8",
    "channels": "4020212223303800",
    "moniker": "node01",
    "other": {
      "tx_index": "on",
      "rpc_address": "tcp://0.0.0.0:26657"
    }
  },
  "sync_info": {
    "latest_block_hash": "DD863E05EB70224AF9E0160B9E57100A424D41FE95D5DF17A0BF555754788354",
    "latest_app_hash": "32298BE2D8A95C0F0692C03FD641ADE32153BB5D8E109A3D5C8CFA4DEF5D4961",
    "latest_block_height": "2",
    "latest_block_time": "2021-01-18T03:01:47.3004822Z",
    "earliest_block_hash": "B0D8C9E74F82488F4FCE1F6F278AA3F3D121DD7388E0BD11490FAA0AF378368C",
    "earliest_app_hash": "",
    "earliest_block_height": "1",
    "earliest_block_time": "2021-01-06T02:39:54.4126563Z",
    "catching_up": false
  },
  "validator_info": {
    "address": "43A5CC4B67C627BB16D3407B52049DB71259D8C5",
    "pub_key": {
      "type": "tendermint/PubKeySm2",
      "value": "Aw9gIbI63urt3AxT+jWYk46KFKKyJ/mPN7iWl+HuhxvW"
    },
    "voting_power": "100"
  }
}
```

使用xcd命令和xccli命令可对xchain进行操作，其中xcd可对服务器节点进行启动和配置等操作，xccli提供客户端命令以进行链上查询和交易等操作。

```
root@b8fee4e6a926:/opt# xcd
xiongan App Daemon (server)

Usage:
  xcd [command]

Available Commands:
  init                Initialize private validator, p2p, genesis, and application configuration files
  collect-gentxs      Collect genesis txs and output a genesis.json file
  gentx               Generate a genesis tx carrying a self delegation
  validate-genesis    validates the genesis file at the default location or at the location passed as an arg
  add-genesis-account Add a genesis account to genesis.json
  add-genesis-admin   Add a genesis admin to genesis.json
  add-genesis-org     Add a genesis org to genesis.json
  debug               Tool for helping with debugging your application
  start               Run the full node
  unsafe-reset-all    Resets the blockchain database, removes address book files, and resets priv_validator.json to the genesis state

  tendermint          Tendermint subcommands
  export              Export state to JSON

  version             Print the app version
  help                Help about any command

Flags:
  -h, --help               help for xcd
      --home string        directory for config and data (default "/root/.xcd")
      --log_level string   Log level (default "main:info,state:info,*:error")
      --trace              print out full stack trace on errors

Use "xcd [command] --help" for more information about a command.
```

```
root@b8fee4e6a926:/opt# xccli
xiongan chain client

Usage:
  xccli [command]

Available Commands:
  status      Query remote node for status
  config      Create or query an application CLI configuration file
  query       Querying subcommands
  tx          Transactions subcommands

  rest-server Start LCD (light-client daemon), a local REST server

  keys        Add or view local private keys

  version     Print the app version
  help        Help about any command

Flags:
      --chain-id string   Chain ID of tendermint node
  -e, --encoding string   Binary encoding (hex|b64|btc) (default "hex")
  -h, --help              help for xccli
      --home string       directory for config and data (default "/root/.xccli")
  -o, --output string     Output format (text|json) (default "text")
      --trace             print out full stack trace on errors

Use "xccli [command] --help" for more information about a command.
```