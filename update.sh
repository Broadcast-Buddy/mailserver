#!/usr/bin/env bash

# ==============================================================================
# Broadcast Buddy - Mailserver Pull & Update Script
# ==============================================================================

set -e

echo "📦 Pulling latest docker-mailserver image..."
sudo docker-compose pull

echo "🚀 Restarting mailserver container..."
sudo docker-compose up -d --remove-orphans

echo "🧹 Pruning old image layers..."
sudo docker image prune -f || true

echo "✨ Mailserver updated and running successfully at mail.broadcastbuddy.app!"
