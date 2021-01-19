# RestAPI

## 组织

1. 添加组织并设置组织管理员

    ```
    URL	/member/orgs
    Method	POST
    Content-type	application/json
    Param	{
        "base_req":{
            "from":"",
            "chain_id":"",
            "password":""
        },
        "orgId":"",
        "orgAdminAddress":""
        "parentOrgFullId":""
    }
    ```

2. 撤销组织

    ```
    URL	/member/orgs/{orgFullId}
    Method	DELETE
    Content-type	application/json
    Param	{
        "base_req":{
            "from":"",
            "chain_id":"",
            "password":""
        }
    }
    ```
3. 冻结组织

    ```
    URL	/member/orgs/{orgFullId}
    Method	PUT
    Content-type	application/json
    Param	{
       "base_req":{
           "from":"",
           "chain_id":"",
           "password":""
       },
       "type":1 freeze  2 unfreeze
    }
    ```

4. 组织解冻（**同上**）


5. 修改组织管理员

    ```
        URL	/member/orgs/{orgFullId}/orgadmin
		Method	PUT
		Content-type	application/json
		Param	{
		    "base_req":{
		        "from":"",
		        "chain_id":"",
		        "password":""
		    },
		    "newAdminAddress":""
		}
    ```

6. 添加网络管理员

    ```
        URL	/member/nwadmins
		Method	POST
		Content-type	application/json
		Param	{
		    "base_req":{
		        "from":"",
		        "chain_id":"",
		        "password":""
		    },
		    "address":""
		}
    ```

7. 删除网络管理员

    ```
        URL	/member/nwadmins/{address}
		Method	DELETE
		Content-type	application/json
		Param	{
		    "base_req":{
		        "from":"",
		        "chain_id":"",
		        "password":""
		    },
		}
    ```

8. 获取组织详情

    ```
    URL	/member/orgs/{orgFullId}
	Method	GET
    ```

9. 获取组织详情列表

    ```
    URL	/member/orgs/
	Method	GET
    ```

## 角色

1. 创建组织自定义角色

    ```
        URL	/member/orgs/{orgFullId}/roles
		Method	POST
		Content-type	application/json
		Param	{
		    "base_req":{
		        "from":"",
		        "chain_id":"",
		        "password":""
		    },
		    "roleId":"",
		    "baseRoleId":"",
		}
    ```

2. 撤销角色

    ```
        URL	/member/orgs/{orgFullId}/roles/{roleId}
		Method	DELETE
		Content-type	application/json
		Param	{
		    "base_req":{
		        "from":"",
		        "chain_id":"",
		        "password":""
		    }
		}
    ```

3. 查看角色详情

    ```
    URL	/member/roles/{roleFullId}
	Method	GET
    ```

4. 获取角色详情列表

    ```
    URL	/member/roles/{roleFullId}
	Method	GET
    ```

## 账户

1. 添加账号

    ```
        URL	/member/accounts
		Method	POST
		Content-type	application/json
		Param	{
		    "base_req":{
		        "from":"",
		        "chain_id":"",
		        "password":""
		    },
		    "address":"",
		    "orgFullId":"",
		    "roleId":""
		}
    ```

2. 撤销账号

    ```
        URL	/member/accounts/{address}
		Method	DELETE
		Content-type	application/json
		Param	{
		    "base_req":{
		        "from":"",
		        "chain_id":"",
		        "password":""
		    }
		}
    ```

3. 冻结账号\账号解除冻结\给账号添加或删除角色

    ```
        URL	/member/accounts/{address}
		Method	PUT
		Content-type	application/json
		Param	{
		    "base_req":{
		        "from":"",
		        "chain_id":"",
		        "password":""
		    },
		    "roleId":"",
		    "type":0 removerole 1 addrole 2 freeze 3 unfreeze
		}
    ```

4. 查看账号详情

    ```
    	URL	/member/accounts/{address}
		Method	GET
    ```

5. 获取账号详情列表

    ```
    URL	/member/accounts
	Method	GET
    ```

## 权限

### 模块交易执行权限

