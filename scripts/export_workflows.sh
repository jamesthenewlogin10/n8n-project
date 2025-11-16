#!/bin/bash

# Export all n8n workflows to a Git-friendly folder
echo "Exporting n8n workflows..."

docker compose exec n8n n8n export:workflow --all --output=/data/workflows

echo "Copying workflows from container to host..."
cp -r data/workflows/* workflows/

echo "Done! Workflows exported to ./workflows/"
