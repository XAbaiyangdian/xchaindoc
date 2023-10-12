# 节点管理

## 简介
### 雄安链中有三类节点 
   - 同步节点
      
      也称全节点，同步所有区块和交易并验证和执行，记录完整账本数据，不参与区块共识。 
   - 共识节点
  
      在同步节点的基础上参与区块共识。
   - 轻节点
  
      不同步全量交易数据，只同步与验证区块头信息，提供交易存在性和有效性证明。
## 同步节点

雄安链作为联盟链，节点无法随意加入网络，需要网络的授权，每一个节点在初始化都后会生成一个代表节点身份的密钥文件 `node_key.json` ，该密钥生成的节点id和节点地址用来在网络中唯一标识一个
节点，决定着节点是否可以加入到网络中且同步网络中的区块和交易，是节点作为验证人参与共识的前提。

### 节点id
   
节点id作为节点在p2p网络层和共识层的唯一标识，当节点启动需要连接其他节点时需要知道该节点的网络地址，网络地址表达式为`nodeId@ip:port`。
- 查看节点id
```shell script
> xcd tendermint show-node-id
cbf4945f13e34641d7839e26fe2c396a92ff463b
```
### 节点地址

节点地址和节点id都是由节点密钥的公钥生成的，不同的是节点id仅仅应用于p2p网络与共识层。应用层的用户地址生成规则中使用了`Bech32` 编码，所以为了适应应用层的账户模型，需要节点地址来标识一个节点。

- 查看节点地址
```shell script
> xcd tendermint show-node-address
xchain1dj08aclnx25965gcxz4z240aurmkqz4jus3xht
```

### 新节点如何加入区块链网络？

#### 新节点地址需被加入一个应用层组织并且赋予 `peer` 角色。     
- 创建`peer` 角色的账户
```shell script
> xccli tx member addAccount xchain1dj08aclnx25965gcxz4z240aurmkqz4jus3xht org1 peer --from org1Admin -y
```
- 查看账户信息
```shell script
> xccli query member account xchain1dj08aclnx25965gcxz4z240aurmkqz4jus3xht
{
  "address": "xchain1dj08aclnx25965gcxz4z240aurmkqz4jus3xht",
  "orgId": "org1",
  "accountRoles": [
    {
      "roleId": "peer",
      "status": "1"
    }
  ],
  "status": "1",
  "preRevokeStatus": "0",
  "power": "0"
}
```
#### 拷贝已在网络中节点的创世块配置文件到新节点目录下
```shell script
> cp $HOME/.xcd/config/genesis.json $NEW_HOME/.xcd/config/
```

#### 启动节点并指定连接节点
```shell script
> xcd start --p2p.persistent_peers=[nodeId]@[ip]:26656
```

## 共识节点
共识节点也叫验证节点，可以看做是一个特殊的同步节点，在同步节点的基础上参与了区块的提议与出块过程。

雄安链的共识由两层组成，第一部分是应用层的验证节点管理， 验证节点的加入、退出、权重变化需要网络管理员发起提案并进行投票，待提案生效时通过 `EndBlock` 响应到共识层的验证节点集合和验证节点的权重。
第二部分是共识层的共识算法，将会在共识算法部分介绍到。

节点在初始化时除了会创建 `node_key.json`, 还会创建一个验证人密钥 `priv_validator_key.json`，节点在运行过程中会检查自己是否在系统的验证人列表中，在的话就会参与到共识中，否则不参与共识。

### 如何成为验证节点？

成为验证节点需要使用节点的验证公钥在应用层发起一笔创建验证人的提案，待提案通过并生效后会将验证人更新到共识层的验证人列表中。
  
