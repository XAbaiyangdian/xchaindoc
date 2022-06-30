# 智能合约调用

## 查询合约
命令行调用合约查询方法：
> xccli query wasm contract-state smart <合约名> "{"查询方法名":{查询参数}}"


结果示例：
> xccli query wasm contract-state smart test "{\"find\":{\"key\":\"a\"}}"
> 
![8DE567A1275C66E6C632C22195ECF672](https://user-images.githubusercontent.com/105793954/176608104-2b705e7d-fde5-4835-9652-6c85dfd05864.jpg)


## 升级合约
命令行调用升级合约方法：

> xccli tx wasm migrate <待升级合约名> <升级的合约> 2 "{}" --from <操作者> -y

结果示例：

>  xccli tx wasm migrate test test.wasm 2 "{}" --from jack -y

![image](https://user-images.githubusercontent.com/105793954/176607186-b4f1ae8e-571b-47f2-95d8-3c2f020ed213.png)


## 合约列表
命令行查询合约列表方法：
> xccli q wasm list-contract

结果示例:

![image](https://user-images.githubusercontent.com/105793954/176607355-e07f684f-5aab-4ec6-9e30-98a64b82eaad.png)

## 查询操作情况
执行完每一步操作之后会生成一个txhash,查询该txhash就可以知道操作执行情况
> xccli q tx < txhash>

结果示例：  
![image](https://user-images.githubusercontent.com/105793954/176607441-6426f22f-d54a-4e80-a819-ec54da62f985.png)
