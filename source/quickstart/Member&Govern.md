# 组织与权限治理

- 账户

  查看网络中所有账户的信息，可以看到账户地址、所属组织和角色、账户状态。

  ```
  xccli query member accounts
  ```

  ```
  root@b8fee4e6a926:/opt# xccli query member accounts
  [
    {
      "address": "xchain1aamtjy56vpm6uppk6v7r8qtq6qtr45rlxsyq8d",
      "orgId": "org1",
      "accountRoles": [
        {
          "roleId": "orgAdmin",
          "status": "1"
        }
      ],
      "status": "1",
      "preRevokeStatus": "0"
    },
    {
      "address": "xchain1ajxnvsqt6934757p0yuxn8v63848fm5nwvh9fj",
      "orgId": "org4",
      "accountRoles": [
        {
          "roleId": "peer",
          "status": "1"
        }
      ],
      "status": "1",
      "preRevokeStatus": "0"
    },
    {
      "address": "xchain1awsgmp243gfk3k482n95eun47lnmk96mqzeve3",
      "orgId": "org3",
      "accountRoles": [
        {
          "roleId": "peer",
          "status": "1"
        }
      ],
      "status": "1",
      "preRevokeStatus": "0"
    },
    {
      "address": "xchain1dcnqdkcnylenf8y5gk8dphnuejwg5pm49kf8lg",
      "orgId": "org3",
      "accountRoles": [
        {
          "roleId": "orgAdmin",
          "status": "1"
        }
      ],
      "status": "1",
      "preRevokeStatus": "0"
    },
    {
      "address": "xchain1gptswzmh68q5l8jskvvtm8s664v83u3nt7vds9",
      "orgId": "NetworkOrg",
      "accountRoles": [
        {
          "roleId": "networkAdmin",
          "status": "1"
        }
      ],
      "status": "1",
      "preRevokeStatus": "0"
    },
    {
      "address": "xchain1k8dng03r58gqqa4qafuvtngsg2htx2ha5qp720",
      "orgId": "NetworkOrg",
      "accountRoles": [
        {
          "roleId": "networkAdmin",
          "status": "1"
        }
      ],
      "status": "1",
      "preRevokeStatus": "0"
    },
    {
      "address": "xchain1qdh0d7727llzxra3y9z7u0c0seyw4hwx8yeduw",
      "orgId": "org4",
      "accountRoles": [
        {
          "roleId": "orgAdmin",
          "status": "1"
        }
      ],
      "status": "1",
      "preRevokeStatus": "0"
    },
    {
      "address": "xchain1tdcqgz7gzwycfp9xtz4adfeyul54ekzvs06tyj",
      "orgId": "NetworkOrg",
      "accountRoles": [
        {
          "roleId": "networkAdmin",
          "status": "1"
        }
      ],
      "status": "1",
      "preRevokeStatus": "0"
    },
    {
      "address": "xchain1tsat26zcw2gr4c4ldejs527jrzvhhhc253y2s6",
      "orgId": "org2",
      "accountRoles": [
        {
          "roleId": "orgAdmin",
          "status": "1"
        }
      ],
      "status": "1",
      "preRevokeStatus": "0"
    },
    {
      "address": "xchain1u5gpat4l7u36ph9m73g8s3qj8drgu4l5hcadv6",
      "orgId": "org2",
      "accountRoles": [
        {
          "roleId": "peer",
          "status": "1"
        }
      ],
      "status": "1",
      "preRevokeStatus": "0"
    },
    {
      "address": "xchain1z43a0zn9f77dyw84h44v7dcq7pn9g3tp2rmhpu",
      "orgId": "org1",
      "accountRoles": [
        {
          "roleId": "peer",
          "status": "1"
        }
      ],
      "status": "1",
      "preRevokeStatus": "0"
    },
    {
      "address": "xchain1z5ynz4jmv9spaarmmyfgvdp45u7aujxsklqm5h",
      "orgId": "NetworkOrg",
      "accountRoles": [
        {
          "roleId": "networkAdmin",
          "status": "1"
        }
      ],
      "status": "1",
      "preRevokeStatus": "0"
    }
  ]
  ```

  使用xccli keys命令可以查看本地账户名称和地址的对应关系

  ```
  xccli keys list
  ```

  ```
  root@b8fee4e6a926:/opt# xccli keys list
  [
    {
      "name": "alice",
      "type": "local",
      "address": "xchain1z5ynz4jmv9spaarmmyfgvdp45u7aujxsklqm5h",
      "pubkey": "xchainpub1ulx45dfpqwseens8u2xr0aahpyjuewvdv7wmyk0ptvhlqqd8eal63zhrneplxq4fyur"
    },
    {
      "name": "bob",
      "type": "local",
      "address": "xchain1k8dng03r58gqqa4qafuvtngsg2htx2ha5qp720",
      "pubkey": "xchainpub1ulx45dfpqw7920nduaulukgy8levxd4mwq5vyhc5p0ykgnvwlzdwsx83xw5773ycuqq"
    },
    {
      "name": "carol",
      "type": "local",
      "address": "xchain1tdcqgz7gzwycfp9xtz4adfeyul54ekzvs06tyj",
      "pubkey": "xchainpub1ulx45dfpq0kpnpp9zvv2pmrq9chqpqw3lr2esfvfkwlc0ngdrl7urqa8m04zj4jk6ad"
    },
    {
      "name": "jack",
      "type": "local",
      "address": "xchain1gptswzmh68q5l8jskvvtm8s664v83u3nt7vds9",
      "pubkey": "xchainpub1ulx45dfpqw7yqwvejdysxarsvr98kqng4wxavqun0mkdhafhm8klxs05ure06tseqxt"
    },
    {
      "name": "org1Admin",
      "type": "local",
      "address": "xchain1aamtjy56vpm6uppk6v7r8qtq6qtr45rlxsyq8d",
      "pubkey": "xchainpub1ulx45dfpqdz4mutqv2xka6rx20yrw7cxl6czt5fn6ekkufwxs0ujur59lnt2jkgagy4"
    },
    {
      "name": "org2Admin",
      "type": "local",
      "address": "xchain1tsat26zcw2gr4c4ldejs527jrzvhhhc253y2s6",
      "pubkey": "xchainpub1ulx45dfpqvel03xt6y5xc0s5kfszswempn32dz2gr3lllc2mu34xnqrw3vskkywrr56"
    },
    {
      "name": "org2Peer",
      "type": "local",
      "address": "xchain1u5gpat4l7u36ph9m73g8s3qj8drgu4l5hcadv6",
      "pubkey": "xchainpub1ulx45dfpq0g6ha42fa83n9lgcysdmjx94085pcxfmnncgarxdwqsmp8ycpr9jtgtxg7"
    },
    {
      "name": "org3Admin",
      "type": "local",
      "address": "xchain1dcnqdkcnylenf8y5gk8dphnuejwg5pm49kf8lg",
      "pubkey": "xchainpub1ulx45dfpqtpu8zgzxym2u0mq7w50c9c3j2wc5jz7ku7tphn4h4y0kz7xg04djxpxqdf"
    },
    {
      "name": "org3Peer",
      "type": "local",
      "address": "xchain1awsgmp243gfk3k482n95eun47lnmk96mqzeve3",
      "pubkey": "xchainpub1ulx45dfpqg4thxp3a9fp0cgm00yprdhlfjdktrwea3vrfhln0zs2xfvj4w22yf70qwg"
    },
    {
      "name": "org4Admin",
      "type": "local",
      "address": "xchain1qdh0d7727llzxra3y9z7u0c0seyw4hwx8yeduw",
      "pubkey": "xchainpub1ulx45dfpqtrwmud9lcj8l8hjml6ct3rjztxtx9swy33pdvp5dsl5h80du04qzyxqu4w"
    },
    {
      "name": "org4Peer",
      "type": "local",
      "address": "xchain1ajxnvsqt6934757p0yuxn8v63848fm5nwvh9fj",
      "pubkey": "xchainpub1ulx45dfpqdgl6c2scdl0whr7nr5755cyyz48plqja7ke4hncpu3479nxvcglk00a73w"
    }
  ]
  ```

  添加账户tom

  ```
  xccli keys add tom
  ```

  ```
  root@b8fee4e6a926:/opt# xccli keys add tom
  {
    "name": "tom",
    "type": "local",
    "address": "xchain152xvdpxf7s4f444ytk2s85ejzthmcrwst7jk3v",
    "pubkey": "xchainpub1ulx45dfpqdnmvhkfqxzesmel8pdf30cpqp55v0aas23jel69sh54vc48ksnczkhydgc",
    "mnemonic": "pelican input valid grit arctic glass tomorrow duck loop receive tent argue license lift joke tiger noble quote bid phone rug pattern attack rose"
  }
  ```

