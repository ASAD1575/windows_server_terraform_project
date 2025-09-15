#!/bin/bash
set -euo pipefail

INSTANCE_ID="${1}"
REGION="us-east-1"

# --- Step 1: Wait for instance to be running ---
echo "🔄 Waiting for instance $INSTANCE_ID to be running..."
while true; do
  STATE=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --region "$REGION" \
    --query 'Reservations[0].Instances[0].State.Name' \
    --output text 2>/dev/null)
  if [[ "$STATE" == "running" ]]; then
    echo "✅ Instance is running."
    break
  else
    echo "Instance state: $STATE, retrying in 10s..."
    sleep 10
  fi
done

# --- Step 2: Wait for SSM Agent to be online ---
echo "🔄 Waiting for SSM agent on $INSTANCE_ID..."
while true; do
  STATUS=$(aws ssm describe-instance-information \
    --region "$REGION" \
    --query "InstanceInformationList[?InstanceId=='$INSTANCE_ID'].PingStatus" \
    --output text 2>/dev/null)
  if [[ "$STATUS" == "Online" ]]; then
    echo "✅ SSM Agent is online."
    break
  else
    echo "SSM status: $STATUS (retrying in 60s...)"
    sleep 60
  fi
done

# --- Step 3: Wait for install_complete.flag ---
while true; do
  echo "🔄 Checking for installation flag on $INSTANCE_ID..."
  COMMAND_ID=$(aws ssm send-command \
    --instance-ids "$INSTANCE_ID" \
    --region "$REGION" \
    --document-name "AWS-RunPowerShellScript" \
    --parameters '{"commands":["if (Test-Path \"C:\\Windows\\Temp\\install_complete.flag\") { Write-Host \"exists\" } else { Write-Host \"not\" }"]}' \
    --query 'Command.CommandId' \
    --output text 2>/dev/null)
  if [[ -z "$COMMAND_ID" ]]; then
    echo "❌ Failed to send SSM command, retrying..."
    sleep 10
    continue
  fi
  sleep 5  # wait a little for the command to execute
  OUTPUT=$(aws ssm get-command-invocation \
    --command-id "$COMMAND_ID" \
    --instance-id "$INSTANCE_ID" \
    --region "$REGION" \
    --query 'StandardOutputContent' \
    --output text 2>/dev/null)
  if [[ "$OUTPUT" == *"exists"* ]]; then
    echo "✅ Flag found! User data script completed successfully."
    echo "⏳ Waiting additional 10 minutes for all configurations to be installed..."
    sleep 600
    break
  else
    echo "Flag not found yet, retrying in 30s..."
    sleep 30
  fi
done

echo "🎉 All checks passed. Instance $INSTANCE_ID is ready."
