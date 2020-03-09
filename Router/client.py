import socket
import urllib2
import netifaces as ni
from datetime import datetime

response = urllib2.urlopen('http://www.whatismyasn.org')
html = response.read().split('\n')
my_asn = html[-6].split()[4]

neighbors = []
asn_dict ={}

with open('arp.txt','r') as f:
        for line in f.readlines():
                if('10.10.' in line):
                        ip = line.split()
                        ip = ip[1].replace('(','')
                        ip = ip.replace(')','')
                        neighbors.append(ip)

for n in neighbors:

        msgFromClient       = "ASN REQ 0"
        bytesToSend         = str.encode(msgFromClient)
        serverAddressPort   = (n, 5061) #arp
        bufferSize          = 1024
        UDPClientSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)
        UDPClientSocket.sendto(bytesToSend, serverAddressPort)
        msgFromServer = UDPClientSocket.recvfrom(bufferSize)
        
        ASN = msgFromServer[0]
        router_id = msgFromServer[1][0]
        asn_dict[router_id] = ASN
        

with open('bgpd.conf','w') as f:

        f.write('hostname test\n')
        f.write('password test\n')
        f.write('enable password test\n\n')
        f.write('router bgp '+my_asn+'\n\n') # www.whatismyASN.org
        f.write('bgp router-id '+ni.ifaddresses('eth1')[2][0]['addr']+'\n')
        for key in asn_dict:

                f.write('\n\tneighbor '+ key +' remote-as ' + asn_dict[key])


with open('complete.txt','w') as f:
        f.write('Complete!')
