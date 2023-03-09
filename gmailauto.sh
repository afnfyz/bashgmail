#!/bin/bash

: "
--------------------
Author: Afnan
Date: 03/07/2023

Description: 

Allows you to send an email using Gmail's api.
Prior to using this script you  need to set up a project on Google's 
cloud console turn on gmail's api and then provision a refresh token. 

Use this script for only one destination email address.
--------------------
"

if ! which jq > /dev/null; 
        then
  echo ""
  echo "Error: jq not installed."
  echo "Please install and try again"
  echo ""
  exit
fi


# Set the email content
EMAIL_CONTENT=$(cat ./email_body.txt)

# Set the email address for the recipient
TO_EMAIL=""

# Set the email address for the sender
FROM_EMAIL=""

# Set the email subject
SUBJECT="Automated test"
# Content-Type: text/html; charset=UTF-8 
# Construct the email message
EMAIL=$(cat <<EOF
From: ${FROM_EMAIL}
To: ${TO_EMAIL}
Subject: ${SUBJECT}
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

${EMAIL_CONTENT}
EOF
)

# Base64 encode the email message as URL-safe
EMAIL_ENCODED=$(echo -n "${EMAIL}" | base64 -b 0)

# Set the permanent refresh token and client ID/secret
REFRESH_TOKEN=""
CLIENT_ID=""
CLIENT_SECRET=""

# Get a new access token with the refresh token
ACCESS_TOKEN=$(curl -s \
  --request POST \
  --data "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&refresh_token=$REFRESH_TOKEN&grant_type=refresh_token" \
  https://oauth2.googleapis.com/token | jq -r .access_token)

# Send the email using the Gmail API
curl \
  --request POST \
  --url 'https://gmail.googleapis.com/gmail/v1/users/me/messages/send' \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Content-Type: application/json" \
  --data "{\"raw\":\"$EMAIL_ENCODED\"}"

