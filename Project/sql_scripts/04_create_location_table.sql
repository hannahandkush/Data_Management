/* -----------------------------------------------------------------------
   Script: Create and Populate Location Dimension Table
   Purpose:
       This script creates a normalized 'location' dimension table by 
       extracting unique location-related attributes from the 
       master_crop_table. Each distinct location receives a unique 
       location_id to support relational integrity in other tables.

   Steps Performed:
       1. Create the 'location' table with fields:
            - location_id (Primary Key)
            - country
            - region
            - agro_ecological_zone
            - elevation
            - soil_type

       2. Populate the table using DISTINCT combinations of the above 
          fields from the master_crop_table to avoid duplication of 
          repeated location entries.

       3. A SELECT statement is included to verify that the records 
          were inserted successfully.

   Notes:
       - This dimension table helps normalize location data across the 
         database and supports clean foreign-key relationships.
       - Must be run after loading the master_crop_table.

------------------------------------------------------------------------ */

# Create the Location Table
CREATE TABLE IF NOT EXISTS location (
    location_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    country VARCHAR(50) NOT NULL,
    region VARCHAR(100) NOT NULL,
    agro_ecological_zone VARCHAR(100),
    elevation INT,
    soil_type VARCHAR(50)
);

#Populate Location Table from master_crop_table
INSERT INTO location (
    country, region, agro_ecological_zone, elevation, soil_type
)
SELECT DISTINCT
    country,
    region,
    agro_ecological_zone,
    elevation,
    soil_type
FROM master_crop_table
ORDER BY country, region;

# Verify the table records
SELECT * FROM location;