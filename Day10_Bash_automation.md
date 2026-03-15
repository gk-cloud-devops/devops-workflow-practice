Topics Learned
--------------

Automating system checks

Using variables in scripts

Example Script
--------------

#!/bin/bash

server=$(hostname)
disk=$(df -h / | awk 'NR==2 {print $5}')

echo "Server: $server"
echo "Disk usage: $disk"

Purpose
-------

Automate system monitoring and generate useful information for administrators.
