#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
  echo "Start SSM agent"
  sudo systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service

  echo "Install nginx"
  sudo apt update && sudo apt install -y nginx awscli
  export INSTANT_ID=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
  aws ec2 stop-instances --instance-ids "$INSTANT_ID" --region ap-southeast-2
