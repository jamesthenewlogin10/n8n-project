#!/bin/bash
set -e

CONTAINER="n8n-docker-n8n-1"
EXPORT_PATH="/home/node/.n8n"
TMP_PATH="/tmp/workflows"
HOST_OUTPUT_DIR="./workflows"

echo "Exporting n8n workflows..."

docker exec $CONTAINER n8n export:workflow --all --output=$TMP_PATH

echo "Checking export result in container..."
TYPE=$(docker exec $CONTAINER sh -c "if [ -d $TMP_PATH ]; then echo DIR; elif [ -f $TMP_PATH ]; then echo FILE; else echo NONE; fi")

mkdir -p $HOST_OUTPUT_DIR

if [ "$TYPE" = "DIR" ]; then
    echo "Detected directory export."
    docker cp $CONTAINER:$TMP_PATH/. $HOST_OUTPUT_DIR/
elif [ "$TYPE" = "FILE" ]; then
    echo "Detected single-file export."
    docker cp $CONTAINER:$TMP_PATH $HOST_OUTPUT_DIR/workflows.json
else
    echo "Error: No workflows exported!"
    exit 1
fi

echo "Done! Workflows exported to $HOST_OUTPUT_DIR/"

