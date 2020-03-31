#!/bin/bash

ip_list=('10.10.10.5' '10.10.10.1' '10.10.10.13' '10.10.10.3' '10.10.10.11' '10.10.10.15' '10.10.10.7' '10.10.10.9')
my_ip=$(ifconfig ens6 | grep 'inet addr:' | cut -d: -f2| cut -d' ' -f1)
l=${#ip_list[@]}

for ((i = 0 ; i < l ; i++)); do
        if [ ${ip_list[$i]} != $my_ip ]
        then
        		# echo "ping ${ip_list[$i]} -c 1000 > ${ip_list[$i]}.ping.txt &"
                ping ${ip_list[$i]} -c 1005 > Data/Ping/${ip_list[$i]}.ping.txt &
        fi
done

ping $my_ip -c 1100