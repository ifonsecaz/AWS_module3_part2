#!/bin/bash
chmod +x /home/ec2-user/flask-app/scripts/start_server.sh

APP_DIR="/home/ec2-user/flask-app"

# Kill any running Flask app
pkill gunicorn || true

# Move to app directory
cd $APP_DIR

# Run app in background with gunicorn
sudo nohup gunicorn -b 0.0.0.0:80 app:app > app.log 2>&1 &