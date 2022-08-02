# 客户端密钥库
- keystore
    
    本地用户密钥库，密钥数据存放在xccli的工作目录，在使用xccli发送交易时通过 `--from` 指定本地密钥库的用户签发交易，该数据为当前客户端私有，不与区块链其他节点共享。
    
    
- keys 相关命令
```
> xccli keys

Available Commands:
  mnemonic    Compute the bip39 mnemonic for some input entropy
  add         Add an encrypted private key (either newly generated or recovered), encrypt it, and save to disk
  import-mem  Import mnemonic into the local keybase
  export      Export private keys
  import      Import private keys into the local keybase
  list        List all keys
  show        Show key info for the given name
              
  delete      Delete the given keys
  parse       Parse address from hex to bech32 and vice versa
  migrate     Migrate keys from the legacy (db-based) Keybase
 
```   
- 创建用户（助记词信息需要用户保存，密钥库不存储助记词）
```
> xccli keys add tom
{
  "name": "tom",****************
  "type": "local",
  "address": "xchain18489zup0dmcv949j0kcfyc34x2xm6z3jwmsaqu",
  "pubkey": "xchainpub1ulx45dfpq0fke5qtwpl5yjtkxtgx43axuv99zed06zkr2g0nsm7zar5rc6xhjd8pz7j",
  "mnemonic": "rice trip rail bargain resist foot ritual rebel eagle winner wave sell woman comic exotic resemble market extend unable film outer describe fury thumb"
}
```
- 查看用户
```
> xccli keys show tom
{
  "name": "tom",
  "type": "local",
  "address": "xchain18489zup0dmcv949j0kcfyc34x2xm6z3jwmsaqu",
  "pubkey": "xchainpub1ulx45dfpq0fke5qtwpl5yjtkxtgx43axuv99zed06zkr2g0nsm7zar5rc6xhjd8pz7j"
}
```

- 用户列表
```
> xccli keys list
[
  {
    "name": "jack",
    "type": "local",
    "address": "xchain152pks72p3awfvpthfsw2ejl25m05hhgm9khgdg",
    "pubkey": "xchainpub1ulx45dfpqdsnt3hmapsdnlxlztnhsfh50czsdp53gv4uqg9sp653umr6guajsc5jfxe"
  },
  {
    "name": "org1Admin",
    "type": "local",
    "address": "xchain1g66qz0skseww80e7tlapmkjzcwrwnpa4gf78yp",
    "pubkey": "xchainpub1ulx45dfpqtaj5z0nx09anxve4fz0xr8h84fytjeatlhvgpvyed9ae3y70y9exaaxeu2"
  },
  {
    "name": "tom",
    "type": "local",
    "address": "xchain18489zup0dmcv949j0kcfyc34x2xm6z3jwmsaqu",
    "pubkey": "xchainpub1ulx45dfpq0fke5qtwpl5yjtkxtgx43axuv99zed06zkr2g0nsm7zar5rc6xhjd8pz7j"
  }
]
```

- 生成助记词
```
> xccli keys mnemonic
parent shock tone suit sick front inspire mansion ten glide mask share benefit toddler give tornado release swing tilt club autumn sell attack elite
```

- 通过助记词导入用户 
```
> xccli keys import-mem alice "parent shock tone suit sick front inspire mansion ten glide mask share benefit toddler give tornado release swing tilt club autumn sell attack elite"
{
  "name": "alice",
  "type": "local",
  "address": "xchain10fpdfaqvs2p53nr0usfhejqurmpg2lddy6yw4f",
  "pubkey": "xchainpub1ulx45dfpqdaxgvchm42ckr7lrc9wzhqfau6t92jjrduc82szafera90v29ky5qv99td",
  "mnemonic": "parent shock tone suit sick front inspire mansion ten glide mask share benefit toddler give tornado release swing tilt club autumn sell attack elite"
}

```

- 删除用户
```
> xccli keys delete alice
Key deleted forever (uh oh!)
```