- 组织

  查询当前所有组织的信息，可以看到目前的网络中已默认创建了1个网络管理组（level 0级别）NetworkOrg和4个level 1级组织org1-4，以及各组织中的账户（orgAccounts）。

  ```
  xccli query member orgs
  ```

  ```
  root@f54752ddbd9b:/opt# xccli query member orgs
  [
    {
      "orgId": "NetworkOrg",
      "orgFullId": "NetworkOrg",
      "level": "0",
      "orgAdminAddress": "",
      "subOrgIds": null,
      "orgAccounts": [
        "xchain1gptswzmh68q5l8jskvvtm8s664v83u3nt7vds9",
        "xchain1z5ynz4jmv9spaarmmyfgvdp45u7aujxsklqm5h",
        "xchain1k8dng03r58gqqa4qafuvtngsg2htx2ha5qp720",
        "xchain1tdcqgz7gzwycfp9xtz4adfeyul54ekzvs06tyj"
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
      "orgAdminAddress": "xchain1aamtjy56vpm6uppk6v7r8qtq6qtr45rlxsyq8d",
      "subOrgIds": null,
      "orgAccounts": [
        "xchain1aamtjy56vpm6uppk6v7r8qtq6qtr45rlxsyq8d",
        "xchain1z43a0zn9f77dyw84h44v7dcq7pn9g3tp2rmhpu"
      ],
      "orgRoleIds": null,
      "parentId": "",
      "ultParent": "org1",
      "status": "1",
      "preRevokeStatus": "0"
    },
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
    {
      "orgId": "org3",
      "orgFullId": "org3",
      "level": "1",
      "orgAdminAddress": "xchain1dcnqdkcnylenf8y5gk8dphnuejwg5pm49kf8lg",
      "subOrgIds": null,
      "orgAccounts": [
        "xchain1dcnqdkcnylenf8y5gk8dphnuejwg5pm49kf8lg",
        "xchain1awsgmp243gfk3k482n95eun47lnmk96mqzeve3"
      ],
      "orgRoleIds": null,
      "parentId": "",
      "ultParent": "org3",
      "status": "1",
      "preRevokeStatus": "0"
    },
    {
      "orgId": "org4",
      "orgFullId": "org4",
      "level": "1",
      "orgAdminAddress": "xchain1qdh0d7727llzxra3y9z7u0c0seyw4hwx8yeduw",
      "subOrgIds": null,
      "orgAccounts": [
        "xchain1qdh0d7727llzxra3y9z7u0c0seyw4hwx8yeduw",
        "xchain1ajxnvsqt6934757p0yuxn8v63848fm5nwvh9fj"
      ],
      "orgRoleIds": null,
      "parentId": "",
      "ultParent": "org4",
      "status": "1",
      "preRevokeStatus": "0"
    }
  ]
  ```

  使用xccli tx member addOrg命令可以添加新组织org5，组织管理员设为tom。

  ```
  xccli tx member addOrg org5 $(xccli keys show tom -a) --from jack -y
  xccli query member org org5
  ```

  ```
  root@b8fee4e6a926:/opt# xccli tx member addOrg org5 $(xccli keys show tom -a) --from jack -y
  {
    "height": "0",
    "txhash": "20E944F4AC7B6D1810AF5E58F864AD86F22D9049CA494459FCFAB605ECDC5057",
    "raw_log": "[]"
  }
  root@b8fee4e6a926:/opt# xccli query member org org5
  {
    "orgId": "org5",
    "orgFullId": "org5",
    "level": "1",
    "orgAdminAddress": "xchain152xvdpxf7s4f444ytk2s85ejzthmcrwst7jk3v",
    "subOrgIds": null,
    "orgAccounts": [
      "xchain152xvdpxf7s4f444ytk2s85ejzthmcrwst7jk3v"
    ],
    "orgRoleIds": null,
    "parentId": "",
    "ultParent": "org5",
    "status": "0",
    "preRevokeStatus": "0"
  }
  ```

