# 智能合约开发

# Rust合约

## 概述

本项目为Rust示例合约，实现了对key/value对的增删查改的功能。

## 开发环境

Rust版本：不限
IDE：Clion或Idea

## 合约项目目录说明

src目录：存放合约代码。其中lib.rs为合约总入口。需要编写的文件为contract.rs、msg.rs、state.rs。

contract.rs存放合约各方法的实现。msg.rs存放合约接收消息的定义。state.rs存放合约使用的存储定义和数据结构定义。

在Cargo.toml中添加项目要导入的依赖。

## 合约主体

智能合约模块支持灵活定义合约方法并对外暴露，以提供区块链模块执行，具体步骤如下：

1. 在msg.rs中必须定义合约接收的消息类型

``` go
pub struct InitMsg {} // 合约实例化时调用
pub enum HandleMsg { // 合约执行时可调用的方法
    Create { key: String, value: String },
    Update { key: String, value: String },
    Delete { key: String },
}
pub enum QueryMsg { // 合约查询时可调用的方法
    Find { key: String },
}
pub struct MigrateMsg {} // 合约升级时调用
```

2. 在state.rs中定义合约用到的存储和数据结构

引入存储的定义

```
pub static STUDENT_KEY: &[u8] = b"student";
```

不同存储有不同的Key，实质上是通过前缀区分不同类型的存储。

```
pub static ITEM_KEY: &[u8] = b"item";
```

读写存储的定义：

```
pub fn student_store<S: Storage>(storage: &mut S)
    -> Bucket<S, Student> {
    bucket(STUDENT_KEY, storage)
}//写权限的存储访问

pub fn student_store_read<S: Storage>(storage: &S)
    -> ReadonlyBucket<S, Student> {
    bucket_read(STUDENT_KEY, storage)
}//读权限的存储访问
```

在contract.rs中可以通过如下方式调用：

```
let student_option = student_store_read(&deps.storage).may_load(stu.id.as_bytes())? ;//查询


student_store(&mut deps.storage)
        .save(stu.id.as_bytes(), &stu)?;//存储
```

引入自定义结构体的定义

```
pub struct Student {
	pub id: String,
	pub name: String,
}
```



3. 在contract.rs中写合约各消息类型的实现方法

合约结构体必须包含init合约方法，用于合约初始化时执行相应逻辑

``` go
pub fn init<S: Storage, A: Api, Q: Querier>(
    deps: &mut Extern<S, A, Q>,
    env: Env,
    msg: InitMsg,
) -> StdResult<InitResponse> {
    Ok(InitResponse::default())
}
```

合约结构体必须包含handle合约方法，用于合约执行时处理收到相应消息类型

``` go
pub fn handle<S: Storage, A: Api, Q: Querier>(
    deps: &mut Extern<S, A, Q>,
    env: Env,
    msg: HandleMsg,
) -> StdResult<HandleResponse> {
    match msg {
        HandleMsg::Create {key, value} =>
            create(deps, env, key, value),
        HandleMsg::Update{key, value}=>
            update(deps, env, key, value),
        HandleMsg::Delete{key}=>
            delete(deps, env, key),
    }
}
```

合约结构体必须包含query合约方法，用于合约查询时处理收到相应消息类型

``` go
pub fn query<S: Storage, A: Api, Q: Querier>(
    deps: &Extern<S, A, Q>,
    msg: QueryMsg,
) -> StdResult<Binary> {
    match msg {
        QueryMsg::Find { key } =>
            query_key(deps, key),
    }
}
```



4. 实现方法

   合约本质上是对链存储的操作。

   合约操作原语包含对store的增删查改。store的定义如上所示。

   >常用接口如下：
   >
   >> 1. <font color=#795ca3>store(&mut deps.storage).may_load(key.as_bytes())</font>: 数据查询接口
   >> 2. <font color=#795ca3>store(&mut deps.storage).save(key.as_bytes(), &value)</font>: 数据存储接口
   >> 3. <font color=#795ca3>store(&mut deps.storage).remove(key.as_bytes())</font>: 数据删除接口
   >> 4. <font color=#795ca3>Err(StdError::generic_err(""))</font>: 返回错误接口<br />

   > 使用方法示例具体如下：

   ``` go
   pub fn create<S: Storage, A: Api, Q: Querier>(
       deps: &mut Extern<S, A, Q>,
       _env: Env,
       key: String,
       value: String,
   ) -> StdResult<HandleResponse> {
       let existed_value = store(&mut deps.storage).may_load(key.as_bytes())?;
       if existed_value.is_some() {
           return Err(StdError::generic_err("The key already existed"));
       }
       store(&mut deps.storage).save(key.as_bytes(), &value)?;
       Ok(HandleResponse::default())
   }
   ```

   

