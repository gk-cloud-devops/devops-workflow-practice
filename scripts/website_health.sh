#!/bin/bash
#Author: Gokul
#Website_Health_Chicking 

if curl -s http://localhost > /dev/null
then 
	echo "Website Working Fine"
else
	echo "Website Not Responding"
	sudo systemctl restart nginx
	echo " "
        echo "status:"
        echo "******"
        sudo journalctl -u $service --lines 2
fi

