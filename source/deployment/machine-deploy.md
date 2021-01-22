# 主机独立部署

## 节点程序简介

xcd：节点服务程序； xccli：客户端命令行工具； so：xcd和xccli运行依赖库；

以上程序下载地址：<a href="https://gitee.com/xabl/xchain" target="_blank">https://gitee.com/xabl/xchain</a>



## 单节点启动

1. xcd、xccli拷贝到linux服务器工作目录；

2. so拷贝到linux服务器/lib目录；

3. 运行/sbin/ldconfig -v 加载依赖库；

4. 将xcd、xccli路径加入PATH环境变量；

5. 运行 init1.sh脚本；

   ```
   sh init1.sh
   ```

6. 执行xcd start启动节点；

   启动节点后，配置文件和数据文件默认在用户目录下，如果需要更改目录，则需加上--home=/opt/data/node01/.xcd，例如：

   ```
   xcd --home=/opt/data/node01/.xcd start
   ```

7. 执行xccli status查看节点状态；



## 多节点启动

1. 先在一台机器启动一个节点作为第一个节点，跟单节点启动一样；

2. 第二个节点，在另一台配置好环境的机器先执行xcd init <节点名> --chain-id=<链名>，例如：

   ```
   xcd init node02 --chain-id=xchain
   ```

3. 修改第二个节点的config.toml文件内容，persistent_peers = "node1-id@node1-ip:26656"。

   步骤：

   其中，config.toml路径如下：

   ```
   /opt/data/某节点名/.xcd/config/config.toml
   ```

   node1-id可以用以下命令查询：

   ```
   xcd tendermint show-node-id
   ```

   node1-ip可以用以下命令查询：

   ```
   ifconfig
   ```

   得到node1-id和node1-ip后，可以用vi命令修改第二个节点config.toml文件内容：

   ```
   vi config.toml
   ```

   然后按下i可以插入文本，按ESC后再按:wq保存退出。

   用cat命令可以查看修改后的config.toml内容：

   ```
   cat config.toml
   ```

   以下是改好的例子：

   ```
   ...
   # Comma separated list of nodes to keep persistent connections to
   persistent_peers = "1563d78a654fbcd238f5bd6acf3700f066544561@192.168.0.25:26656"
   ...
   ```



4. 复制第一个节点的genesis.json文件到第二个节点，覆盖第二个节点原有的genesis.json文件。

   genesis.json文件路径如下：

   ```
   /opt/data/某节点名/.xcd/config/genesis.json
   ```



5. 第一个节点上增加第二个节点地址到一个组织里。

   步骤：

   其中，在第二个节点执行xccli keys nodeaddress <node_key.json路径>获得**节点地址**，例如：

   ```
   xccli keys nodeaddress /opt/data/node02/.xcd/config/node_key.json
   ```

   在第一个节点查看有哪些**组织**：

   ```
   xccli query member orgs 
   ```

   选择其中一个组织，看orgAdminAddress属性存储的组织管理员地址，例如以下org2组织的管理员地址为xchain1tsat26zcw2gr4c4ldejs527jrzvhhhc253y2s6：

   ```
    {
   
     "orgId": "org2",
   
     "orgFullId": "org2",
   
     "level": "1",
   
     "orgAdminAddress": "xchain1tsat26zcw2gr4c4ldejs527jrzvhhhc253y2s6",
   
     "subOrgIds": null,
   
     "orgAccounts": [
   
      "xchain1tsat26zcw2gr4c4ldejs527jrzvhhhc253y2s6",
   
      "xchain1u5gpat4l7u36ph9m73g8s3qj8drgu4l5hcadv6"
   
     ],
   
     "orgRoleIds": null,
   
     "parentId": "",
   
     "ultParent": "org2",
   
     "status": "1",
   
     "preRevokeStatus": "0"
   
    },
   ```

   在第一个节点执行xccli keys list，在结果集合中对比刚才查到的组织管理员地址，查出**组织管理员的名字**。例如xchain1tsat26zcw2gr4c4ldejs527jrzvhhhc253y2s6的名字叫org2Admin。

   ```
    {
   
     "name": "org2Admin",
   
     "type": "local",
   
     "address": "xchain1tsat26zcw2gr4c4ldejs527jrzvhhhc253y2s6",
   
     "pubkey": "xchainpub1ulx45dfpqvel03xt6y5xc0s5kfszswempn32dz2gr3lllc2mu34xnqrw3vskkywrr56"
   
    },
   ```

   在第一个节点增加账号：xccli tx member addAccount <第二个节点的地址> <组织名> peer --from <组织管理员>，例如：

   ```
   xccli tx member addAccount xchain1wqdf5f66tdmj0dh8pyptppaqu2w2569z033vne  org2 peer --from org2Admin
   ```

   执行完后，在第一个节点查询组织，看第二个节点有没有成功加到某个组织里。以下是成功加到某组织的例子：

   ```
   xccli query member orgs 
   ```

   ```
     {
       "orgId": "org2",
       "orgFullId": "org2",
       "level": "1",
       "orgAdminAddress": "xchain1tsat26zcw2gr4c4ldejs527jrzvhhhc253y2s6",
       "subOrgIds": null,
       "orgAccounts": [
         "xchain1tsat26zcw2gr4c4ldejs527jrzvhhhc253y2s6",
         "xchain1u5gpat4l7u36ph9m73g8s3qj8drgu4l5hcadv6",
         "xchain1wqdf5f66tdmj0dh8pyptppaqu2w2569z033vne"
       ],
       "orgRoleIds": null,
       "parentId": "",
       "ultParent": "org2",
       "status": "1",
       "preRevokeStatus": "0"
     },
   ```



