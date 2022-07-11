# 多节点启动

环境准备：
```shell script
ubuntu:
> apt install jq -y

centos:
> yum install jq -y
```

获取脚本:

[xchain_net.sh](https://github.com/XAbaiyangdian/xchaindoc/blob/master/source/deployment/xchain_net.sh)

可执行权限:
```shell script
> chmod +x xchain_net.sh
```

开启网络:
```shell script
> ./xchain_net.sh up
=================================================
up xchain_net
=================================================
start xchain1
886786a656ee0ac84aee3278e678d49b14d4456cb67a5ec0c1bd980238e5ed2b
start xchain2
0bd7befb7dcfbb017db2e963aa662e908dafcafebe919da833ecfd9feeb5e10b
{
  "height": "0",
  "txhash": "969B524B6EB0D2EB174B455A1123AF9E8B8B68357E65D73152E4356F94824133"
}
start xchain3
7bfb209c37270cfb6326d561daf3b9e60033a885ef16a3e131223cfc06841615
{
  "height": "0",
  "txhash": "02E476FB1D58AA80C2C4888F2A022DEFC6B8A759DC28BBD1DC03DE62CB517069"
}
start xchain4
3ae874132bbcc80e3f092b6c378c84e10f21c0dc6d1c51b18d6266fc1d43225c
{
  "height": "0",
  "txhash": "40D8529CCEF7017DFE127DC00AA1F9826C2DAB9FE3F659BD106E106507D299A0"
}
{
  "height": "0",
  "txhash": "9969B9A712AB88DD223E88659EA26C16701331DB6F156F41FD69FAA88F3ED211"
}
{
  "height": "0",
  "txhash": "6BE7CA852A9E4E01F855F928A61A2A177256F4C8BB4D80646C2E643852B24B5B"
}
{
  "height": "0",
  "txhash": "6EAA41C7F7DD8551051CEE25C7AD7C66CF4EBE45D5EBD47016AA15F54C9A79C4"
}
```
查看网络
```shell script
> docker ps
CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS                                                                                          NAMES
3ae874132bbc   xchain:latest   "/bin/sh /root/start…"   17 seconds ago   Up 16 seconds   0.0.0.0:26646->26656/tcp, :::26646->26656/tcp, 0.0.0.0:26647->26657/tcp, :::26647->26657/tcp   xchain4
7bfb209c3727   xchain:latest   "/bin/sh /root/start…"   22 seconds ago   Up 21 seconds   0.0.0.0:26636->26656/tcp, :::26636->26656/tcp, 0.0.0.0:26637->26657/tcp, :::26637->26657/tcp   xchain3
0bd7befb7dcf   xchain:latest   "/bin/sh /root/start…"   27 seconds ago   Up 26 seconds   0.0.0.0:26626->26656/tcp, :::26626->26656/tcp, 0.0.0.0:26627->26657/tcp, :::26627->26657/tcp   xchain2
886786a656ee   xchain:latest   "/bin/sh /root/start…"   37 seconds ago   Up 35 seconds   0.0.0.0:26616->26656/tcp, :::26616->26656/tcp, 0.0.0.0:26617->26657/tcp, :::26617->26657/tcp   xchain1
```

关闭网络
```shell script
> ./xchain_net.sh down
=================================================
down xchain_net
=================================================
down xchain1
xchain1
xchain1
down xchain2
xchain2
xchain2
down xchain3
xchain3
xchain3
down xchain4
xchain4
xchain4
```
