#!/bin/bash
# Multi-Crop Decision-Support System (DSS) Database Setup Script
# This script automates the database creation and data loading process

echo "=========================================="
echo "Crops_MET Database Setup"
echo "=========================================="
echo ""

# Automatically detect the project directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_PATH="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Detected project path: $PROJECT_PATH"
echo ""

# Verify required directories exist
if [ ! -d "$PROJECT_PATH/sql_scripts" ]; then
    echo "ERROR: sql_scripts directory not found in $PROJECT_PATH"
    exit 1
fi

if [ ! -d "$PROJECT_PATH/processed_data" ]; then
    echo "ERROR: processed_data directory not found in $PROJECT_PATH"
    exit 1
fi

echo "Project structure verified ✓"
echo ""

# Get MySQL credentials
echo "Enter MySQL username (default: root):"
read -r DB_USER
DB_USER=${DB_USER:-root}

echo "Enter MySQL password:"
read -rs DB_PASSWORD
echo ""

echo "=========================================="
echo "Step 1: Creating database and tables..."
echo "=========================================="

# Create database and run initial setup
mysql -u "$DB_USER" -p"$DB_PASSWORD" <<EOF
CREATE DATABASE IF NOT EXISTS Crops_MET;
USE Crops_MET;
SET GLOBAL local_infile = 1;
source $PROJECT_PATH/sql_scripts/01_create_database_and_master_crop_table.sql;
EOF

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to create database and tables"
    exit 1
fi

echo "✓ Database and master table created"
echo ""

echo "=========================================="
echo "Step 2: Loading data into master table..."
echo "=========================================="

# Navigate to project directory for relative path to work
cd "$PROJECT_PATH"

# Load data using the 02 script directly
mysql -u "$DB_USER" -p"$DB_PASSWORD" --local-infile=1 Crops_MET < "$PROJECT_PATH/sql_scripts/02_load_data_into_master_crop_table.sql"

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to load data into master table"
    exit 1
fi

echo "✓ Master table populated"
echo ""

echo "=========================================="
echo "Step 3: Creating dimension tables..."
echo "=========================================="

# Run remaining table creation scripts
for script in 03_create_crop_dimension_table.sql \
              04_create_location_table.sql \
              05_create_variety_table.sql \
              06_create_Trial_table.sql \
              07_create_trait_table.sql \
              08_add_indexes_script.sql \
              09_create_phenotype_measurement_table.sql 
do
    if [ -f "$PROJECT_PATH/sql_scripts/$script" ]; then
        echo "Running $script..."
        mysql -u "$DB_USER" -p"$DB_PASSWORD" Crops_MET < "$PROJECT_PATH/sql_scripts/$script"
        
        if [ $? -ne 0 ]; then
            echo "ERROR: Failed to run $script"
            exit 1
        fi
        echo "✓ $script completed"
    else
        echo "WARNING: Script not found: $script (skipping)"
    fi
done

echo ""
echo "=========================================="
echo "Step 4: Verifying database setup..."
echo "=========================================="

# Verify tables were created
mysql -u "$DB_USER" -p"$DB_PASSWORD" Crops_MET <<EOF
SHOW TABLES;
SELECT 'Master crop records:', COUNT(*) FROM master_crop_table;
EOF

echo ""
echo "=========================================="
echo "✓ Database setup complete!"
echo "=========================================="
echo ""
echo "You can now connect to the database using:"
echo "  mysql -u $DB_USER -p Crops_MET"
echo ""