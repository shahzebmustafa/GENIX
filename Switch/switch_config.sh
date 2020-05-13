#!/bin/bash

sudo apt update -y
sudo apt install -y openvswitch-switch

sudo ovs-vsctl add-br br0

iface_list=()
for iface in $(ifconfig | cut -d ' ' -f1| tr ':' '\n' | awk NF)
do
        iface_list+=("$iface")
done

l=${#iface_list[@]}
for ((i = 1 ; i < l-1 ; i++)); do
	sudo ifconfig ${iface_list[$i]} 0
done

l=${#iface_list[@]}
for ((i = 1 ; i < l-1 ; i++)); do
	sudo  ovs-vsctl add-port br0 ${iface_list[$i]}
done

sudo ovs-vsctl set-controller br0 tcp:72.36.65.65:6653
sudo ovs-vsctl set-fail-mode br0 standalone