6. 在第二个节点执行以下代码，启动第二个节点

   ```
   xcd start
   ```

   第二个节点成功启动输出例子：

   ```
   root@b5c8b0e185e0:/opt/data/node01/.xcd/config# xcd start
   I[2021-01-19|15:38:17.841] starting ABCI with Tendermint                module=main
   E[2021-01-19|15:38:17.898] Can't add peer's address to addrbook         module=p2p err="Cannot add non-routable address 1563d78a654fbcd238f5bd6acf3700f066544561@192.168.0.25:26656"
   Query path: /p2p/filter/addr/192.168.0.25:26656
   Query path: /p2p/filter/id/1563d78a654fbcd238f5bd6acf3700f066544561
   I[2021-01-19|15:38:21.153] Executed block                               module=state height=1 validTxs=0 invalidTxs=0
   I[2021-01-19|15:38:21.156] Committed state                              module=state height=1 txs=0 appHash=32298BE2D8A95C0F0692C03FD641ADE32153BB5D8E109A3D5C8CFA4DEF5D4961
   I[2021-01-19|15:38:21.161] Executed block                               module=state height=2 validTxs=0 invalidTxs=0
   I[2021-01-19|15:38:21.163] Committed state                              module=state height=2 txs=0 appHash=32298BE2D8A95C0F0692C03FD641ADE32153BB5D8E109A3D5C8CFA4DEF5D4961
   I[2021-01-19|15:38:21.169] Executed block                               module=state height=3 validTxs=1 invalidTxs=0
   I[2021-01-19|15:38:21.170] Committed state                              module=state height=3 txs=1 appHash=1A01D03323A2802FE63B3EDDBEC07C00A63E38D9006AA61B1B23F24BEA5F2BDE
   I[2021-01-19|15:38:21.177] Executed block                               module=state height=4 validTxs=0 invalidTxs=0
   I[2021-01-19|15:38:21.179] Committed state                              module=state height=4 txs=0 appHash=1A01D03323A2802FE63B3EDDBEC07C00A63E38D9006AA61B1B23F24BEA5F2BDE
   I[2021-01-19|15:38:21.185] Executed block                               module=state height=5 validTxs=1 invalidTxs=0
   I[2021-01-19|15:38:21.187] Committed state                              module=state height=5 txs=1 appHash=D0ADCCA8656C9C27F49FD9E60A732CC4D502F26D1DE1CB914DD09C5B1F47B1D4
   I[2021-01-19|15:38:21.194] Executed block                               module=state height=6 validTxs=0 invalidTxs=0
   I[2021-01-19|15:38:21.196] Committed state                              module=state height=6 txs=0 appHash=D0ADCCA8656C9C27F49FD9E60A732CC4D502F26D1DE1CB914DD09C5B1F47B1D4
   ```



7. 在第一个节点做交易，jack转账给bob，xccli tx send  < jack address >  < bob address >  55stake --from jack。

   步骤：

   jack和bob的地址可以用以下代码查询：

   ```
   xccli keys list
   ```

   查询结果例子：

   ```
   ...
   
    {
   
     "name": "bob",
   
     "type": "local",
   
     "address": "xchain1k8dng03r58gqqa4qafuvtngsg2htx2ha5qp720",
   
     "pubkey": "xchainpub1ulx45dfpqw7920nduaulukgy8levxd4mwq5vyhc5p0ykgnvwlzdwsx83xw5773ycuqq"
   
    },
   
   ...
   
    {
   
     "name": "jack",
   
     "type": "local",
   
     "address": "xchain1gptswzmh68q5l8jskvvtm8s664v83u3nt7vds9",
   
     "pubkey": "xchainpub1ulx45dfpqw7yqwvejdysxarsvr98kqng4wxavqun0mkdhafhm8klxs05ure06tseqxt"
   
    },
   ```

   执行转账例子：

   ```
   xccli tx send xchain1gptswzmh68q5l8jskvvtm8s664v83u3nt7vds9 xchain1k8dng03r58gqqa4qafuvtngsg2htx2ha5qp720 55stake --from jack
   ```

   查看第一、第二个节点有没有自动出块。

   第二个节点自动出块输出例子：

   ```
   Query path: custom/acc/account
   Query path: custom/acc/account
   I[2021-01-20|01:50:06.992] Executed block                               module=state height=7 validTxs=1 invalidTxs=0
   I[2021-01-20|01:50:06.995] Committed state                              module=state height=7 txs=1 appHash=A7CC3F313EB3586F75800B1507C7BCF80659AE9D5C71C74C5751B1A47719066E
   I[2021-01-20|01:50:12.012] Executed block                               module=state height=8 validTxs=0 invalidTxs=0
   I[2021-01-20|01:50:12.017] Committed state                              module=state height=8 txs=0 appHash=A7CC3F313EB3586F75800B1507C7BCF80659AE9D5C71C74C5751B1A47719066E
   ```

   第二个节点自动出块输出例子：

   ```
   I[2021-01-19|15:38:21.202] Executed block                               module=state height=7 validTxs=1 invalidTxs=0
   I[2021-01-19|15:38:21.204] Committed state                              module=state height=7 txs=1 appHash=A7CC3F313EB3586F75800B1507C7BCF80659AE9D5C71C74C5751B1A47719066E
   I[2021-01-19|15:38:22.669] Executed block                               module=state height=8 validTxs=0 invalidTxs=0
   I[2021-01-19|15:38:22.671] Committed state                              module=state height=8 txs=0 appHash=A7CC3F313EB3586F75800B1507C7BCF80659AE9D5C71C74C5751B1A47719066E
   ```

   

