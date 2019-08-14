#!/bin/bash -xe
sudo echo "${message}" >> /etc/message.txt

sudo yum update –y >> /etc/instal_logs.txt
sudo yum install java-1.8.0-openjdk-devel.x86_64 -y >> /etc/instal_logs.txt
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat/jenkins.repo >> /etc/instal_logs.txt
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key >> /etc/instal_logs.txt
sudo yum install jenkins -y >> /etc/instal_logs.txt
sudo service jenkins start >> /etc/instal_logs.txt
sudo chkconfig jenkins on >> /etc/instal_logs.txt
sudo cat /var/lib/jenkins/secrets/initialAdminPassword >> /etc/instal_logs.txt