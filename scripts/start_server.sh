#!/bin/bash

APP_DIR="/home/ec2-user/flask-app"

# Kill any running Flask app
pkill gunicorn || true

# Move to app directory
cd $APP_DIR

# Run app in background with gunicorn
nohup gunicorn -b 0.0.0.0:8080 app:app > app.log 2>&1 &