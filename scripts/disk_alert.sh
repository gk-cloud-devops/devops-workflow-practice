#!/bin/bash
# Author - Gokul 
# Disk Monitorning script 


threshold=80
disk=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

echo "Current Disk Usage: $disk%"

if [ "$disk" -gt "$threshold" ]
then
	echo "CRITICAL: Disk usage is above $threshold%, Take immediate action !!!"
else
	echo "NICE: Disk usage is Healthy"
fi
