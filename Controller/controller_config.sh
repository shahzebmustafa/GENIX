#!/bin/bash

git clone git://github.com/osrg/ryu.git
cd ryu
pip install .

wget https://raw.githubusercontent.com/osrg/ryu/master/ryu/app/simple_switch.py
ryu-manager simple_switch.py