5. 合约与链的交互

   获取链相关信息

   合约实现方法中包含参数Env，其结构如下所示

   ```
   pub struct Env {
       pub block: BlockInfo,
       pub message: MessageInfo,
       pub contract: ContractInfo,
   }
   ```

   ```
   pub struct BlockInfo {
       pub height: u64,
       pub time: u64,
       pub chain_id: String,
   }
   ```

   ```
   pub struct MessageInfo {
       pub sender: HumanAddr,
       pub sent_funds: Vec<Coin>,
   }
   ```

   ```
   pub struct ContractInfo {
       pub address: HumanAddr,
   }
   ```

   如在合约方法中获取合约调用者地址可以如下操作

   ```
   let sender = env.message.sender.to_string();
   ```

   合约方法返回消息类型定义如下

   ```
   pub struct HandleResponse<T = Empty>
   where
       T: Clone + fmt::Debug + PartialEq + JsonSchema,
   {
       pub messages: Vec<CosmosMsg<T>>,
       pub log: Vec<LogAttribute>,
       pub data: Option<Binary>,
   }
   ```

   其中messages用于跨模块与跨合约操作

   log用于写日志

   data用于返回值供链使用，示例如下

   跨合约调用

   ```Ok(HandleResponse{
   Ok(HandleResponse {      
       messages: vec![CosmosMsg::Wasm(WasmMsg::Execute {
           contract_name: contract_name,
           msg: to_binary(&cross_msg).unwrap(),
           send: vec![]
       })],
       log: vec![],
       data: None,
   })
   ```

   将合约方法中的id变量打印到log

   ```
   Ok(HandleResponse {
       messages: vec![],
       log: vec![log("id", &id)],
       data: None,
   })
   ```

   将result返回给链，链可以获取到result进行其他操作

   ```
   Ok(HandleResponse {
       messages: vec![],
       log: vec![],
       data: Some(Binary::from(result.as_bytes())),
   })
   ```



## 官方库支持

智能合约由Rust官方编译支持，支持除浮点数、随机数、时间外的大部分Rust官方库与特性

## 第三方库支持

支持如schemars、serde、snafu、p256、hex、pem、x509等

## 编译

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

编译完的wasm文件在target/wasm32-unknown-unknown/release/crud.wasm路径下

## 合约部署

* 命令行部署

```
合约部署详情查看
xccli tx wasm instantiate -h

举例
xccli tx wasm instantiate 合约名称.wasm rust 2 "{}" 合约名 --from 用户  --gas="80000000" --gas-adjustment="1.2" -y
```

* Java-SDK：见SDK示例org/xbl/xchain/sdk/example中，RustContract相关测试。

## 合约调用

* 命令行

```
命令说明：
xccli tx wasm execute -h

举例：
xccli tx wasm execute 合约名 参数 --from 用户 --gas="80000000" -y
```

* Java-SDK：见SDK示例org/xbl/xchain/sdk/example中，RustContract相关测试。

> 跨合约调用：本项目暂时未用到，后面补充

## 合约查询

* 命令行

```
命令说明：
xccli query wasm -h

举例
xccli query wasm contract-state  smart  合约名  参数
```

## 合约升级

* 命令行

``` 
命令说明：
xccli tx wasm migrate -h
 
举例:  
xccli tx wasm migrate 合约名 合约名称.wasm 2 "{}" --from 用户 --gas="80000000" -y
```

## 查看交易状态

`xccli query tx txhash`

其中txhash用交易返回的txhash替换

* Java-SDK：见SDK示例org/xbl/xchain/sdk/example中，RustContract相关测试。



# Go合约

## 概述

本项目针对wasm的解析和处理，定义了一套基于Go的合约编写、编译、部署与执行的标准规范，实现了通用、便捷、灵活的智能合约开发流程

## 开发环境

Go版本：1.14+
IDE：GoLand

## 合约项目目录说明

> contract-sdk包：其中包含合约依赖contract-sdk/go/code与contract-sdk/go/driver包

> > code为合约提供可使用的数据结构标准

> > driver负责解析合约结构体中的方法并将其暴露到外部供调用

> bridge包：各语言通用的与链交互的数据结构定义

> 合约主文件：main包，例如student项目中的student.go


## 合约主体

智能合约模块支持灵活定义合约方法并对外暴露，以提供区块链模块执行，具体步骤如下：

1. 定义合约结构体

``` go
type ChainCode struct {} // 合约结构体主要作为合约方法的承载介质，结构体名称可以灵活定义
```

