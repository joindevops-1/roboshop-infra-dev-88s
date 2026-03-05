#!/bin/bash

component=$1
environment=$2
dnf install ansible -y

cd /home/ec2-user

git clone https://github.com/joindevops-1/robshop-ansible-roles-88s.git

cd robshop-ansible-roles-88s
git pull
ansible-playbook -e component=$component -e env=$environment roboshop.yaml