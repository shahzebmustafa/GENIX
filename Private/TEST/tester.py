import logging
logging.getLogger("scapy.runtime").setLevel(logging.ERROR)
from scapy.all import *
import subprocess
import sys

def handle_packet(packet):
	try:
		if packet.pdst == "10.10.10.250":
			print("Recieved Test Start Command")
			rc = subprocess.call("/usr/local/start_test.sh")
			sys.exit()
	except:
		return


sniff(iface="ens6",prn=handle_packet,store=0)