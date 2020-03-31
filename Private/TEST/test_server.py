import socket
import netifaces as ni
import time
import subprocess
import sys

ip_list = ['10.10.10.5','10.10.10.1','10.10.10.7','10.10.10.3','10.10.10.13','10.10.10.9','10.10.10.11','10.10.10.15']

ni.ifaddresses('ens6')
my_ip = ni.ifaddresses('ens6')[ni.AF_INET][0]['addr']

my_ip_index = ip_list.index(my_ip)
neighbor = (my_ip_index+1)%8

serv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
serv.bind((my_ip, 6869))
serv.listen(5)

try:
	while True:
	    conn, addr = serv.accept()
	    from_client = ''
	    while True:
	        data = conn.recv(4096)
	        if not data: break
	        from_client += data
	        print("Recieved Test Start Command")
	        rc = subprocess.call("/usr/local/start_test.sh")
	        time.sleep(10)
	        client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
			client.connect((ip_list[neighbor], 6869))
			client.send("Start Test<br>")
	    conn.close()
	    serv.close()
	    sys.exit()
except:
	serv.close()