1. 添加或修改权限

    ```
        URL	/member/permissions/{resource}
		Method	PUT
		Content-type	application/json
		Param	{
		    "base_req":{
		        "from":"",
		        "chain_id":"",
		        "password":""
		    },
		    "policy":"",
		    "expElements":[
		        {
		            "OrgExps":[

		            ],
		            "RoleIds":[

		            ]
		        }
		    ]
		}
    ```

2. 获取权限列表

    ```
    URL	/member/permissions
	Method	GET
    ```

3. 获取单个权限

    ```
    URL	/member/permissions/{resource}
	Method	GET
    ```

4. 检查账号是否拥有权限

    ```
    URL	/member/checkpermission/{address}/{resource}
	Method	GET
    ```

### 合约权限管理

### 网络权限

## 治理

1. 投票

    ```
    URL	/gov/proposals/{proposalId}
	Method	PUT
	Content-type	application/json
	Param	{
	    "base_req":{
	        "from":"",
	        "chain_id":"",
	        "password":""
	    },
	    "pass":"true/false",
	}
    ```

2. 获取单个提案

    ```
    	URL	/gov/proposals/{proposalId}
		Method	GET
    ```

3. 获取所有提案

    ```
    	URL	/gov/proposals
		Method	GET
    ```

## 共识

1. 创建Validator

    ```
    	URL	/poa/validators
		Method	POST
		Content-type	application/json
		Param	{
		    "base_req":{
		        "from":"",
		        "chain_id":"",
		        "password":""
		    },
		    "pubkey":"",
		    "power":"",
		    "moniker":"",
		    "identity":"",
		    "website":"",
		    "security_contact":"",
		    "details":""
		}
    ```

2. 修改Validator

    ```
    	URL	/poa/validators/{validatorAddress}
		Method	PUT
		Content-type	application/json
		Param	{
		    "base_req":{
		        "from":"",
		        "chain_id":"",
		        "password":""
		    },
		    "power":""
		}
    ```

3. 查询指定高度的Validator

    ```
        URL	/poa/historical_info/{height}
        Method	GET
    ```

4. 查询PoA模块的参数

    ```
        URL	/poa/parameters
        Method	GET
    ```

5. 获取指定Validator

    ```
        URL	/poa/validators/{validatorAddr}
        Method	GET
    ```

6. 获取所有Validator

    ```
        URL	/poa/validators
        Method	GET
    ```

## 参数管理

1. 修改参数

    ```
    URL	/params/{subspace}/{key}
    Method	PUT
    Content-type	application/json
    Param	{
        "base_req":{
        "from":"",
        "chain_id":"",
        "password":""
        },
        "value":""
    }

## 合约

1. 上传合约

    ```
		URL	/wasm/code
		Method	POST
		Content-type	application/json
		Param	{
		    "base_req":{
		        "from":"",
		        "chain_id":"",
		        "password":""
		    },
		    "wasm_bytes":"",
		    "execute_perm":"",
		    "language":"",
		    "label":"",
		    "policy":""
		}
    ```

2. 部署合约

    ```
		URL	/wasm/code/{codeId}
		Method	POST
		Content-type	application/json
		Param	{
		    "base_req":{
		        "from":"",
		        "chain_id":"",
		        "password":""
		    },
		    "admin":"",
		    "init_msg":"",
		    "contract_name":""
		}
    ```

3. 执行合约

    ```
		URL	/wasm/contract/{contractName}
		Method	POST
		Content-type	application/json
		Param	{
		    "base_req":{
		        "from":"",
		        "chain_id":"",
		        "password":""
		    },
		    "exec_msg":""
		}
    ```

4. 升级合约

    ```
		URL	/wasm/contract/{contractName}/code
		Method	PUT
		Content-type	application/json
		Param	{
		    "base_req":{
		        "from":"",
		        "chain_id":"",
		        "password":""
		    },
		    "admin":"",
		    "code_id":"",
		    "migrate_msg":""
		}
    ```

5. 查询已上传合约

    ```
		URL	/wasm/code
		Method	GET
    ```

6. 查询合约信息

    ```
		URL	/wasm/contract/{contractName}
		Method	GET
    ```

7. 调用合约内部查询方法

    ```
		URL	/wasm/contract/{contractName}/smart/{query}
		Method	GET
		Param	{
            "encoding":"base64"
        		}
    ```
    *query:将查询的json编码成base64的格式*
