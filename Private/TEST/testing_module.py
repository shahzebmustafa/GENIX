import subprocess
from subprocess import call
import re
#import numpy as np
import matplotlib.pyplot as plt
import os
from scipy.signal import savgol_filter
import matplotlib.patches as mpatches
import matplotlib.lines as mlines
from statistics import mean
import netifaces as ni


# Ping Test
############################################################################################################
ip_list = {'10.10.10.5':1,'10.10.10.1':2,'10.10.10.7':3,'10.10.10.3':4,'10.10.10.13':5,'10.10.10.9':6,'10.10.10.11':7,'10.10.10.15':8}
my_ip = ni.ifaddresses('ens6')[ni.AF_INET][0]['addr']

print('Starting Ping Test')
with open('pingall.sh', 'rb') as file:
    script = file.read()
rc = call(script, shell=True)


files = os.listdir("Data/Ping")
Y = {}
for f in files:
    if(f == '.gitkeep'):
        continue
    print f
    path = 'Data/Ping'
    with open(path+'/'+f,'r') as dt:
        lines = dt.readlines()
        lines = lines[6:-5]
        sample = []
        for line in lines:
            sample.append(float(re.findall(r"[-+]?\d*\.\d+|\d+", line)[-1]))
        Y[f.replace('.ping.txt','')] = sample

        X = range(0,1000)
        C = {1:'#EC7063', 2:'#A569BD', 3:'#5499C7', 4:'#F7DC6F', 5:'#52BE80', 6:'#F5B041', 7:'#566573', 8:'#5DADE2'}

        for k,v in Y.items():
            w = savgol_filter(Y[k], 79, 2)
        	plt.plot(X, w, color=C[ip_list[k]], label=ip_list[k], linewidth=2)
		plt.legend(bbox_to_anchor=(1.05, 1), borderaxespad=0., loc='upper left', prop={"size":12.5})

        plt.axis([0, 1000, 0.1, 0.6])
        plt.xlabel('Ping', fontsize=12)
        plt.ylabel('Round Trip Time (ms)', fontsize=12)
        plt.title("Node "+str(ip_list[my_ip]), fontsize=12)
        plt.savefig('Figs/ping_test.pdf',bbox_inches='tight', fontsize=12)
        # plt.show()
        break
print('Ping Test Complete!')
############################################################################################################

