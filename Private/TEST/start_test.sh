#!/bin/bash
echo "Started Testing"
ip_list=('10.10.10.5' '10.10.10.1' '10.10.10.13' '10.10.10.3' '10.10.10.11' '10.10.10.15' '10.10.10.7' '10.10.10.9')
my_ip=$(ifconfig ens6 | grep 'inet addr:' | cut -d: -f2| cut -d' ' -f1)
port="$(cut -d'.' -f4 <<< $my_ip)"
port=$((5000+$port))
l=${#ip_list[@]}

for ((i = 0 ; i < l ; i++)); do
        if [ ${ip_list[$i]} != $my_ip ]
        then
                iperf3 -c ${ip_list[$i]} -f M -t 100 -i 10 -p $port > ${ip_list[$i]}.txt &
        fi
done