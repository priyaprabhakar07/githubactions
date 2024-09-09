#!/bin/bash


# Number of seconds to wait between checks
WAIT_INTERVAL=5

# Maximum number of retries
MAX_RETRIES=3

# Counter for retries
RETRY_COUNT=0

# Function to check the status of the service
check_status( ) {
  http_status=$(curl --write-out "%{http_code}" --silent --output /dev/null "$SERVICE_URL")
  
  if [ "$http_status" -eq 200 ]; then
    echo "Service is up and running (HTTP Status: $http_status)."
    return 0
  else
    echo "Service is not up yet (HTTP Status: $http_status)."
    return 1
  fi
}

# Wait for the foo service to be available
while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  SERVICE_URL="http://foo.localhost:8080"
  if check_status; then
    echo "Foo Service Sanity completed successfully"
  else
    echo "Retrying Foo Service in $WAIT_INTERVAL seconds..."
    sleep $WAIT_INTERVAL
    RETRY_COUNT=$((RETRY_COUNT + 1))
  fi
done

RETRY_COUNT=0

# Wait for the bar service to be available
while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  SERVICE_URL="http://bar.localhost:8081"
  if check_status; then
    echo "Bar Service Sanity completed successfully"
    exit 0
  else
    echo "Retrying Bar service in $WAIT_INTERVAL seconds..."
    sleep $WAIT_INTERVAL
    RETRY_COUNT=$((RETRY_COUNT + 1))
  fi
done

echo "Service did not become available within the maximum number of retries."
exit 1
