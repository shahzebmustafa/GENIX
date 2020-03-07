import socket
import netifaces as ni
import urllib2
import threading
import time
import subprocess

response = urllib2.urlopen('http://www.whatismyasn.org') 
html = response.read().split('\n') 
my_asn = html[-6].split()[4] 


def updateBGP():
    while True:
        #run client script
        subprocess.call("sudo bash /local/GENI/runclient.sh", shell=True)
        time.sleep(10)

if __name__ == "__main__": 

    t1 = threading.Thread(target=updateBGP) 
    t1.start()

    HOST = '0.0.0.0'
    PORT = 5061
    BUFFER  = 1024

    msgFromServer       = my_asn
    bytesToSend         = str.encode(msgFromServer)
    UDPServerSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)
    UDPServerSocket.bind((HOST, PORT))
#    print("UDP server up and listening")
    try:
        while(True):
#           print(1)
            bytesAddressPair = UDPServerSocket.recvfrom(BUFFER)
 #           print(2)
            message = bytesAddressPair[0]
 #           print(3)
            address = bytesAddressPair[1]
            clientMsg = "Message from Client:{}".format(message)
            clientIP  = "Client IP Address:{}".format(address)
#            print(clientMsg)
#            print(clientIP)

            UDPServerSocket.sendto(bytesToSend, address)

#        print("Server Staterd")
    except:
        UDPServerSocket.close()
        print('Program Exited')