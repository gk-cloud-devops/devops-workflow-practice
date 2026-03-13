Topics Learned
--------------

Automating tasks using cron

Scheduling periodic jobs

Command
-------
crontab -e

Example Job
-----------
* * * * * echo "Cron Working" >> /tmp/cron_test.txt

Cron format:
-----------

minute hour day month weekday
