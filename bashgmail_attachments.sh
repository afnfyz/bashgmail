: "
--------------------
Author: Afnan
Date: 03/07/2023
Description:
Allows you to send bulk emails using Gmail's api.
Prior to using this script you  need to set up a project on Google's 
cloud console turn on gmail's api and then provision a refresh token.
--------------------
"
# Check if jq is installed
if ! which jq > /dev/null; 
        then
  echo ""
  echo "Error: jq not installed."
  echo "Please install and try again."
  echo ""
  exit
fi

# Check for OS type
if [[ "$OSTYPE" == "darwin"* ]]; then
  BASE64_COMMAND="base64 -b 0"
else
  BASE64_COMMAND="base64 -w 0"
fi


: "
# If you want to set the destination email addresses automatically from a file
# you can modify this loop in accordance to your file
i=0
while IFS=, read -r name num mail; do
  name_array[i++]=$name
  number_array[i++]=$num
  email_array[i++]=$mail
done < ~/Downloads/test.csv
"

# If you want to set destination email addresses manually add them here 
# separated with a space.
#email_array=()

# Set the email address for the sender
FROM_EMAIL=""

# Set the email content
EMAIL_CONTENT=$(cat ./email_body.txt)

# Set the email subject
SUBJECT="Multiple email test"

# Set the path of the attachment file
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
ATTACHMENT_PATH="${SCRIPT_DIR}/attachment.pdf"

for email in ${email_array[@]}
do

# Base64 encode the attachment file
ATTACHMENT_ENCODED=$(${BASE64_COMMAND} < "${ATTACHMENT_PATH}")

# Construct the email message with attachment

# Content-Type: multipart/mixed; boundary="mixed-boundary"
# Content-Disposition: attachment; filename="attachment.pdf"
# Email content can also be in HTML format 
# Content-Type: text/html; charset=UTF-8

EMAIL=$(cat <<EOF
From: ${FROM_EMAIL}
To: ${email}
Subject: ${SUBJECT}
Content-Type: multipart/mixed; boundary="mixed-boundary"

--mixed-boundary
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

${EMAIL_CONTENT}

--mixed-boundary
Content-Type: application/pdf
Content-Disposition: attachment; filename="attachment.pdf"
Content-Transfer-Encoding: base64

${ATTACHMENT_ENCODED}

--mixed-boundary--
EOF
)

# Base64 encode the email message as URL-safe
EMAIL_ENCODED=$(echo -n "${EMAIL}" | $BASE64_COMMAND)

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

done 
