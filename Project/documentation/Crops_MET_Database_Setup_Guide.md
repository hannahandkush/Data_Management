# Crops_MET Database Setup Guide

## Overview

This guide provides instructions for setting up the Crops_MET (Multi-Environment Trial) database, a comprehensive agricultural phenotypic database containing data from field trials across multiple crops, locations, and environmental conditions.

## System Requirements

### Prerequisites

- **Database System**: MariaDB 10.3+ or MySQL 8.0+
- **Operating System**: macOS, Linux, or Windows (with Git Bash/WSL)
- **Privileges**: MySQL/MariaDB root or administrative access
- **Storage**: Minimum 500MB free disk space
- **Memory**: Minimum 4GB RAM recommended

### Required Configuration

The database setup requires local file loading capability to import CSV data. This must be enabled before running the setup script.

#### Enable Local File Access

**Method 1: Session-level (Temporary)**

Connect to MySQL/MariaDB with local file access enabled:
```bash
mysql --local-infile=1 -u root -p
```

**Method 2: Global configuration (Permanent)**

Execute the following command in MySQL:
```sql
SET GLOBAL local_infile = 1;
```

> **Note**: The setup script attempts to enable this setting automatically, but pre-configuration is recommended to avoid errors during execution.

---

## Installation Instructions

### Step 1: Verify Project Structure

Ensure your project directory follows this structure:
```
DMS_Group_Project/
└── Project/
    ├── sql_scripts/
    │   ├── setup_db_script.sh
    │   ├── 01_create_database_and_master_crop_table.sql
    │   ├── 02_load_data_into_master_crop_table.sql
    │   ├── 03_create_crop_dimension_table.sql
    │   ├── 04_create_location_table.sql
    │   ├── 05_create_variety_table.sql
    │   ├── 06_create_Trial_table.sql
    │   ├── 07_create_trait_table.sql
    │   ├── 08_add_indexes_script.sql
    │   └── 09_create_phenotype_measurement_table.sql
    └── processed_data/
        └── master_crop_dataset.csv
```

### Step 2: Navigate to Script Directory

Open a terminal and navigate to the sql_scripts directory:
```bash
cd /path/to/DMS_Group_Project/Project/sql_scripts
```

**Example paths:**
- macOS/Linux: `/Users/username/Documents/DMS_Group_Project/Project/sql_scripts`
- Windows (Git Bash): `/c/Users/username/Documents/DMS_Group_Project/Project/sql_scripts`

### Step 3: Configure Script Permissions

**For Unix-based systems (macOS/Linux):**
```bash
chmod +x setup_db_script.sh
```

**For Windows users:**

Use Git Bash, WSL (Windows Subsystem for Linux), or manually execute SQL scripts in sequence:
```bash
mysql -u root -p --local-infile=1 < 01_create_database_and_master_crop_table.sql
mysql -u root -p --local-infile=1 Crops_MET < 02_load_data_into_master_crop_table.sql
# Continue for remaining scripts...
```

### Step 4: Execute Setup Script

Run the automated setup script:
```bash
./setup_db_script.sh
```

### Step 5: Provide Credentials

The script will prompt for authentication:
```
Enter MySQL username (default: root):
Enter MySQL password:
```

- Enter your MySQL/MariaDB username (typically `root`)
- Enter your password (input will be hidden for security)

### Step 6: Monitor Execution

The setup script executes the following operations:

1. **Database Creation**: Creates the `Crops_MET` database
2. **Master Table Population**: Loads 90,762 records from CSV
3. **Dimension Table Creation**: Generates normalized tables (crop, location, variety, trial, trait)
4. **Index Creation**: Adds performance-optimizing indexes
5. **Fact Table Population**: Creates phenotype measurement table with 2.7M+ records
6. **Verification**: Displays summary statistics

**Expected Duration**: 2-5 minutes (depending on system specifications)

### Step 7: Confirm Successful Setup

Upon completion, the following message appears:
```
==========================================
✓ Database setup complete!
==========================================

You can now connect to the database using:
  mysql -u root -p Crops_MET
```

