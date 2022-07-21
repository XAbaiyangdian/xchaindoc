# 成员管理

## 组织
联盟链通过组织来标识联盟的各参与主体，有进行网络治理的网络管理组`NetworkOrg`和代表联盟成员的用户组织。
- 网络管理组：

  网络管理组在区块链初始启动时创建并拥有最少一个网络管理员，网络管理员参与用户最上层组织、网络管理员、系统参数、提案、验证节点等的管理。

- 查看网络管理组
```shell script
> xccli query member org NetworkOrg
{
"orgId": "NetworkOrg",
"orgFullId": "NetworkOrg",
"level": "0",
"orgAdminAddress": "",
"subOrgIds": null,
"orgAccounts": [
  "xchain152pks72p3awfvpthfsw2ejl25m05hhgm9khgdg"
],
"orgRoleIds": null,
"parentId": "",
"ultParent": "",
"status": "1",
"preRevokeStatus": "0"
}
``` 
- 网络管理员:
  
  网络管理员可以是一个属于网络管理组的网络管理员或者最上层组织的组织管理员，除此之外的用户组织其他成员不可设置为网络管理员，在最上层组织的组织管理员被替换时，旧的组织管理员的网络管理员角色也会被撤销。
  网络管理员的加入、冻结、撤销操作需要其他网络管理员发起提案并进行投票，当投票数超过生效阈值之后提案才会生效。
  
- 添加网络管理员
```shell script
创建本地用户
> xccli keys add jimmy
{
  "name": "jimmy",
  "type": "local",
  "address": "xchain10w9n88qwz2vnguxhv0qv7unzz8lev8rc680aze",
  "pubkey": "xchainpub1ulx45dfpqdecrkv47grrfzm50uhmfvetp4t074aea5a5ejyw83ghhg0s66s37dy0ce2",
  "mnemonic": "nuclear panel tiger genius manual cupboard dinosaur shed sister zero royal collect raw praise offer cry foster misery fox ordinary tomorrow remain cargo spirit"
}

发起提案
> xccli tx member addNwAdmin $(xccli keys show jimmy -a) 100 --effective-time $(($(date +%s) + 120))  --vote-end-time $(($(date +%s) + 120)) --from jack -y
{
  "height": "0",
  "txhash": "307EDA8942A43566C85092482C6F2A03EADB19DB05644CC91531672FE843E94E"
}

找到提案id
> xccli query tx 307EDA8942A43566C85092482C6F2A03EADB19DB05644CC91531672FE843E94E | jq .logs[0].events[1].attributes[3].value
member_xchain152pks72p3awfvpthfsw2ejl25m05hhgm9khgdg_1657271828

对提案投票
> xccli tx gov vote member_xchain152pks72p3awfvpthfsw2ejl25m05hhgm9khgdg_1657271828 0 --from jack -y
{
  "height": "0",
  "txhash": "FCCEC11FD5B075CFBC7E3F474EE53E1D321A688500A8CBA36F4180F1BA149888"
}

查看账号
> xccli query member account $(xccli keys show jimmy -a)
{
  "address": "xchain10w9n88qwz2vnguxhv0qv7unzz8lev8rc680aze",
  "orgId": "NetworkOrg",
  "accountRoles": [
    {
      "roleId": "networkAdmin",
      "status": "1"
    }
  ],
  "status": "1",
  "preRevokeStatus": "0",
  "power": "100"
}
```

- 用户组织：
       
   用户组织分为最上层组织与子组织，最上层组织的组织层级为1，子组织的层级由2开始并逐层递增。最上层组织的创建、组织状态的变更与其组织管理员的管理由网络管理员发起提案并投票进行管理，子组织的创建
   与组织状态由直系上级组织的组织管理员进行管理，该组织下的组织成员，包括用户、角色、子组织由该子组织管理员进行管理。
   
- 查看组织列表
```shell script
> xccli query member orgs
[
  {
    "orgId": "NetworkOrg",
    "orgFullId": "NetworkOrg",
    "level": "0",
    "orgAdminAddress": "",
    "subOrgIds": null,
    "orgAccounts": [
      "xchain152pks72p3awfvpthfsw2ejl25m05hhgm9khgdg"
    ],
    "orgRoleIds": null,
    "parentId": "",
    "ultParent": "",
    "status": "1",
    "preRevokeStatus": "0"
  },
  {
    "orgId": "org1",
    "orgFullId": "org1",
    "level": "1",
    "orgAdminAddress": "xchain1g66qz0skseww80e7tlapmkjzcwrwnpa4gf78yp",
    "subOrgIds": null,
    "orgAccounts": [
      "xchain1e06fghcnudryr4urncn0utped2f0733m5frm58",
      "xchain1g66qz0skseww80e7tlapmkjzcwrwnpa4gf78yp"
    ],
    "orgRoleIds": null,
    "parentId": "",
    "ultParent": "org1",
    "status": "1",
    "preRevokeStatus": "0"
  }
]
```

