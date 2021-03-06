# Docker部署

## 单节点启动

1. 下载文件 xchain-alone.tar

下载路径：

<a href="https://gitee.com/xabl/xchain/blob/master/xchain-alone.tar" target="_blank">https://gitee.com/xabl/xchain/blob/master/xchain-alone.tar</a>

2. 在终端运行

   ```
   docker load<xchain_alone.tar
   docker run -d --name=xchain-alone -p 26657:26657 -p 26656:26656 -p 1317:1317  xchain-alone:1.0.0
   ```

   

   数据目录/opt/data，可以通过-v启动容器，挂载到宿主机指定目录，如：

   ```
   docker run -d --name=xchain-alone -p 26657:26657 -p 1317:1317 -v /data:/opt/data xchain-net:1.0.0
   ```



3. 查看docker下有哪些容器

   ```
   docker ps
   ```

   

4. 进入xchain-alone容器命令行里

   ```
   docker exec -it xchain-alone /bin/bash
   ```

   

## 4节点同时启动

1. 下载文件 xchain-net.tar

下载路径：

<a href="https://gitee.com/xabl/xchain/blob/master/xchain-net.tar" target="_blank">https://gitee.com/xabl/xchain/blob/master/xchain-net.tar</a>

2. 在终端运行

   ```
   docker load<xchain_net.tar
   docker-compose -p xchain-net up -d
   ```

   

3. 查看docker下有哪些容器

   ```
   docker ps
   ```

   

4. 进入到某个单节点容器里的命令可以参考单节点启动里介绍的方法。这里以xchain_node01节点容器为例子：

   ```
   docker exec -it xchain_node01 /bin/bash
   ```

   