---

## Database Access and Verification

### Connecting to the Database
```bash
mysql -u root -p Crops_MET
```

### Verification Queries

**Display all tables:**
```sql
SHOW TABLES;
```

**Expected output:**
```
+---------------------+
| Tables_in_Crops_MET |
+---------------------+
| crop                |
| location            |
| master_crop_table   |
| phenotype_measurement|
| trait               |
| trial               |
| variety             |
+---------------------+
```

**Verify record counts:**
```sql
SELECT 'master_crop_table' AS table_name, COUNT(*) AS records FROM master_crop_table
UNION ALL
SELECT 'phenotype_measurement', COUNT(*) FROM phenotype_measurement;
```

**Expected output:**
```
+-----------------------+---------+
| table_name            | records |
+-----------------------+---------+
| master_crop_table     |   90762 |
| phenotype_measurement | 2771744 |
+-----------------------+---------+
```


---

## Database Schema

### Tables Overview

| Table | Type | Description | Records |
|-------|------|-------------|---------|
| `crop` | Dimension | Crop species and scientific classification | 4 |
| `location` | Dimension | Geographic trial locations with environmental data | 17 |
| `variety` | Dimension | Crop varieties with breeding information | 287 |
| `trial` | Dimension | Field trial experimental conditions | 309 |
| `trait` | Dimension | Phenotypic traits and measurement definitions | 34 |
| `master_crop_table` | Staging | Raw imported data (denormalized format) | 90,762 |
| `phenotype_measurement` | Fact | Normalized trait measurements | 2,771,744 |

### Entity Relationships
```
crop (1) ----< (M) variety
crop (1) ----< (M) trial
location (1) ----< (M) trial
variety (M) >----< (M) trial  →  phenotype_measurement
trait (1) ----< (M) phenotype_measurement
```

**Key relationships:**
- Each variety belongs to one crop
- Each trial is conducted at one location for one crop
- Each phenotype measurement records one trait value for one variety in one trial

### Indexing Strategy

The database implements strategic indexing for optimal query performance:

- **Primary keys**: All tables use auto-incrementing integer primary keys
- **Foreign key indexes**: All foreign key columns are indexed
- **Lookup indexes**: Composite indexes on frequently-joined columns (e.g., location lookup, trial lookup)
- **Name indexes**: Indexed on crop_name, trait_name, and variety_name for text-based searches

---

## Troubleshooting

### Error: Permission Denied

**Symptom:**
```
./setup_db_script.sh: Permission denied
```

**Solution:**
```bash
chmod +x setup_db_script.sh
```

---

### Error: Access Denied for User

**Symptom:**
```
ERROR 1045 (28000): Access denied for user 'username'@'localhost' (using password: YES)
```

**Possible causes:**
- Incorrect username or password
- User lacks necessary privileges

**Solution:**
1. Verify credentials are correct
2. Ensure user has CREATE DATABASE and FILE privileges:
```sql
GRANT ALL PRIVILEGES ON *.* TO 'username'@'localhost';
FLUSH PRIVILEGES;
```

---

### Error: Local Infile Not Allowed

**Symptom:**
```
ERROR 1148 (42000): The used command is not allowed with this MySQL version
```

**Cause:** Local file loading is disabled

**Solution:**
```sql
SET GLOBAL local_infile = 1;
```

Then restart the setup script.

---

### Error: Cannot Find CSV File

**Symptom:**
```
ERROR 1146 (42S02): File 'master_crop_dataset.csv' not found
```

**Possible causes:**
- CSV file missing from `processed_data` directory
- Incorrect file path
- Insufficient file permissions

**Solution:**
1. Verify file exists: `ls ../processed_data/master_crop_dataset.csv`
2. Check file is readable: `chmod 644 ../processed_data/master_crop_dataset.csv`
3. Ensure running script from `sql_scripts` directory

---

### Issue: Empty Tables After Setup

**Symptom:**
Tables exist but contain no data

