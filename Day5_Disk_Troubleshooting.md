Topics Learned
--------------

Disk usage monitoring

Inode exhaustion

Finding large directories

Safe log cleanup

Commands Practiced
------------------

df -h
df -i
ncdu /
du -sh *

Concepts
-------

df -h → disk usage

df -i → inode usage

Log Cleanup
-----------

truncate -s 0 logfile

Used to clear log without deleting file.
