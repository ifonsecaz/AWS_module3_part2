#!/bin/bash

cd /home/ec2-user/flask-app

# Install Python and pip if needed
sudo yum update -y
sudo yum install python3-pip -y

# Optional: Create virtualenv 
# python3 -m venv venv
# source venv/bin/activate

# Install dependencies
pip3 install -r requirements.txt