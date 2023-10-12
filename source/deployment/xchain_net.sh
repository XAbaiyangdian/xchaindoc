#!/bin/bash

image=xchain:latest
nodeNum=4
isNumber(){
  if [ "$1" -gt 0 ] 2>/dev/null ;then
    echo 1
  else
    echo 0
  fi
}
waitNodeStart(){
	height=$(docker exec $1 xccli q block 2>/dev/null| jq -r .block.header.height)
	isnum=$(isNumber $height)
	while [ "$isnum" -eq "0" ]
        do
		sleep 0.2
		height=$(docker exec $1 xccli q block 2>/dev/null| jq -r .block.header.height)
                isnum=$(isNumber $height)
        done
}


up(){
  echo =================================================
  echo up xchain_net
  echo =================================================
  echo start xchain1
  docker run -d --name xchain1 \
    -v /data/node1/.xcd:/root/.xcd \
    -v /data/node1/.xccli:/root/.xccli \
    -p 26616:26656 \
    -p 26617:26657 \
    ${image}

  waitNodeStart xchain1

  for ((i=2; i<=$nodeNum; i++)){
	  nodeName=xchain$i
          baseDir=/data/node$i
          nodePort=266${i}6
          rpcPort=266${i}7
          echo start $nodeName
          mkdir -p $baseDir/.xcd/config/
          cp /data/node1/.xcd/config/genesis.json $baseDir/.xcd/config/
          docker run -d --name $nodeName \
            -v $baseDir/.xcd:/root/.xcd \
            -v $baseDir/.xccli:/root/.xccli \
            -p $nodePort:26656 \
            -p $rpcPort:26657 \
            -e NODEORDER=follow \
            --link xchain1:xchain1 \
            $image --p2p.persistent_peers=$(docker exec xchain1 xcd tendermint show-node-id)@xchain1:26656

	  sleep 2
          docker exec xchain1 xccli tx member addAccount $(docker exec $nodeName xcd tendermint show-node-address) org1 peer --from org1Admin -y
          docker exec xchain1 xccli tx poa createValidator $(docker exec $nodeName xcd tendermint show-validator) 100 --from jack -y -b block --moniker=test --effective-time $(($(date +%s) + 60))  --vote-end-time $(($(date +%s) + 60)) >/dev/null 2>&1
  }
  for ((i=0; i<${nodeNum}-1; i++)){
	  docker exec xchain1 xccli tx gov vote $(docker exec xchain1 xccli q gov proposals | jq -r .[${i}].proposal_id)  0 --from jack -y
  }
}

down(){
  echo =================================================
  echo down xchain_net
  echo =================================================
  
  for ((i=1; i<=${nodeNum}; i++)){
	  nodeName=xchain$i
	  echo down $nodeName
	  docker stop $nodeName
          docker rm $nodeName

	  baseDir=/data/node$i
          rm -rf $baseDir
  }
}
if [ "$1" = "up" ];then
     up
elif [ "$1" = "down" ];then
     down
else
     echo "Usage $0 [up|down]"
fi

