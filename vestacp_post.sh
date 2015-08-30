#!/bin/bash
# The line below helped me to prevent mysql server from stoping by itselfe often.
# execute it in your server
service mysql stop && service mysql start && dpkg-reconfigure mysql-server-5.5
