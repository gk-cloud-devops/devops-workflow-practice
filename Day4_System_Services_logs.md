Topics Learned
-------------

Managing services using systemd

Reading system logs

Debugging service failures

Commands Practiced
------------------

systemctl status nginx
systemctl restart nginx
systemctl list-units --type=service

Logs
----

journalctl -u nginx
journalctl -u nginx -f

Configuration Test
-----------------

nginx -t

Used to verify nginx configuration before restart.
