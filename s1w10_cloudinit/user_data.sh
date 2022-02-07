#!/bin/bash
yum -y update
yum -y install httpd git elinks
systemctl enable httpd
systemctl start httpd
git clone https://github.com/peadargrant/test_static_website /var/www/html
