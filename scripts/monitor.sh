#!/bin/bash

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
fi

# Function to send notifications
send_notification() {
    local message="$1"
    
    # Slack notification
    if [ ! -z "$SLACK_WEBHOOK_URL" ]; then
        curl -X POST -H 'Content-type: application/json' \
            --data "{\"text\":\"${message}\"}" \
            "${SLACK_WEBHOOK_URL}"
    fi
    
    # Discord notification
    if [ ! -z "$DISCORD_WEBHOOK_URL" ]; then
        curl -X POST -H 'Content-type: application/json' \
            --data "{\"content\":\"${message}\"}" \
            "${DISCORD_WEBHOOK_URL}"
    fi
}

# Check container health
check_containers() {
    unhealthy_containers=$(docker compose ps | grep -i "unhealthy")
    if [ ! -z "$unhealthy_containers" ]; then
        send_notification "⚠️ Warning: Unhealthy containers detected:\n${unhealthy_containers}"
    fi
}

# Check disk space
check_disk_space() {
    disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    if [ "$disk_usage" -gt 85 ]; then
        send_notification "⚠️ Warning: Disk usage is at ${disk_usage}%"
    fi
}

# Main monitoring loop
while true; do
    check_containers
    check_disk_space
    sleep 300  # Check every 5 minutes
done 