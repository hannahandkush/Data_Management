/* -----------------------------------------------------------------------
   Script: Create and Populate Trait Dimension Table
   Purpose:
       This script creates the 'trait' dimension table, which stores 
       standardized trait names, their descriptions, and their primary 
       information sources. 

   Steps Performed:
       1. Create the 'trait' table containing:
            - trait_id (Primary Key)
            - trait_name (Unique identifier for the trait)
            - trait_description (Detailed definition of the trait)
            - primary_source (Origin of the trait definition)

       2. Populate the table by importing a CSV file containing official 
          trait definitions.
            
       3. A SELECT query is provided to verify successful data insertion.

   Notes:
       - This table standardizes trait terminology across the database.
       - It supports clean linkage to phenotype measurement tables by 
         referencing trait_id.
       - Ensure the file path in LOAD DATA INFILE matches the local 
         environment and that MySQL has permission to read the file.

------------------------------------------------------------------------ */

CREATE TABLE IF NOT EXISTS trait (
    trait_id INT AUTO_INCREMENT PRIMARY KEY,
    trait_name VARCHAR(100) NOT NULL UNIQUE,
    trait_description TEXT,
    primary_source VARCHAR(150)
);

# Import the trait description from the official trait dictionary of breeding institutes
LOAD DATA LOCAL INFILE '/Users/hannahnathanson/Library/CloudStorage/OneDrive-UniversidadedeLisboa/DMS_Group_Project/Project/raw_data/trait_description.csv'
INTO TABLE trait
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(trait_name, trait_description, primary_source);

# Verify the records of Table trait
SELECT * FROM trait
LIMIT 10;