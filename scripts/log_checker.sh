#!/bin/bash
#Author: Gokul
#Log_Checker 
services=nginx
errors=$(grep -c error /var/log/$services/error.log)
echo "Total Error Count: $errors"