**Diagnosis:**
```sql
SELECT COUNT(*) FROM master_crop_table;
-- If returns 0, data loading failed
```

**Solution:**
1. Check CSV file is not empty
2. Verify local_infile is enabled
3. Review error messages in script output
4. Re-run script: `DROP DATABASE Crops_MET;` then `./setup_db_script.sh`

---

### Issue: Slow Performance During Setup

**Symptom:**
Script takes longer than 10 minutes to complete

**Causes:**
- Insufficient system resources
- Missing indexes before large table population
- Disk I/O bottleneck

**Solutions:**
1. Close resource-intensive applications
2. Verify indexes are created in script 08 before script 09
3. Check disk space: `df -h`
4. Consider running on a system with more RAM/faster storage

---

## Technical Notes

### Design Decisions

**Portability:**
- Uses relative file paths for cross-platform compatibility
- Auto-detects project directory location
- No hardcoded absolute paths

**Performance:**
- Indexes created before large table population (optimization)
- Composite indexes on frequently-joined columns
- DISABLE KEYS during bulk insert for phenotype measurements

**Data Integrity:**
- Foreign key constraints enforce referential integrity
- NOT NULL constraints on critical fields
- UNIQUE constraints on natural keys (e.g., crop names)

**Idempotency:**
- All scripts use `IF NOT EXISTS` or `CREATE OR REPLACE`
- Safe to re-run scripts without data corruption
- `DROP DATABASE` required for complete reset

### File Structure Rationale

Scripts are numbered to enforce execution order:
1. Database and master table creation
2. Data loading (requires empty master table)
3-7. Dimension tables (extract from master table)
8. Indexes (before large fact table creation)
9. Fact table population (benefits from existing indexes)

### Data Normalization

The database follows a star schema design:
- **Fact table**: `phenotype_measurement` (denormalized measurements)
- **Dimension tables**: `crop`, `location`, `variety`, `trial`, `trait`
- **Staging table**: `master_crop_table` (retained for data lineage)

---

## Maintenance and Updates

### Adding New Data

To append new data to the database:

1. Add records to `master_crop_dataset.csv`
2. Re-run scripts 02-09 (or implement incremental INSERT statements)

### Backup Procedures

**Full backup:**
```bash
mysqldump -u root -p Crops_MET > Crops_MET_backup_$(date +%Y%m%d).sql
```

**Restore from backup:**
```bash
mysql -u root -p Crops_MET < Crops_MET_backup_YYYYMMDD.sql
```

### Complete Reset

To completely rebuild the database:
```bash
mysql -u root -p -e "DROP DATABASE IF EXISTS Crops_MET;"
./setup_db_script.sh
```

---

## Support and Contact

For technical issues, questions, or contributions:

- Review troubleshooting section above
- Consult MySQL/MariaDB documentation
- Contact project maintainers

---

## Appendix: Manual Setup (Alternative Method)

If the automated script fails, execute SQL scripts manually in order:
```bash
# Step 1: Create database and master table
mysql -u root -p < 01_create_database_and_master_crop_table.sql

# Step 2: Load data
mysql -u root -p --local-infile=1 Crops_MET < 02_load_data_into_master_crop_table.sql

# Step 3: Create crop dimension
mysql -u root -p Crops_MET < 03_create_crop_dimension_table.sql

# Step 4: Create location dimension
mysql -u root -p Crops_MET < 04_create_location_table.sql

# Step 5: Create variety dimension
mysql -u root -p Crops_MET < 05_create_variety_table.sql

# Step 6: Create trial dimension
mysql -u root -p Crops_MET < 06_create_Trial_table.sql

# Step 7: Create trait dimension
mysql -u root -p Crops_MET < 07_create_trait_table.sql

# Step 8: Add indexes
mysql -u root -p Crops_MET < 08_add_indexes_script.sql

# Step 9: Create and populate fact table
mysql -u root -p Crops_MET < 09_create_phenotype_measurement_table.sql
```

---

**Document Version**: 1.0  
**Last Updated**: December 2025  
**Database Version**: Crops_MET v1.0