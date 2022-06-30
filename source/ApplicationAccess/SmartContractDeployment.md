# 智能合约部署

智能合约成功生成wasm文件后，进行合约部署
## 合约上传
节点启动后，部署合约

执行语句：

> xccli tx wasm instantiate <要上传的合约> <语言> <权限> "{}" <部署后的合约名> --from <操作者> -y


结果示例：

> xccli tx wasm instantiate test.wasm rust 2 "{}" test --from jack -y  

![image](https://user-images.githubusercontent.com/105793954/176606573-ce56338b-8c07-4c8d-a175-d2e8b61110eb.png)


## 调用合约
执行语句：
> xccli tx wasm execute <合约名>  {"合约方法名":{合约参数}} --from <操作者> -y


结果示例：
>  xccli tx wasm execute test  "{\"create\":{\"item\":{\"key\":\"a\",\"value\":\"1\"}}}" --from jack -y  

![image](https://user-images.githubusercontent.com/105793954/176606715-f559b938-01c0-4db1-bb97-46c7f0f15052.png)
