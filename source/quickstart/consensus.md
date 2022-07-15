# 网络共识


共识 POA+PBFT 和 POA+RAFT

## POA+PBFT

**交易流程图**


  ![image](https://github.com/XAbaiyangdian/xchaindoc/blob/master/source/quickstart/picture/%E6%B5%81%E7%A8%8B%E5%9B%BE1.png)
  ![image](https://github.com/XAbaiyangdian/xchaindoc/blob/master/source/quickstart/picture/%E6%B5%81%E7%A8%8B%E5%9B%BE2.png)
  
  **validator**
  
  validator是所有参与共识验证的节点， 每个validator可以拥有不同的权重。

  出块收集validator的签名，也是按权重算的，总共权重大于三分之二的节点就可以出块

>创世区块至少创建一个validator  
>validator的更新  会在每个区块执行后endBlock函数 去更新共识层的validator    (可新增、可删除、可修改权重)
>
>出块validator如果不在线或者超时  按照固定顺序的下一位

**Mempool**

每个节点维护自己的menpool,当交易进入自己的menpool就会广播同步给其他节点。

**交易的处理逻辑**

![image](https://github.com/XAbaiyangdian/xchaindoc/blob/master/source/quickstart/picture/%E4%BA%A4%E6%98%93%E7%9A%84%E5%A4%84%E7%90%86%E9%80%BB%E8%BE%91.png)

>区块的执行逻辑
>
>beginBlock 
>
>deliverTxs 
>
>  ...
>  
>endBlock 
>
>commit

**共识逻辑**

![image](https://github.com/XAbaiyangdian/xchaindoc/blob/master/source/quickstart/picture/%E5%85%B1%E8%AF%86%E9%80%BB%E8%BE%91.png)

## POA+RAFT

**交易流程**
![image](https://github.com/XAbaiyangdian/xchaindoc/blob/master/source/quickstart/picture/%E6%B5%81%E7%A8%8B%E5%9B%BE3.png)

**如何选出leader(负责出块的节点）？**

没有leader时:

每个validator发起选举然后投票给自己，并向集群其他服务器验证人发送投票请求。有超过1/2的验证人返回同一个leader后确认

当leader超时或不在线时，重新选举leader

