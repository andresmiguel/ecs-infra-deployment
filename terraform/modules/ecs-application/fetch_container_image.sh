#!/bin/bash

# Read input JSON from stdin
read input_json

# Parse the input JSON to get the task definition name, AWS region, and container name
task_definition=$(echo "$input_json" | jq -r '.task_definition')
aws_region=$(echo "$input_json" | jq -r '.region')
container_name=$(echo "$input_json" | jq -r '.container_name')

# Check if the task definition exists
# First list all task definitions and then check if the specified task definition exists
# This approach uses two steps to distinguish between the case where the task definition does not exist
# and the case where an error occurred with the AWS command.
existing_task_definitions=$(aws ecs list-task-definitions --region "$aws_region" 2>&1)

# If the aws ecs list-task-definitions command failed, print an error message and exit with a non-zero status
if [ $? -ne 0 ]; then
  echo "Failed to list task definitions" >&2
  exit 1
fi

if ! echo "$existing_task_definitions" | grep -q "task-definition/$task_definition:"; then
  container_image=""
else
# Fetch the image of the specified container directly using --query
  container_image=$(aws ecs describe-task-definition \
    --task-definition "$task_definition" \
    --region "$aws_region" \
    --query "taskDefinition.containerDefinitions[?name=='$container_name'].image" \
    --output text 2>&1)

    # If the aws ecs describe-task-definition command failed, print an error message and exit
    if [ $? -ne 0 ]; then
      echo "Failed to fetch container image" >&2
      exit 1
    fi
fi



# If the container image is not found, set it to an empty string
if [ -z "$container_image" ] || [ "$container_image" == "None" ]; then
  container_image=""
fi

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
jq -n --arg container_image "$container_image" '{"container_image":$container_image}'
