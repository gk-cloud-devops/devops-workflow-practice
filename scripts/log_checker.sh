#!/bin/bash
#Author: Gokul
#Log_Checker 

errors=$(grep -c error /var/log/nginx/error.log)
echo "Total Error Count: $errors"

