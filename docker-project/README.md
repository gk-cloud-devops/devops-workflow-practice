# Docker Nginx Project

This project demonstrates building a custom Docker image using nginx.

Steps performed:
---------------

1. Created custom index.html
2. Built Docker image using Dockerfile
3. Ran container using docker run
4. Exposed port 8085

Commands used:
-------------

docker build -t gokul-nginx .
docker run -d -p 8085:80 gokul-nginx
