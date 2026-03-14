#!/bin/bash
# Author - Gokul 
# Service Monitoring 

service=nginx
server=$(hostname)
echo "$server"
status=$(systemctl is-active $service)
if [ "$status" != "active" ]
then
	echo "Oops $service is down. Restarting..."
	sudo systemctl restart $service
	echo " "
	echo "status:"
	echo "******"
	sudo journalctl -u $service --lines 2
else
	echo "Sounds good $service is running fine"
fi