- 创建组织org2
```shell script
创建本地用户 org2Admin
> xccli keys add org2Admin
{
  "name": "org2Admin",
  "type": "local",
  "address": "xchain1fy8lrz9xdvfcqtt4p9kywx5hhlha0sy0g2h5v6",
  "pubkey": "xchainpub1ulx45dfpqtkfd24huewzhnp7trd42z05xjsv56paw2p57e009rrx0ggf36kaspahwsp",
  "mnemonic": "impact food mandate nest nuclear screen dress guitar pact legal burden reopen pact humble soccer addict cross evil cover decade govern because burden hedgehog"
}

发起提案
> xccli tx member addOrg org2 $(xccli keys show org2Admin -a) --effective-time $(($(date +%s) + 120))  --vote-end-time $(($(date +%s) + 120)) --from jack -y
{
  "height": "0",
  "txhash": "5189AA890A6B40FC05D5E0B0849332145FF460A712DAFE8DB1D1760073A63342"
}

找到提案id
> xccli query tx 5189AA890A6B40FC05D5E0B0849332145FF460A712DAFE8DB1D1760073A63342 | jq .logs[0].events[1].attributes[3].value
member_xchain152pks72p3awfvpthfsw2ejl25m05hhgm9khgdg_1657274737

进行投票
> xccli tx gov vote member_xchain152pks72p3awfvpthfsw2ejl25m05hhgm9khgdg_1657274737 0 --from jack -y
{
  "height": "0",
  "txhash": "AD0BAF26D3A9AD22107E8673230FEE0CF3B5ACE6A10FCD0CDC33924B5824C45D"
}
> xccli tx gov vote member_xchain152pks72p3awfvpthfsw2ejl25m05hhgm9khgdg_1657274737 0 --from jimmy -y
{
  "height": "0",
  "txhash": "287B5069A8BDB0DED69AE7EB364E5D2B9D55FF6BA771A642DB681A7A1434EF9A"
}

查看组织
> xccli query member org org2
{
  "orgId": "org2",
  "orgFullId": "org2",
  "level": "1",
  "orgAdminAddress": "xchain1fy8lrz9xdvfcqtt4p9kywx5hhlha0sy0g2h5v6",
  "subOrgIds": null,
  "orgAccounts": [
    "xchain1fy8lrz9xdvfcqtt4p9kywx5hhlha0sy0g2h5v6"
  ],
  "orgRoleIds": null,
  "parentId": "",
  "ultParent": "org2",
  "status": "1",
  "preRevokeStatus": "0"
}

```


## 账号
   
账号由一个公钥地址唯一标识，且账号在加入网络时必须选定一个组织和至少一个角色，普通账号的加入由该组织的组织管理员或者直系上级的组织管理员签发交易。
- 添加账号
```shell script
> xccli keys add bob
{
 "name": "bob",
 "type": "local",
 "address": "xchain14mep0rgp0v2kmnejkg3g94v5l7s44246ed2kuz",
 "pubkey": "xchainpub1ulx45dfpqgcfsw87l03f56clttkms0eaqcv5dsps7mhgjhtkva0asyrv5q3gkrv9ple",
 "mnemonic": "paper grace now bright type feed other clog prepare fresh disagree ankle good first shoe mixed rifle embark ethics cattle coast roast connect pole"
}

> xccli tx member addAccount xchain14mep0rgp0v2kmnejkg3g94v5l7s44246ed2kuz org1 client --from org1Admin -y
{
 "height": "0",
 "txhash": "B1D36AE075195B7377138F0FCB94C6642E43BCA22EDB1C2EC753F059305D55BD"
}

```     
- 查看账号
```shell script
> xccli query member account xchain14mep0rgp0v2kmnejkg3g94v5l7s44246ed2kuz
{
 "address": "xchain14mep0rgp0v2kmnejkg3g94v5l7s44246ed2kuz",
 "orgId": "org1",
 "accountRoles": [
   {
     "roleId": "client",
     "status": "1"
   }
 ],
 "status": "1",
 "preRevokeStatus": "0",
 "power": "0"
}
```                           
## 角色

角色分为系统角色和用户自定义角色，系统角色不可编辑，用户自定义角色由组织管理员进行创建和管理，创建出来的自定义角色只对当前组织有效。

- 系统角色
  - `networkAdmin`
  - `gateway`
  - `orgAdmin`
  - `peer`
  - `client`

