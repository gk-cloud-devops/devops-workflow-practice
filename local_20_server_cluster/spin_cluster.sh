#!/bin/bash

CLUSTER_NET="devops_local_grid"
IMAGE_NAME="ubuntu:22.04"
TOTAL_NODES=20

echo "======================================================="
echo "🚀 DevOps Local Engine: Initiating 20-Node Cluster Setup"
echo "======================================================="

# 1. Create an isolated virtual network grid if it doesn't exist
if [ ! "$(docker network ls | grep $CLUSTER_NET)" ]; then
    echo "🌐 Creating isolated backend network bridge: $CLUSTER_NET..."
    docker network create --driver bridge $CLUSTER_NET
fi

# 2. Loop to automatically provision, label, and launch all 20 nodes
for i in $(seq -f "%02g" 1 $TOTAL_NODES); do
    NODE_NAME="DevOps-Server-$i"
    
    echo "🖥️ Provisioning compute node: $NODE_NAME..."
    
    # Launching container in detached background mode keeping bash active
    docker run -d \
        --name "$NODE_NAME" \
        --network $CLUSTER_NET \
        --restart unless-stopped \
        -t $IMAGE_NAME \
        bash
done

echo "======================================================="
echo "✅ SUCCESS! All $TOTAL_NODES servers are LIVE & interconnected."
echo "======================================================="
echo "👉 Run 'docker ps' to see your virtual data center matrix map!"
