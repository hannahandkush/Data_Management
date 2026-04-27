/* -----------------------------------------------------------------------
   Script: Create and Populate Crop Dimension Table
   Purpose:
       This script extracts unique crop types from the master_crop_table
       and creates a normalized dimension table named 'crop'. The table 
       stores crop names along with their scientific names and assigns a 
       unique crop_id to each entry.

   Steps Performed:
       1. Retrieve all distinct crop–scientific_name pairs from the 
          master_crop_table (for validation and review).
       2. Create the 'crop' dimension table with:
            - crop_id (Primary Key)
            - crop_name
            - scientific_name
          A UNIQUE constraint is placed on crop_name to prevent duplicates.
       3. Populate the crop table using DISTINCT values from the 
          master_crop_table.

   Usage:
       - Must be executed after loading data into master_crop_table.
       - This dimension table will be referenced by other tables 
         (e.g., variety, trial) through crop_id.

   Verification:
       A final SELECT statement is included to confirm the data was inserted 
       correctly.
------------------------------------------------------------------------ */

SELECT DISTINCT crop, scientific_name
FROM master_crop_table
ORDER BY crop;

CREATE TABLE IF NOT EXISTS crop (
    crop_id INT AUTO_INCREMENT PRIMARY KEY,
    crop_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(150) NOT NULL,
    UNIQUE(crop_name)
);

INSERT INTO crop (crop_name, scientific_name)
SELECT DISTINCT crop, scientific_name
FROM master_crop_table;

# Verify the record in crop table
SELECT * FROM crop;