#!/bin/sh

sudo rm /local/GENI/bgpd.conf

python /local/GENI/client.py

sudo cp /local/GENI/bgpd.conf /etc/frr