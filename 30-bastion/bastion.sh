#!/bin/bash

# We are creating 50GB root disk, but only 20GB is partitioned
# Remaining 30GB we need to extend using below commands
growpart /dev/nvme0n1 4
lvextend -r -L +30G /dev/mapper/RootVG-homeVol
xfs_growfs /home

yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform

cd /home/ec2-user
git clone https://github.com/joindevops-1/roboshop-infra-dev-88s.git
chown ec2-user:ec2-user -R roboshop-infra-dev-88s
cd roboshop-infra-dev-88s/40-databases
terraform init
terraform apply -auto-approve