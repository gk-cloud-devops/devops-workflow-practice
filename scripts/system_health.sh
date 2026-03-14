#!/bin/bash
#Author: Gokul
#System Health Monitor 

service=nginx

echo "====== Server Health Report ======"
echo "**********************************"
echo ""

echo "CPU Cores:"
nproc

echo ""
echo "CPU Load:"
uptime | awk -F'load average:' '{print $2}'

echo ""
echo "Memory Usage:"
free -h | awk 'NR==2 {print $3,"/"$2}'| tr -d 'i'

echo ""
echo "Disk Usage:"
df -h / |awk 'NR==2 {print $5}'

echo ""
echo "$service Status:"
systemctl is-active $service

echo ""
echo "Website Check:"
curl -s http://localhost > /dev/null

if [ $? -eq 0 ]
then
	echo "Website is UP"
else
	echo "Website is DOWN"
fi
