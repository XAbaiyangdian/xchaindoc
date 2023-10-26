# 查询区块链信息

## 查询最新区块信息

```shell script
xccli query block
```

## 查询特定高度区块

```shell script
xccli query block 区块高度
```

举例：查询高度415的区块信息

```shell script
xccli query block 415
```

## 查询交易详情

```shell script
xccli query tx txhash(执行交易时返回)
```

举例：查询txhash为B570F74EF155B6EFEE7320DD878FD24974AFAC210D29DBFD3A7A69F1F61883A2的交易详情

```shell script
xccli query tx B570F74EF155B6EFEE7320DD878FD24974AFAC210D29DBFD3A7A69F1F61883A2
```

## 查询所有交易

```shell script
curl -X GET "地址:26657/tx_search?query=%22tx.height%3E区块高度下限%20and%20tx.height%3C区块高度上限%22&page=打印页数&per_page=每页打印交易数&order_by=%22排序方式,desc为降序，asc为增序%22" -H "accept: application/json"
```

示例：查询高度大于400小于500的区块包含的所有交易，降序打印，每页一条打印一页，也就是只打印最新的一条交易，返回的total_count为交易总数

```shell script
curl -X GET "127.0.0.1:26657/tx_search?query=%22tx.height%3E400%20and%20tx.height%3C500%22&page=1&per_page=1&order_by=%22desc%22" -H "accept: application/json"
```

