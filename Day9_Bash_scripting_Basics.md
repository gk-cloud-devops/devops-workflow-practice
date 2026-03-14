Topics Learned
--------------

Bash scripts
Variables

Command output capture
----------------------

Script Start

#!/bin/bash

Variables

name="gokul"
echo $name

Capture Command Output
----------------------

disk=$(df -h / | awk 'NR==2 {print $5}')
Used in automation scripts.
