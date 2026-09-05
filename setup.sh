#!/usr/bin/env bash

# ==============================================================================
# Broadcast Buddy Mailserver - Account & DKIM Management Utility
# ==============================================================================

set -e

ACTION=$1
EMAIL=$2
PASSWORD=$3

if [ "$ACTION" == "add" ]; then
  if [ -z "$EMAIL" ] || [ -z "$PASSWORD" ]; then
    echo "Usage: ./setup.sh add user@broadcastbuddy.app <password>"
    exit 1
  fi
  echo "Adding email account: $EMAIL"
  sudo docker exec -ti mailserver setup email add "$EMAIL" "$PASSWORD"
  echo "✅ Account $EMAIL created successfully."

elif [ "$ACTION" == "list" ]; then
  echo "Listing configured email accounts:"
  sudo docker exec -ti mailserver setup email list

elif [ "$ACTION" == "dkim" ]; then
  echo "Generating DKIM keys for broadcastbuddy.app..."
  sudo docker exec -ti mailserver setup config dkim
  echo ""
  echo "📋 Copy this TXT record to your DNS manager for DKIM verification:"
  cat ./mail-config/opendkim/keys/broadcastbuddy.app/mail.txt 2>/dev/null || echo "Check ./mail-config/opendkim/keys/broadcastbuddy.app/mail.txt"

elif [ "$ACTION" == "logs" ]; then
  sudo docker logs -f mailserver

else
  echo "Broadcast Buddy Mailserver Helper"
  echo "================================="
  echo "Commands:"
  echo "  ./setup.sh add <email> <password>  - Create a new mailbox"
  echo "  ./setup.sh list                    - List all mailboxes"
  echo "  ./setup.sh dkim                    - Generate & view DKIM DNS keys"
  echo "  ./setup.sh logs                    - Tail live mail server logs"
fi
