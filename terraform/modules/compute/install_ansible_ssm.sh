#!/bin/bash

# 시스템 업데이트
sudo apt-get update -y
sudo apt-get upgrade -y

# SSM Agent 설치
wget https://github.com/aws/amazon-ssm-agent/releases/download/3.0.240.0/amazon-ssm-agent-3.0.240.0-1.amd64.deb
sudo dpkg -i amazon-ssm-agent-3.0.240.0-1.amd64.deb
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

#sudo apt-get install -y python3-pip
#sudo pip3 install kubernetes --break-system-packages