- 查看角色
```shell script
> xccli query member roles
[{
    "roleId": "client",
    "baseRoleId": "",
    "orgFullId": "",
    "status": "1",
    "roleFullId": "client"
  },
  {
    "roleId": "networkAdmin",
    "baseRoleId": "",
    "orgFullId": "",
    "status": "1",
    "roleFullId": "networkAdmin"
  },
  {
    "roleId": "orgAdmin",
    "baseRoleId": "",
    "orgFullId": "",
    "status": "1",
    "roleFullId": "orgAdmin"
  },
  {
    "roleId": "peer",
    "baseRoleId": "",
    "orgFullId": "",
    "status": "1",
    "roleFullId": "peer"
  }]
```
- 创建角色 student
```shell script
> xccli tx member addRole student org1 --from org1Admin -y
{
  "height": "0",
  "txhash": "F54E833080CB5788E08AA4DF98BDD24C8532CF9A7FB0978B1BC1E3EF04A42066"
}

> xccli query member role org1.student
{
  "roleId": "student",
  "baseRoleId": "",
  "orgFullId": "org1",
  "status": "1",
  "roleFullId": "org1.student"
}
```

- bob添加student角色 
```shell script
> xccli tx member editAccountRole xchain14mep0rgp0v2kmnejkg3g94v5l7s44246ed2kuz student 1 --from org1Admin -y
{
  "height": "0",
  "txhash": "28DF6E128526128E74DA3BDBAA2E002149BEBF0563E04918C56660273DD3FF06"
}

> xccli query member account xchain14mep0rgp0v2kmnejkg3g94v5l7s44246ed2kuz
{
  "address": "xchain14mep0rgp0v2kmnejkg3g94v5l7s44246ed2kuz",
  "orgId": "org1",
  "accountRoles": [
    {
      "roleId": "client",
      "status": "1"
    },
    {
      "roleId": "student",
      "status": "1"
    }
  ],
  "status": "1",
  "preRevokeStatus": "0",
  "power": "0"
}
```

## 权限

定义了每一个module msg的调用权限和合约的执行权限,合约的执行权限在部署合约和升级合约时通过指定权限表达式来进行创建和更新，
module msg权限的新增和编辑需要网络管理员发起提案并进行投票。

- 权限表达式：

   1. 单个表达式项 
   
      `org & role`
    
   2. 多个组织项或者角色项用小括号括起来并用逗号分割
    
      `(orgA,orgB, ...) & (roleA, roleB, ...)`
   
   3. 多个表达式项用 || 分割
       
      eg: `org & role || org1 & role1`
      
      eg: `(org1, org2) & role || org1 & (roleA, roleB)`
      
      eg: `(org1, org2, org3) & (roleA, roleB) || (org1, org2) & (roleA, roleB, roleC)`
      
   4. 组织表达式的模糊匹配和精确匹配
      
      1. 精确匹配： `org1.dep1.group1`
      
      2. 模糊匹配通配符： \* 和 \**
      
         1. \* 代表该层级的任意组织名
            
            eg: `org1.*` 匹配org1的任意直属子组织
            
            eg: `org1.*.group1` 匹配org1的任意直属子组织的group1
          
         2. \*\* 匹配任意深度的组织名
            
            eg: `**`  匹配任意层级组织与子组织
            
            eg: `**.group1` 匹配任意层级组织的子组织group1
            
            eg: `org1.**` 匹配org1的任意层级子组织
   5. 角色通配符：
      
      `member`
      
      eg: `org1&member` 匹配org1的所有角色
            
- 权限策略
  
  ACCEPT： 1
  
  DROP： 2

- 权限唯一标识
  
  moduleName_msgType
  
  eg: `member_addAccount` `member_addOrg` 
  
- 权限、组织、账号、角色 状态表
  - PENDING    = 0
  - ACTIVE     = 1
  -	REVOKING   = 2
  -	REVOKED    = 3
  -	FREEZING   = 4
  -	FROZEN     = 5
  -	UNFREEZING = 6
  	
- 查看权限
```shell script
> xccli query member permissions
[
  {
    "resource": "bank_multiSend",
    "ownerAddress": "",
    "policy": "1",
    "expElements": [
      {
        "chainIds": null,
        "orgExps": [
          "**"
        ],
        "roleIds": [
          "member"
        ],
        "addresses": null
      }
    ],
    "status": "1",
    "contractAdmin": "",
    "pendingPermission": {
      "resource": "",
      "policy": "0",
      "expElements": null
    }
  },
  {
    "resource": "celerain_MsgCelerain",
    "ownerAddress": "",
    "policy": "1",
    "expElements": [
      {
        "chainIds": null,
        "orgExps": [
          "**"
        ],
        "roleIds": [
          "member"
        ],
        "addresses": null
      }
    ],
    "status": "1",
    "contractAdmin": "",
    "pendingPermission": {
      "resource": "",
      "policy": "0",
      "expElements": null
    }
  },
  ...,
  ...,
]

> xccli query member permission member addNwAdmin
{
  "resource": "member_addNwAdmin",
  "ownerAddress": "",
  "policy": "1",
  "expElements": [
    {
      "chainIds": null,
      "orgExps": [
        "**"
      ],
      "roleIds": [
        "networkAdmin"
      ],
      "addresses": null
    }
  ],
  "status": "1",
  "contractAdmin": "",
  "pendingPermission": {
    "resource": "",
    "policy": "0",
    "expElements": null
  }
}
```