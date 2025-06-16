#!/bin/bash
chmod +x /home/ec2-user/flask-app/scripts/start_server.sh

echo "[start_server.sh] Starting script..." >> /tmp/deploy_debug.log

APP_DIR="/home/ec2-user/flask-app"

# Kill any running Flask app
pkill gunicorn || true

# Move to app directory
cd $APP_DIR || {
  echo "[start_server.sh] Failed to cd to $APP_DIR" >> /tmp/deploy_debug.log
  exit 1
}

echo "[start_server.sh] Current directory: $(pwd)" >> /tmp/deploy_debug.log
echo "[start_server.sh] Running gunicorn..." >> /tmp/deploy_debug.log

# Run app in background with gunicorn
nohup gunicorn -b 0.0.0.0:8080 app:app > app.log 2>&1 &

sleep 2

if pgrep gunicorn > /dev/null; then
  echo "[start_server.sh] Gunicorn started successfully." >> /tmp/deploy_debug.log
else
  echo "[start_server.sh] ❌ Gunicorn did not start!" >> /tmp/deploy_debug.log
  cat $APP_DIR/app.log >> /tmp/deploy_debug.log
fi