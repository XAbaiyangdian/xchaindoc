# 智能合约调用

- 命令行调用合约事务方法

    ```
    xccli tx wasm execute <合约名> '{"合约方法名":{合约参数}}' --from <账户名> --gas="800000" --gas-adjustment="1.2" -y --node <节点地址> --chain-id=xchain
    ```

    命令行调用合约事务方法的具体样例：   
    ```
    xccli tx wasm execute patient '{"register_patient":{"patient":{"name":"alice","sex":"male","age":"21","nation":"han","ismarried":true,"occupation":"teacher","regtime":"2020-11-09 12:00:00","id":"110101190012090903","telephonenum":"12345678876","contact":"123456"}}}' --from jack --gas="800000" --gas-adjustment="1.2" -y --node tcp://localhost:26657 --chain-id=namechain
    ```   
    ![](picture/4bb7aef0f685f7bd33900b1f6929ccdd.png )

- 命令行调用合约查询方法

    ```
    xccli query wasm contract-state smart <合约名> '{"查询方法名":{查询参数}}' --node <节点地址> --chain-id=xchain
    ```

    命令行调用合约查询方法的具体样例：   
    ```
    xccli query wasm contract-state smart patient '{"query_patients":{"precardid":"11010119001209090"}}' --node tcp://localhost:26657 --chain-id=namechain
    ```
    ![](../image/44c4d5529f5967328766d232ba5fa72b.png)

- 查询交易状态代码如下：

    ```
    xccli query tx txhash
    ```

    样例说明图如下所示：   
    ![交易状态查询样例](picture/8dd591e81c93431320f03b105bda5f8a.png "交易状态查询样例")

- SDK调用合约方法见Demo
