#!/bin/bash

export ELB_NAME=$1


 cat << EOF > ~/.pynsotrc
[pynsot]
url = http://$ELB_NAME:8990/api
auth_header = X-NSoT-Email
default_domain = localhost
email = jeremiah.gearheart@pearson.com
default_site = 1
auth_method = auth_header

EOF


sudo nsot sites list >> verify










