#!/bin/bash

iperf3 -s -p 5005 &

iperf3 -s -p 5001 &

iperf3 -s -p 5013 &

iperf3 -s -p 5003 &

iperf3 -s -p 5011 &

iperf3 -s -p 5015 &

iperf3 -s -p 5007 &

iperf3 -s -p 5009 &


python /usr/local/tester.py &
