import socket
import netifaces as ni
import sys
import subprocess
import time

# ip_list = ['10.10.10.5','10.10.10.1','10.10.10.7','10.10.10.3','10.10.10.13','10.10.10.9','10.10.10.11','10.10.10.15']
ip_list = ['10.10.7.1', '10.10.17.2', '10.10.8.1', '10.10.6.2', '10.10.11.1', '10.10.9.1', '10.10.10.2', '10.10.12.2']

ni.ifaddresses('ens6')
my_ip = ni.ifaddresses('ens6')[ni.AF_INET][0]['addr']

my_ip_index = ip_list.index(my_ip)
neighbor = (my_ip_index+1)%10


rc = subprocess.call("/usr/local/start_test.sh")
time.sleep(10)

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect((ip_list[neighbor], 6869))
client.send("Start Test<br>")
client.close()