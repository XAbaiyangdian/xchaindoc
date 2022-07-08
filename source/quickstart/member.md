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
- 查看网络管理员 
```shell script
> xccli query member account xchain152pks72p3awfvpthfsw2ejl25m05hhgm9khgdg
{
"address": "xchain152pks72p3awfvpthfsw2ejl25m05hhgm9khgdg",
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
## 账号
   
账号由一个地址唯一标识，且账号在加入网络时必须选定一个组织和至少一个角色，普通账号的加入由该组织的组织管理员或者直系上级的组织管理员签发交易。
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

角色分为系统角色和用户自定义角色，系统角色不可删除或修改，用户自定义角色由组织管理员进行创建和管理，创建出来的自定义角色只对当前组织有效。

- 系统角色
  - networkAdmin
  - gateway
  - orgAdmin
  - peer
  - client

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