# 智能合约开发

## Go合约

### 概述

本项目为go示例合约，实现了对key/value对的增删查改的功能

### 开发环境

go版本：1.17+  

IDE：Goland或IDEA


- 在拥有智能合约开发环境后，基于gotest合约demo，进行go语言开发。


Demo目录如图

![image](https://user-images.githubusercontent.com/105793954/176583082-f9319548-e0d9-47ca-b78b-dc33eedc4837.png)  

![image](https://user-images.githubusercontent.com/105793954/176583624-56f30f84-01a3-4cb4-b40b-3b88e37dc363.png)


### 编写合约

对合约的编写主要是在example/gotest/src里

- **state.go**  

state.go存放合约使用的存储定义和数据结构定义。  

主要是set存数据和get取数据，对于要存储的数据类型、对应的key都可以自行定义。  

例如：Dome中定义了item结构体，存储item和取出item方法。  

 ![image](https://user-images.githubusercontent.com/105793954/176583836-adfdd583-3ad8-48b9-9e5d-1f3d05d06e85.png)
 
 > storage.Set 传入[]byte类型的key , value.   Demo里saveitem方法将item转化为json格式作为value进行存储 , 可根据自己的需求进行变换。  
 > 
 > storage.Get 传入[]byte类型的key, 返回value.  
 > 
 > 关于storage的方法还有Range，Remove(删除)， 详情查看std/imports.go
 
- **msg.go**

msg.go存放合约接收消息的定义。 

根据**合约需求**定义不同的结构体类型, 里面必须定义InstantiateMsg, ExecuteMsg。  

MigrateMsg QueryMsg 每个结构体里的内容也是根据需求自定义，但需要对应后面的执行。  

示例：  

![image](https://user-images.githubusercontent.com/105793954/176584047-39a2a813-e384-49d0-8e12-61f20e28b6ed.png)

例如，想对合约一次传入2个Item，可以这样定义：

![image](https://user-images.githubusercontent.com/105793954/176584251-8090ba9d-eac3-4130-be0f-3fbccf82faf9.png)

- **contract.go**  

contract.go存放合约各方法的实现 

合约结构体必须包含Instantiate合约方法，用于合约初始化时执行相应逻辑

![image](https://user-images.githubusercontent.com/105793954/176584343-0d202d08-fcdc-4355-af8e-70e0c8b0eb27.png)

Migrate 升级合约    

![image](https://user-images.githubusercontent.com/105793954/176584556-02269d17-e160-4fdb-ad90-be65c504d7d8.png)

合约结构体必须包含Execute合约方法，用于合约执行时处理收到相应消息类型

![image](https://user-images.githubusercontent.com/105793954/176584649-d20fe90c-12e6-445b-9930-b09774dc0d90.png)

> Execute函数相当于一个分流器，根据传入的参数去执行不同的函数，每类消息里的case需要跟msg.go里的定义相对应，下面要执行的函数根据业务需求来写，需要返回的结构体对的response。

Demo中的executeCreatea函数示例：  

> func executeCreate(deps *std.Deps, _ types.Env, _ types.MessageInfo, create *Create) (*types.Response, error) {  
> 
> err := SaveItem(deps.Storage, create.Item)  
> 
> 	if err != nil {  
> 	
> 		return nil, err  
> 		
> 	}  
> 	
>         	return &types.Response{}, nil  
>         	
> }


合约调用合约写法:    

设置和调用合约所需操作的数据结构  

![image](https://user-images.githubusercontent.com/105793954/176587067-32f8a9dd-4772-429a-810f-9de00186abb8.png)

示例操作

![image](https://user-images.githubusercontent.com/105793954/176587093-9885546d-a096-426d-96bd-0941743b8410.png)


合约结构体必须包含Query合约方法，用于合约查询时处理收到相应消息类型。

![image](https://user-images.githubusercontent.com/105793954/176585117-f1aad7f6-43db-4a7f-b121-ad2b25e27691.png)


> Query函数与Execute类似，根据传入的参数去执行不同的函数，每类消息里的case需要跟msg.go里的定义相对应，下面要执行的函数根据业务需求来写，需要返回的结构体对的response。

合约本质上是对链存储的操作。  

![image](https://user-images.githubusercontent.com/105793954/177489864-33915487-6ab7-4aa5-8177-f06a30827b14.png)

 合约操作原语包含对Storage的增删查改，Storage的定义如上所示。  
 
   常用接口如下：  
   
   1.func (s ExternalStorage) Get(key []byte) (value []byte) {}    ：数据查询接口  
   
   2.func (s ExternalStorage) Range(start, end []byte, order Order) (iter Iterator) {} ：范围查询接口
   
   3.func (s ExternalStorage) Set(key, value []byte) {} ： 数据存储接口  
   
   4.func (s ExternalStorage) Remove(key []byte) {}  ：数据删除接口 
   
**合约与链的交互**  

获取链相关信息

Env：定义了此合约运行所在的区块链环境的状态，必须只包含受信任的数据 - Tx 本身中没有尚未验证的数据。Env在传递到wasm合约之前由json转换为byte切片。

>  包含：Block （区块信息，含有高度、时间、链ID）  
>  
> Contract（合约信息，含合约地址）  
> 
> Transaction（交易信息,含有唯一链的事务标识符，以供查询）

获取当前区块高度：

>  env.Block.Height    

获取区块生成时间：

> env.Block.Time

MessageInfo： 包含执行者的地址和一起发送到合同的资金金额的信息。 

获取交易发送者地址：

> types.MessageInfo.Sender

Response: 当instantiate/execute/migrate成功时的返回值。

> 包含：Message（直接来自contract，是对操作的请求。）  
> 
> Data  
> 
> Attributes（日志事件的属性）  
> 
> Events（事件）  

其中messages用于跨模块与跨合约操作，Attributes用于写日志，data用于返回值供链使用  

   示例如下：
   
   跨合约调用
   
   
```
func (r Response) AddWasmMsg(contractName string, msg []byte) Response {
	m := CosmosMsg{
		Wasm: &WasmMsg{
			Execute: &ExecuteMsg{
				ContractAddr: contractName,
				Msg:          msg,
			},
		},
	}
	sm := NewSubMsg(m)
	r.Messages = append(r.Messages, sm)
	return r
}
```

 
 将合约的EventAttribute打印到Attributes
 
 ```
func (r Response) AddAttribute(key string, value string) Response {
	m := EventAttribute{
		key,
		value,
	}
	r.Attributes = append(r.Attributes, m)
	return r
}
```

 将b返回给链，链可以获取到b进行其他操作
    
   ```
func (r Response) SetData(b []byte) Response {
	r.Data = b
	return r
}
```

Deps：传递给contract的可变入口点的依赖。  

> 包含：Storage（提供对数据持久化层的读写访问）  
> 
>      Api（Api提供对常见实用工具的访问，如地址解析和验证。）  
>      
>      Querier（用于查询其他合同的信息。） 




### 编译合约

**1. 编译生成json文件**  

![image](https://user-images.githubusercontent.com/105793954/176584808-811c9101-c98f-496d-9a9d-990820c31dc3.png)  
点击执行小绿三角，执行完毕后可以查看xx_tinyjson.go是否生成更新

**2.编译合约**  

进入Makefile文件，执行gotest语句，或者在终端输入该条指令执行。*[注：${CURDIR)换成当前目录]*  

![image](https://user-images.githubusercontent.com/105793954/176585204-3d405233-2eee-440b-9dad-568b02880879.png)

根据网络情况稍等一段时间后，合约编译完成结果如下所示：  

![image](https://user-images.githubusercontent.com/105793954/176585312-25f68c5c-c51a-45f8-a215-f3e922a3a5c4.png)


编译完成的文件默认在gotest下，目录下，扩展名`wasm`  

![image](https://user-images.githubusercontent.com/105793954/176585464-6d75ff54-5a5d-4bea-a20a-89bbc43c0f33.png)

## Rust合约

### 概述

本项目为Rust示例合约，实现了对key/value对的增删查改的功能。

### 开发环境

Rust版本：1.55+

IDE：Clion或IDEA

### 合约项目目录说明

src目录：存放合约代码。lib.rs中导入其它文件。需要编写的文件为contract.rs、msg.rs、state.rs。

contract.rs存放合约各方法的实现。msg.rs存放合约接收消息的定义。state.rs存放合约使用的存储定义和数据结构定义。

在Cargo.toml中添加项目要导入的依赖。

### 合约主体

智能合约模块支持灵活定义合约方法并对外暴露，以提供区块链模块执行，具体步骤如下：

#### 在msg.rs中必须定义合约接收的消息类型

``` rust
pub struct InstantiateMsg {} // 合约实例化时调用
pub enum ExecuteMsg { // 合约执行时可调用的方法
    Create { item: Item },
}
pub enum QueryMsg { // 合约查询时可调用的方法
    Find { key: String },
}
pub struct MigrateMsg {} // 合约升级时调用
```

#### 在state.rs中定义合约用到的存储和数据结构

引入存储的定义

``` rust
pub const ITEM_KEY: &[u8] = b"item";
```

不同数据类型的存储通过前缀区分

``` rust
pub static STUDENT_KEY: &[u8] = b"student";
```

读写存储的定义：

``` rust
pub fn item_store(storage: &mut dyn Storage) -> Bucket<Item> {
    bucket(storage, ITEM_KEY)
}//写权限的存储访问

pub fn item_store_read(storage: &dyn Storage) -> ReadonlyBucket<Item> {
    bucket_read(storage, ITEM_KEY)
}//读权限的存储访问
```

在contract.rs中可以通过如下方式调用：

``` rust
let item_option = item_store_read(deps.storage).may_load(key.as_bytes())?;//查询


item_store(deps.storage).save(item.key.as_bytes(), &item)?;//存储
```

引入自定义结构体的定义

``` rust
pub struct Item {
    pub key: String,
    pub value: String,
}
```



#### 在contract.rs中写合约各消息类型的实现方法

合约中必须包含instantiate合约方法，用于合约初始化时执行相应逻辑，#[entry_point]表明该方法是合约的一个入口访问点

``` rust
#[entry_point]
pub fn instantiate(
    _deps: DepsMut,
    _env: Env,
    _info: MessageInfo,
    _msg: InstantiateMsg,
) -> StdResult<Response> {
    Ok(Response::default())
}
```

合约中必须包含execute合约方法，用于合约执行时处理收到相应消息类型，#[entry_point]表明该方法是合约的一个入口访问点

``` rust
#[entry_point]
pub fn execute(
    deps: DepsMut,
    _env: Env,
    _info: MessageInfo,
    msg: ExecuteMsg,
) -> StdResult<Response> {
    match msg {
        ExecuteMsg::Create { item } => create(deps, item),
    }
}
```

合约中必须包含query合约方法，用于合约查询时处理收到相应消息类型，#[entry_point]表明该方法是合约的一个入口访问点

``` rust
#[entry_point]
pub fn query(
    deps: Deps,
    _env: Env,
    msg: QueryMsg,
) -> StdResult<QueryResponse> {
    match msg {
        QueryMsg::Find { key } => find(deps, key),
    }
}
```

合约中必须包含migrate合约方法，用于合约升级化时执行相应逻辑，#[entry_point]表明该方法是合约的一个入口访问点

``` rust
#[entry_point]
pub fn migrate(
    _deps: DepsMut,
    _env: Env,
    _msg: MigrateMsg,
) -> StdResult<Response> {
    Ok(Response::default())
}
```



#### 实现方法

   合约本质上是对链存储的操作。

   合约操作原语包含对store的增删查改。store的定义如上所示。

   >常用接口如下：
   >
   >> 1. <font color=#795ca3>store(&mut deps.storage).may_load(key.as_bytes())</font>: 数据查询接口
   >> 2. <font color=#795ca3>store(&mut deps.storage).save(key.as_bytes(), &value)</font>: 数据存储接口
   >> 3. <font color=#795ca3>store(&mut deps.storage).remove(key.as_bytes())</font>: 数据删除接口
   >> 4. <font color=#795ca3>Err(StdError::generic_err(""))</font>: 返回错误接口<br />

   > 使用方法示例具体如下：

   ``` rust
   fn create(deps: DepsMut, item: Item) -> StdResult<Response> {
       let existed_value = store(&mut deps.storage).may_load(key.as_bytes())?;
       if existed_value.is_some() {
           return Err(StdError::generic_err("The key already existed"));
       }
       store(&mut deps.storage).save(key.as_bytes(), &value)?;
       Ok(Response::default())
   }
   ```

   

#### 合约与链的交互

   获取链相关信息

   合约实现方法中包含参数Env，其结构如下所示

   ``` rust
   pub struct Env {
       pub block: BlockInfo,
       pub transaction: Option<TransactionInfo>,
       pub contract: ContractInfo,
   }
   ```

   ``` rust
   pub struct BlockInfo {
       pub height: u64,
       pub time: Timestamp,
       pub chain_id: String,
   }
   ```

   ``` rust
   pub struct TransactionInfo {
       pub index: u32,
   }
   ```

   ``` rust
   pub struct ContractInfo {
       pub address: Addr,
   }
   ```

   合约实现方法中包含参数MessageInfo，其结构如下所示

   ``` rust
   pub struct MessageInfo {
	   pub sender: Addr,
	   pub funds: Vec<Coin>,
   }
   ```

   如在合约方法中获取合约调用者地址可以如下操作

   ``` rust
   let sender = info.sender.to_string();
   ```

   合约方法返回消息类型定义如下

   ``` rust
   pub struct Response<T = Empty> {
       pub messages: Vec<SubMsg<T>>,
       pub attributes: Vec<Attribute>,
	   pub events: Vec<Event>,
       pub data: Option<Binary>,
   }
   ```

   其中messages用于跨模块与跨合约操作

   attributes用于写日志

   data用于返回值供链使用，示例如下

   跨合约调用

   ``` rust
   let cross_msg = CrossMsg { create: CrossParam { item } };
    Ok(Response::new()
        .add_message(CosmosMsg::Wasm(WasmMsg::Execute {
            contract_addr: "test".to_string(),
            msg: to_binary(&cross_msg).unwrap(),
            funds: vec![],
        })))
   ```

   将合约create函数名和attribute_value变量打印到log

   ``` rust
   Ok(Response::new()
        .add_attribute("create", attribute_value))
   ```

   将result返回给链，链可以获取到result进行其他操作

   ``` rust
   Ok(Response::new().set_data(result.as_bytes()))
   ```



### 官方库支持

智能合约由Rust官方编译支持，支持除浮点数、随机数、时间外的大部分Rust官方库与特性

### 第三方库支持

支持如schemars、serde、snafu、p256、hex、pem、x509等

### 编译

基于合约Demo，进行Rust语言开发，Demo为IDEA的Rust工程

安装Rust环境

[https://www.rust-lang.org/zh-CN/tools/install]

安装wasm编译插件

```
rustup target add wasm32-unknown-unknown
```

将合约编译成wasm文件

```
cargo build --release --target wasm32-unknown-unknown
```

编译完的wasm文件在target/wasm32-unknown-unknown/release/test.wasm路径

### 合约部署

* 命令行部署

```
合约部署详情查看
xccli tx wasm instantiate -h

举例
xccli tx wasm instantiate test.wasm rust 2 "{}" test --from jack --gas="800000" --gas-adjustment="1.2" -y
```

* Java-SDK：见SDK示例org/xbl/xchain/sdk/example中，RustContract相关测试。

### 合约调用

* 命令行

```
命令说明：
xccli tx wasm execute -h

举例：
PUT='{"create":{"item":{"key":"key1","value":"value1"}}}'
xccli tx wasm execute test "$PUT" --from jack --gas="800000" -y
```

* Java-SDK：见SDK示例org/xbl/xchain/sdk/example中，RustContract相关测试。


### 合约查询

* 命令行

```
命令说明：
xccli query wasm -h

举例
QUERY='{"find":{"key":"key1"}}'
xccli query wasm contract-state smart test "$QUERY"
```

### 合约升级

* 命令行

``` 
命令说明：
xccli tx wasm migrate -h
 
举例:  
xccli tx wasm migrate test test1.wasm 2 "{}" --from jack --gas="800000" --gas-adjustment="1.2" -y
```

### 查看交易状态

`xccli query tx txhash`

其中txhash用交易返回的txhash替换

* Java-SDK：见SDK示例org/xbl/xchain/sdk/example中，RustContract相关测试。
