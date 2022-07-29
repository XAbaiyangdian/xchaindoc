# SDK接入

## JAVA SDK

### 环境准备
- 下载java sdk

  [xchain-java-sdk-1.0.jar](https://github.com/XAbaiyangdian/xchaindoc/blob/master/source/quickstart/xchain-java-sdk-2.0.0.jar)

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
### sdk使用
- 初始化XchainClient
```shell script
    String url = "http://ip:port";
    String chainId = "xachain";
    String mainPrefix = "xchain";
    XchainClient xchainClient = new XchainClient(url, chainId);
```

- 构建账号
```shell script
    String org1AdminMnemonic = "winter angry holiday castle involve fade answer answer unique history harvest local goose south type genuine void memory meadow wasp increase portion suffer hello";
    Account org1Admin = Account.buildAccount(new KeyInfo(org1AdminMnemonic, AlgorithmType.SM2, mainPrefix));
```

- 添加组织成员
```shell script
    KeyInfo keyInfo = xchainClient.generateKeyInfo(AlgorithmType.SM2, mainPrefix);
    String newAccount = keyInfo.getAddress();
    TxResponse txResponse = xchainClient.addAccount(org1Admin, newAccount, "org1", "client");
```

- 部署合约
```shell script
    String contractName = "item";
    String language = "rust";
    String executePerm = "";
    String lable = "";
    String initMsg = "{}";
    String contractPath = "test.wasm";
    File contractFile = new File(contractPath);
    TxResponse txResponse = xchainClient.instantiateContract(org1Admin, contractName, language, contractFile, initMsg, PermissionPolicy.POLICY_DROP, executePerm, lable);
```
   [test.wasm](https://github.com/XAbaiyangdian/xchaindoc/blob/master/source/quickstart/test.wasm)

- 调用合约
```shell script
    String contractName = "item";
    String params = "{\"create\":{\"item\":{\"key\":\"name\",\"value\":\"zhangsan\"}}}";
    TxResponse txResponse = xchainClient.executeContract(org1Admin, contractName , params);
```
- 查询合约
```shell script
    String contractName = "item";
    String paramsStr = "{\"find\":{\"key\":\"name\"}}";
    Map<String, Object> params = JSON.parseObject(paramsStr).getInnerMap();
    String result = xchainClient.queryContract(contractName, params);
```


## GO SDK

## JavaScript SDK