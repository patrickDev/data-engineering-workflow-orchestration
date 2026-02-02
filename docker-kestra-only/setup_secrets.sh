#!/bin/bash

# 1. Get the absolute path of the directory where THIS script is located
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 2. Define the path to your JSON key
# This says: "Go to the script folder, then into the secrets folder"
JSON_FILE="$BASE_DIR/secrets/gcpkey.json"

# 3. Check if the file actually exists before trying to encode it
if [ ! -f "$JSON_FILE" ]; then
    echo "❌ ERROR: File not found at $JSON_FILE"
    echo "Current directory is: $(pwd)"
    exit 1
fi

# 4. Generate the mandatory 32-char encryption key
ENCRYPTION_KEY=$(openssl rand -base64 32 | head -c 32)

# 5. Encode the JSON (using the absolute path we just found)
GCP_BASE64=$(cat "$JSON_FILE" | base64 | tr -d '\n')

# 6. Write to the file
echo "KESTRA_ENCRYPTION_KEY=$ENCRYPTION_KEY" > "$BASE_DIR/.env_encoded"
echo "SECRET_GCP_KEY=$GCP_BASE64" >> "$BASE_DIR/.env_encoded"

echo "✅ Success! .env_encoded is now full."
echo "Verified: $(grep -c "SECRET_GCP_KEY=.." "$BASE_DIR/.env_encoded") secret(s) found."