# 查询区块链信息

## 运行环境说明

- xccli安装在节点容器内，可以进入容器或者通过docker exec执行。
- curl命令是通过节点的rpc执行，可通过宿主机或容器调用执行。

## 查询最新区块信息

```shell script
xccli query block
```

```
curl -X GET "#{address}:#{port}/block"
```

### 参数说明：

- address:节点地址
- port:节点端口

## 查询特定高度区块

```shell script
xccli query block #{height}
```

```
curl -X GET "#{address}:#{port}/block?height=#{height}"
```

### 参数说明：

- height:区块高度
- address:节点地址
- port:节点端口

### 举例：

- 查询高度415的区块信息

```shell script
xccli query block 415
```

```
curl -X GET "127.0.0.1:26657/block?height=415"
```

## 查询交易详情

```shell script
xccli query tx #{txhash}
```

```
curl -X GET "#{address}:#{port}/tx?hash=%22#{txhash}%22"
```

### 参数说明：

- txhash:执行交易时返回
- address:节点地址
- port:节点端口


### 举例：

- 查询txhash为B570F74EF155B6EFEE7320DD878FD24974AFAC210D29DBFD3A7A69F1F61883A2的交易详情

```shell script
xccli query tx B570F74EF155B6EFEE7320DD878FD24974AFAC210D29DBFD3A7A69F1F61883A2
```

```
curl -X GET "127.0.0.1:26657/tx?hash=%22B570F74EF155B6EFEE7320DD878FD24974AFAC210D29DBFD3A7A69F1F61883A2%22"
```

## 查询所有交易

```shell script
curl -X GET "#{address}:#{port}/tx_search?query=%22tx.height%3E#{min_height}%20and%20tx.height%3C#{max_height}%22&page=#{page_num}&per_page=#{tx_per_page}&order_by=%22#{order}%22" -H "accept: application/json"
```

### 参数说明：

- address:节点地址
- port:节点端口
- min_height:区块高度下限，查询区块高度>min_height
- max_height:区块高度上限，查询区块高度<max_height
- page_num:打印页数
- tx_per_page:每页打印交易数
- order:排序方式，desc为降序，asc为增序

### 举例：

- 查询高度大于400小于500的区块包含的所有交易，降序打印，每页一条打印一页，也就是只打印最新的一条交易，返回的total_count为交易总数

```shell script
curl -X GET "127.0.0.1:26657/tx_search?query=%22tx.height%3E400%20and%20tx.height%3C500%22&page=1&per_page=1&order_by=%22desc%22" -H "accept: application/json"
```