- 查看节点的验证公钥
```shell script
> xcd tendermint show-validator
xchainvalconspub1ulx45dfpqvgnkjl787233npl43w9exdct6k2gtn0x3e46mfa6pu357hcez0wk3ej355
```
- 网络管理员发起创建验证人的提案并投票
```shell script
> xccli tx poa createValidator xchainvalconspub1ulx45dfpqvgnkjl787233npl43w9exdct6k2gtn0x3e46mfa6pu357hcez0wk3ej355 10 --effective-time $(($(date +%s) + 120))  --vote-end-time $(($(date +%s) + 120)) --moniker validator2 --from jack -y
{
  "height": "0",
  "txhash": "B630ECEACE305F3006F3F96944B6195CF65C36678A19E799E4AEF4285DE601AA"
}

找到提案id
> xccli query tx B630ECEACE305F3006F3F96944B6195CF65C36678A19E799E4AEF4285DE601AA | jq .logs[0].events[0].attributes[1].value
poa_xchain1x64mmdacpyte4d8kxxa0chdaw0n9h0wh3dj88w_1658725471

对提案投票(如有其他网络管理员需重复此步骤)
> xccli tx gov vote poa_xchain1x64mmdacpyte4d8kxxa0chdaw0n9h0wh3dj88w_1658725471 0 --from jack -y
{
  "height": "0",
  "txhash": "9FE27E16FF2978A9DC74846D47B6A534D1F281D502EB56207522D07D7558A674"
}

查看提案
> xccli query gov proposal poa_xchain1x64mmdacpyte4d8kxxa0chdaw0n9h0wh3dj88w_1658725471
{
  "proposer": "xchain1x64mmdacpyte4d8kxxa0chdaw0n9h0wh3dj88w",
  "proposal_id": "poa_xchain1x64mmdacpyte4d8kxxa0chdaw0n9h0wh3dj88w_1658725471",
  "router_key": "poa",
  "op_type": "create_validator",
  "content": "{\"type\":\"xchain/MsgCreateValidator\",\"value\":{\"description\":{\"moniker\":\"validator2\",\"identity\":\"\",\"website\":\"\",\"security_contact\":\"\",\"details\":\"\"},\"operator_address\":\"xchain1x64mmdacpyte4d8kxxa0chdaw0n9h0wh3dj88w\",\"pubkey\":\"xchainvalconspub1ulx45dfpqvgnkjl787233npl43w9exdct6k2gtn0x3e46mfa6pu357hcez0wk3ej355\",\"power\":\"10\",\"effective_time\":\"1658725595\",\"vote_end_time\":\"1658725595\"}}",
  "admins": [
    {
      "address": "xchain1x64mmdacpyte4d8kxxa0chdaw0n9h0wh3dj88w",
      "power": "100"
    }
  ],
  "approved_admins": [
    {
      "proposal_id": "poa_xchain1x64mmdacpyte4d8kxxa0chdaw0n9h0wh3dj88w_1658725471",
      "voter_address": "xchain1x64mmdacpyte4d8kxxa0chdaw0n9h0wh3dj88w",
      "power": "100",
      "vote_type": "0",
      "vote_time": "2022-07-25T05:04:51.979507028Z"
    }
  ],
  "refused_admins": null,
  "abstained_admins": null,
  "create_time": "2022-07-25T05:04:31.918634283Z",
  "effective_time": "1658725595",
  "vote_end_time": "1658725595",
  "proposal_status": "EffectivePeriod",
  "propose_level": "0"
}
```

- 两分钟后提案生效 查看验证人列表
```shell script
> xccli query poa validators
[
  {
    "operator_address": "xchain1x64mmdacpyte4d8kxxa0chdaw0n9h0wh3dj88w",
    "validator_address": "xchainvaloper1yyjt5r9ul9tunvs872qkxsnhknthz69ehgneep",
    "consensus_pubkey": "xchainvalconspub1ulx45dfpqgg3k39wem2vcg4es2wug6x0fs7qscwsypr4r9xsh9rzpac5tvejs7hnl2s",
    "jailed": false,
    "status": 2,
    "weight": "100",
    "pending_weight": "0",
    "description": {
      "moniker": "",
      "identity": "",
      "website": "",
      "security_contact": "",
      "details": ""
    }
  },
  {
    "operator_address": "xchain1x64mmdacpyte4d8kxxa0chdaw0n9h0wh3dj88w",
    "validator_address": "xchainvaloper1x06f2ngg3tfv3upgv6q9csvv35g43lgp8zal3p",
    "consensus_pubkey": "xchainvalconspub1ulx45dfpqvgnkjl787233npl43w9exdct6k2gtn0x3e46mfa6pu357hcez0wk3ej355",
    "jailed": false,
    "status": 2,
    "weight": "10",
    "pending_weight": "0",
    "description": {
      "moniker": "validator2",
      "identity": "",
      "website": "",
      "security_contact": "",
      "details": ""
    }
  }
]
```

## 轻节点


