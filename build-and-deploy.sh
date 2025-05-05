#!/bin/bash

echo "=========================================="
echo "Mondrian Docker Build and Deploy"
echo "=========================================="

# Check for Docker and Docker Compose
if ! command -v docker &> /dev/null || ! command -v docker-compose &> /dev/null; then
    echo "Error: Docker and Docker Compose are required but not installed."
    exit 1
fi

# Create directories if they don't exist
mkdir -p mondrian-config data mysql-init
echo "✓ Created directory structure"

# Make the setup script executable
chmod +x setup-mondrian.sh
echo "✓ Made setup script executable"

# Download FoodMart sample database SQL script
echo "Downloading FoodMart sample database..."
curl -s -o mysql-init/foodmart.sql https://raw.githubusercontent.com/pentaho/mondrian/master/demo/mysql/foodmart_mysql.sql
if [ $? -eq 0 ]; then
    echo "✓ Downloaded FoodMart database script"
else
    echo "⚠ Failed to download FoodMart database script"
    echo "  You can manually download it from the Mondrian GitHub repository"
fi

# Build and start containers
echo "Building containers (this may take several minutes)..."
docker-compose up -d --build

# Display status
echo "=========================================="
echo "Build process initiated!"
echo "=========================================="
echo "To monitor the build progress:"
echo "docker-compose logs -f mondrian"
echo ""
echo "Once complete, access Mondrian at:"
echo "http://localhost:8080/mondrian"
echo ""
echo "XMLA endpoint will be available at:"
echo "http://localhost:8080/mondrian/xmla"
echo "=========================================="