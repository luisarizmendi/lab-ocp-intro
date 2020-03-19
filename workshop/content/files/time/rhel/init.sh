#!/bin/sh
while true; do echo -e "HTTP/1.1 200 OK\r\n\r\n$(date)\r\nHost: $(tail -1 /etc/hosts| awk '{print $2}')" | nc -ll -p 8080; done
