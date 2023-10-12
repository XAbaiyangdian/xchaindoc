# SDK接入

## JAVA SDK

### 环境准备

#### xchain-java-sdk示例
- 示例xchain-java-sdk源码

   [xchain-java-sdk.zip](https://github.com/XAbaiyangdian/xchaindoc/raw/master/source/application/contract/xchain-java-sdk.zip)

- 示例存证合约文件

   [evidence.wasm](https://github.com/XAbaiyangdian/xchaindoc/raw/master/source/application/contract/evidence.wasm)
- 示例存证合约源码

   [contract-evidence.zip](https://github.com/XAbaiyangdian/xchaindoc/raw/master/source/application/contract/contract-evidence.zip)

#### 使用本地jar包
- 下载java sdk

  [xchain-java-sdk-2.0.0.jar](https://github.com/XAbaiyangdian/xchaindoc/raw/master/source/application/xchain-java-sdk-2.0.0.jar)

- 将sdk安装到本地maven仓库
```shell script
> mvn install:install-file -Dfile="xchain-java-sdk-2.0.0.jar" -DgroupId="org.xbl.xchain" -DartifactId="xchain-java-sdk" -Dversion="2.0.0" -Dpackaging=jar
```

- pom中添加依赖
```shell script
<dependency>
    <groupId>org.xbl.xchain</groupId>
    <artifactId>xchain-java-sdk</artifactId>
    <version>2.0.0</version>
</dependency>
```

#### 或使用远程仓库jar包
- pom中添加依赖
```shell script
<dependency>
    <groupId>io.gitee.xachainzyan</groupId>
    <artifactId>xchain-java-sdk</artifactId>
    <version>2.0.0</version>
</dependency>
```

### sdk使用
- 填写sdk配置项信息
```shell script
    String url = "http://ip:port";
    String chainId = "chainId";
    String mne = "徙 需 校 慰 末 辞 腊 瞧 逻 冶 铅 讲 觉 残 框 又 频 招 朝 表 离 链 电 闲";
```

- 部署合约
```shell script
    SysConfig sysConfig = new SysConfig(Config.url, Config.chainId, "2");
    XchainClient xchainClient = new XchainClient(sysConfig);
    String contractName = "evidence";
    String language = "rust";
    String initMsg = "{}";
    String contractPath = "src/test/java/wasm/evidence.wasm";
    String executePerm = "";
    String lable = "";
    Account acc = Account.buildAccount(new KeyInfo(Config.mne, AlgorithmType.SM2));
    TxResponse txResponse = xchainClient.instantiateContract(acc, contractName, language, contractFile, initMsg, PermissionPolicy.POLICY_DROP, executePerm, label);
    assert txResponse.isSuccess();
```

- 调用合约
```shell script
    SysConfig sysConfig = new SysConfig(Config.url, Config.chainId, "2");
    XchainClient xchainClient = new XchainClient(sysConfig);
    Account acc = Account.buildAccount(new KeyInfo(Config.mne, AlgorithmType.SM2));
    String contractName = "evidence";
    String functionName = "create";
    String args = "{\"key\":\"UUID11235\",\"value\":\"65535\"}";
    TxResponse txResponse = xchainClient.executeContract(acc, contractName, functionName, args);
    System.out.println(txResponse);
    assert txResponse.isSuccess();
```
- TxResponse结构
```shell script
    TxResponse(
        code=0, 
        codeSpace=, 
        log=[
            {
                "msg_index":0,
                "log":"",
                "events":[
                    {
                        "type":"message",
                        "attributes":[
                            {
                                "key":"action",
                                "value":"execute"
                            },
                            {
                                "key":"module",
                                "value":"wasm"
                            },
                            {
                                "key":"signer",
                                "value":"xchain1fxfh7pegr2vhme8g6cgvsk3h760a7su8d7x3wn"
                            },
                            {
                                "key":"contract_address",
                                "value":"xchain10pyejy66429refv3g35g2t7am0was7yahxdaan"
                            }
                        ]
                    }
                ]
            }
        ], data=, hash=12D5552E01FD8718EB88D939EFB2DD7710C2A8920485CEA77321020E101DFD97, height=52255, proposalId=null
    )


```
- 查询合约
```shell script
    SysConfig sysConfig = new SysConfig(Config.url, Config.chainId, "2");
    XchainClient xchainClient = new XchainClient(sysConfig);
    String contractName = "evidence";
    String functionName = "find";
    String args = "{\"key\":\"UUID11235\"}";
    String queryResult = xchainClient.queryContract(contractName, functionName, args);
    System.out.println(queryResult);
```
- 查询交易TxHash
```shell script
    SysConfig sysConfig = new SysConfig(Config.url, Config.chainId, "2");
    XchainClient xchainClient = new XchainClient(sysConfig);
    String txHash = "6D726651B86BF784B54611388B88A1A5726405F172B696B8A23CB0D3D380AF77";
    TxInfo txInfo = xchainClient.queryTx(txHash);
    System.out.println(txInfo);
```
- 查询区块
```shell script
    SysConfig sysConfig = new SysConfig(Config.url, Config.chainId, "2");
    XchainClient xchainClient = new XchainClient(sysConfig);
    BlockInfo blockInfo = xchainClient.queryBlock("1069");
    System.out.println(blockInfo);
    System.out.println(blockInfo.getBlockTime());
```

## GO SDK

## JavaScript SDK