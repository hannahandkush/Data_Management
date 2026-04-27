/* -----------------------------------------------------------------------
   Script: Create and Populate Trial Dimension Table
   Purpose:
       This script creates the 'trial' dimension table by organizing 
       unique trial-level attributes extracted from the master_crop_table. 
       Each unique trial—defined by its location, crop, year, and 
       environmental conditions—receives a trial_id. This table serves as 
       the core link between locations, crops, and subsequent phenotype 
       measurements.

   Steps Performed:
       1. Create the 'trial' table containing key trial-related fields:
            - trial_id (Primary Key)
            - location_id (Foreign Key → location table)
            - crop_id (Foreign Key → crop table)
            - year
            - season
            - environment_condition
            - rainfall_mm
            - mean_temperature
            - soil_pH
            - soil_N_content
            - soil_P_content
            - soil_K_content

       2. Populate the table using DISTINCT combinations of trial 
          attributes from master_crop_table. 
          - The location_id is assigned using a subquery that matches all 
            location-related fields to the location dimension.
          - The crop_id is assigned by matching the crop attribute to the 
            crop dimension table.

       3. Perform a SELECT query to verify successful insertion of all 
          unique trial records.

   Notes:
       - The trial table centralizes trial metadata, ensuring consistent 
         linkage in phenotype or performance tables.
       - Each trial entry represents a unique combination of crop, 
         location, year, season, and environmental conditions.
       - Must be executed after the crop and location tables are created 
         and populated.

------------------------------------------------------------------------ */

CREATE TABLE IF NOT EXISTS trial (
    trial_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    location_id INT,
    crop_id INT,
    year INT,
    season VARCHAR(50),
    environment_condition VARCHAR(50),
    rainfall_mm DECIMAL(10,2),
    mean_temperature DECIMAL(10,2),
    soil_pH DECIMAL(4,2),
    soil_N_content DECIMAL(10,2),
    soil_P_content DECIMAL(10,2),
    soil_K_content DECIMAL(10,2),
    FOREIGN KEY (location_id) REFERENCES location(location_id),
    FOREIGN KEY (crop_id) REFERENCES crop(crop_id)
);

# Populate the Trial Table from the master_crop_table
INSERT INTO trial (
    location_id,
    crop_id,
    year,
    season,
    environment_condition,
    rainfall_mm,
    mean_temperature,
    soil_pH,
    soil_N_content,
    soil_P_content,
    soil_K_content
)
SELECT DISTINCT
    (SELECT location_id FROM location 
     WHERE location.country = master_crop_table.country 
       AND location.region = master_crop_table.region
       AND location.agro_ecological_zone = master_crop_table.agro_ecological_zone
       AND location.elevation = master_crop_table.elevation
       AND location.soil_type = master_crop_table.soil_type
     LIMIT 1) AS location_id,
    (SELECT crop_id FROM crop WHERE crop.crop_name = master_crop_table.crop LIMIT 1) AS crop_id,
    year,
    season,
    environment_condition,
    rainfall_mm,
    mean_temperature,
    soil_pH,
    soil_N_content,
    soil_P_content,
    soil_K_content
FROM master_crop_table;

# Verify the records of the Trial Table
SELECT * FROM trial;