- 角色和权限

  查看所有角色，系统预设角色包括网络管理员（networkAdmin）、组织管理员（orgAdmin）、节点（peer）、一般用户（client），也可以自定义角色。

  ```
  xccli query member roles
  ```

  ```
  root@b8fee4e6a926:/opt# xccli query member roles
  [
    {
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
    }
  ]
  ```

  各角色具有不同的权限， 权限主要由资源名称、策略、状态、合约管理员、权限表达式等部分组成 。例如添加组织（level 1级）的权限只有网络管理员角色具备。

  ```
  xccli query member permissions
  ```

  ```
  root@4245a990dcb1:/opt# xccli query member permissions
    ……
    {
      "resource": "member_addOrg",
      "ownerAddress": "",
      "policy": "1",
      "expElements": [
        {
          "OrgExps": [
            "**"
          ],
          "RoleIds": [
            "networkAdmin"
          ]
        }
      ],
      "status": "1",
      "contractAdmin": "",
      "pendingPermission": {
        "resoure": "",
        "policy": "0",
        "expElements": null
      }
    },
    ……
  ```

- 治理

  组织的增删改查具有状态属性，其中level 1组织添加、冻结、激活、恢复、撤销等全生命周期的状态转换等需要网络管理员投票，半数以上管理员同意的提案才能通过。

  查询投票进行中的提案状态，可以看到添加组织org5的提案目前只有1名管理员同意（即发出提案的jack）。

  ```
  root@b8fee4e6a926:/opt# xccli query gov proposals
  [
    {
      "proposalId": "member_org5",
      "routerKey": "member",
      "opType": "add_org",
      "key": "org5",
      "content": "{\"type\":\"xchain/AddOrg\",\"value\":{\"orgId\":\"org5\",\"orgAdminAddress\":\"xchain152xvdpxf7s4f444ytk2s85ejzthmcrwst7jk3v\",\"owner\":\"xchain1gptswzmh68q5l8jskvvtm8s664v83u3nt7vds9\"}}",
      "approvedAdmins": [
        "xchain1gptswzmh68q5l8jskvvtm8s664v83u3nt7vds9"
      ],
      "refusedAdmins": null
    }
  ]
  ```

  此时提案尚未通过，组织org5为未激活状态（status为0）。

  ```
  root@b8fee4e6a926:/opt# xccli query member org org5
  {
    "orgId": "org5",
    "orgFullId": "org5",
    "level": "1",
    "orgAdminAddress": "xchain152xvdpxf7s4f444ytk2s85ejzthmcrwst7jk3v",
    "subOrgIds": null,
    "orgAccounts": [
      "xchain152xvdpxf7s4f444ytk2s85ejzthmcrwst7jk3v"
    ],
    "orgRoleIds": null,
    "parentId": "",
    "ultParent": "org5",
    "status": "0",
    "preRevokeStatus": "0"
  }
  ```

  半数以上网络管理员投票同意后，提案方可通过。其中1为同意、0为反对，from指定进行投票的账户名。 

  ```
  xccli tx gov vote member_org5 1 --from alice -y
  xccli tx gov vote member_org5 1 --from bob -y
  ```


  此时查看提案状态为空，因为提案已通过。

  ```
  root@b8fee4e6a926:/opt# xccli query gov proposals
  null
  ```


  此时组织的状态为已激活（status为1）。

  ```
  root@b8fee4e6a926:/opt# xccli query member org org5
  {
    "orgId": "org5",
    "orgFullId": "org5",
    "level": "1",
    "orgAdminAddress": "xchain152xvdpxf7s4f444ytk2s85ejzthmcrwst7jk3v",
    "subOrgIds": null,
    "orgAccounts": [
      "xchain152xvdpxf7s4f444ytk2s85ejzthmcrwst7jk3v"
    ],
    "orgRoleIds": null,
    "parentId": "",
    "ultParent": "org5",
    "status": "1",
    "preRevokeStatus": "0"
  }
  ```