2. 处理合约结构体

```
// 引入合约依赖包，code与driver
import (
  "xa.org/xablockchain/wasmer/contractsdk/go/code"
  "xa.org/xablockchain/wasmer/contractsdk/go/driver"
)
// 合约调用
func main() {
	driver.Serve(new(Chaincode))  // 调用driver解析结构体并对外暴露其方法
}
```

3. 添加方法

>为合约结构体新增合约方法

合约结构体必须包含Initialize合约方法，用于合约初始化时执行相应逻辑

``` go
func (c *Chaincode) Initialize(ctx code.Context, args []string) code.Response {
	return code.OK([]byte("Initialize finish"))
}
//其他方法
func (c *Chaincode) XXXX(ctx code.Context, args []string) code.Response {
	return code.OK([]byte("GetInvoke finish"))
}
```

4. 操作原语

`* ctx code.Context`: 提供跟链交互的操作原语，为开发者提供智能合约开发的各类基本功能入口，可以在合约的自定义函数中调用，具体使用方法见示例合约

>原语种类如下：
>
>> 1. <font color=#795ca3>PutObject</font>: 数据存储接口
>> 2. <font color=#795ca3>GetObject</font>: 数据获取接口
>> 3. <font color=#795ca3>DeleteObject</font>: 数据删除接口
>> 4. <font color=#795ca3>NewIterator</font>: 数据范围获取接口，返回标准迭代器
>> 5. <font color=#795ca3>CrossCall</font>: 跨合约的调用接口
>> 6. <font color=#795ca3>SetEvent</font>: 事件支持接口
>> 7. <font color=#795ca3>GetBlockHash</font>: 获取当前区块Hash
>> 8. <font color=#795ca3>GetBlockHeight</font>: 获取当前区块高度
>> 9. <font color=#795ca3>GetTxHash</font>: 获取当前交易Hash
>> 10. <font color=#795ca3>GetUser</font>: 获取当前调用用户
>> 11. <font color=#795ca3>GetContractAddr</font>: 获取当前合约地址
>> 12. <font color=#795ca3>SetOutput</font>: 跨模块消息传输
>> 13. <font color=#795ca3>SendCustomMsg</font>: 跨模块查询
>> 14. <font color=#795ca3>Logln</font>: 日志打印接口 <br />
>> 15. <font color=#795ca3>JsonIterator</font>: 复杂查询支持，在配置Postgresql可使用

## 官方库支持

智能合约由Go官方编译支持，支持除协程、time、rand、syscall、os外的大部分Go官方库与特性

## 第三方库支持

支持基于Go官方库开发的大多数第三方库，如有常用功能无法支持可在后续作为独立的功能接口进行扩展

## 编译

golang 原生支持 wasm 编译，以test.go为例

```sh
GOOS=js GOARCH=wasm go build -o test.wasm test.go ## linux
```

## Windows支持

```
go env -w GOOS=js
go env -w GOARCH=wasm
go build -o test.wasm test.go
```

## 合约部署

* 命令行部署

```
合约部署详情查看
xccli tx wasm instantiate -h

举例
xccli tx wasm instantiate 合约名称.wasm golang 2 "{}" 合约名 --from 用户  --gas="80000000" --gas-adjustment="1.2" -y
```

* Java-SDK：见SDK示例org/xbl/xchain/sdk/example中，GoContract相关测试。

## 合约调用

* 命令行

```
命令说明：
xccli tx wasm execute -h

举例：
APPROVE='{"method":"方法名称","value":["key","value"]}'
xccli tx wasm execute 合约名 "$APPROVE" --from 用户 --gas="80000000" --gas-adjustment="1.2" -y
```

* Java-SDK：见SDK示例org/xbl/xchain/sdk/example中，GoContract相关测试。

> 跨合约调用：本项目暂时未用到，后面补充

## 合约查询

* 命令行

```
命令说明：
xccli query wasm -h

举例
QUERY='{"method":"方法名","value":["lzh"]}' //方法中仅有GetObject原语操作的方法
xccli query wasm contract-state  smart  合约名  "$QUERY"
```

* Java-SDK：见SDK示例org/xbl/xchain/sdk/example中，GoContract相关测试。

## 合约升级

* 命令行

``` 
命令说明：
xccli tx wasm migrate -h
 
举例:  
xccli tx wasm migrate 合约名 合约名称.wasm 2 "{}" --from 用户 --gas="80000000" --gas-adjustment="1.2" -y
```

## 查看交易状态

`xccli query tx txhash`

其中txhash用交易返回的txhash替换

* Java-SDK：见SDK示例org/xbl/xchain/sdk/example中，GoContract相关测试。