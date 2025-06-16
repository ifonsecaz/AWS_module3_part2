#!/bin/bash

echo "[permissions.sh] Running as: $(whoami)" >> /tmp/deploy_debug.log
ls -l /home/ec2-user/flask-app/scripts >> /tmp/deploy_debug.log

chmod +x /home/ec2-user/flask-app/scripts/*.sh
echo "[permissions.sh] chmod done" >> /tmp/deploy_debug.log

ls -l /home/ec2-user/flask-app/scripts >> /tmp/deploy_debug.log