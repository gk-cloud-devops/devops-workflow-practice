## If Server Is Slow:

For check system overview in single screen:


I'll use "glances" for analyzation 


To find running CPU: 


I'll use "top" to identify which process is consuming more CPU usage 


To check the memory status:


I'll use "free -h" to identify the used,free and avilable space 


To check disk:


I'll use "df -h" to anayze the disk usage


Then to check inode usage:


I'll use "df -i" to identify the usage status 


---

## IF Service Not Starting

To check the service status:


systemctl status "<service_name>" like "systemctl status nginx" and ensure it's active status


To check the logs:


I'll use "journalctl -u nginx" to check the recent logs


Test configuration:


Then I'll use "nginx -t" to test the configuration status, if there is any error I'll fix it 


Restart service:


Then i'll use "systemctl restart nginx" to restart the service.


---

## Website Not Loading

To check port:


I'll use "ss -tulnp | grep 80" to check to ensure the port listening in 80.


To check web response:


I'll use "curl http://localhost or website ip" to ensure it's working in local.


To check firewall:


I'll use "sudo ufw status" for the analyzation" for the analyzation  