8. 执行以下代码获取所有validator

   ```
   xccli query poa validators
   ```

   当时只有node01有validator：

   ```
   [
     {
       "operator_address": "xchain1gptswzmh68q5l8jskvvtm8s664v83u3nt7vds9",
       "validator_address": "xchainvaloper1gwjucjm8ccnmk9kngpa4ypyakuf9nkx9r4ne5u",
       "consensus_pubkey": "xchainvalconspub1ulx45dfpqv8kqgdj8t0w4mwup3fl5dvcjw8g599zkgnlnrehhztf0c0wsudav40f38c",
       "jailed": false,
       "status": 2,
       "weight": "100",
       "pending_weight": "0",
       "description": {
         "moniker": "node01",
         "identity": "",
         "website": "",
         "security_contact": "",
         "details": ""
       }
     }
   ]
   ```

   

9. 在第二个节点的执行以下代码，取得第二个节点的validator key

   ```
   xcd tendermint show-validator
   ```



10. 在第一或者第二个节点执行xccli tx poa createValidator  < validator key >  power(0~100)，创建第二个节点的validator，例如：

    ```
    xccli tx poa createValidator xchainvalconspub1ulx45dfpqdt550rmnakdu7pfal700pucs3rrsxyp04u9cq6ln9g0uhfhz9etuc5l0rs 10 --moniker node02 --from jack -y
    ```

    执行完会返回txhash等信息，例如：

    ```
    {
      "height": "0",
      "txhash": "BF04B75B5BAC0D7873594A8D3FC263D4F1E01E287182AE895649D7474EF5A1AF",
      "raw_log": "[]"
    }
    ```



11. 可以用xccli query tx < txhash >查询刚才交易信息，例如：

    ```
    xccli query tx BF04B75B5BAC0D7873594A8D3FC263D4F1E01E287182AE895649D7474EF5A1AF
    ```



12. 执行以下代码获取所有validator

    ```
    xccli query poa validators
    ```

    返回node01和node02的validator信息：

    ```
    [
      {
        "operator_address": "xchain1gptswzmh68q5l8jskvvtm8s664v83u3nt7vds9",
        "validator_address": "xchainvaloper1gwjucjm8ccnmk9kngpa4ypyakuf9nkx9r4ne5u",
        "consensus_pubkey": "xchainvalconspub1ulx45dfpqv8kqgdj8t0w4mwup3fl5dvcjw8g599zkgnlnrehhztf0c0wsudav40f38c",
        "jailed": false,
        "status": 2,
        "weight": "100",
        "pending_weight": "0",
        "description": {
          "moniker": "node01",
          "identity": "",
          "website": "",
          "security_contact": "",
          "details": ""
        }
      },
      {
        "operator_address": "xchain1gptswzmh68q5l8jskvvtm8s664v83u3nt7vds9",
        "validator_address": "xchainvaloper1tjgtsuep5uxssv74drcj5ctaztc56xc63s3224",
        "consensus_pubkey": "xchainvalconspub1ulx45dfpqdt550rmnakdu7pfal700pucs3rrsxyp04u9cq6ln9g0uhfhz9etuc5l0rs",
        "jailed": false,
        "status": 2,
        "weight": "10",
        "pending_weight": "0",
        "description": {
          "moniker": "node02",
          "identity": "",
          "website": "",
          "security_contact": "",
          "details": ""
        }
      }
    ]
    ```



13. 如果需要启动第三个节点并加入第一、第二个节点搭建起来的网络，则第三个节点启动步骤和第二个节点类似，第三个节点连第一个节点或者第二个节点均可。
