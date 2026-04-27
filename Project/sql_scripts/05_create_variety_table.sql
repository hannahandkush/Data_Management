/*
====================================================================================
File: create_variety_table.sql
Purpose: Create and populate the "variety" dimension table.

Description:
- This script defines the variety dimension table, which stores unique information 
  about the different crop varieties in the dataset.
- Columns:
    - variety_id: Primary key, auto-incremented.
    - entry: Unique identifier or code for the variety (NOT NULL).
    - pedigree: Lineage or breeding pedigree of the variety.
    - name: Common name of the variety.
    - breeding_institution: Institution responsible for breeding the variety.
    - maturity_group: Classification of the variety based on maturity.
    - crop_id: Foreign key linking the variety to the crop dimension table.

- The INSERT statement extracts distinct combinations of variety information from 
  the master_crop_table and links each variety to its corresponding crop using 
  the crop dimension table.
- A SELECT statement is included to verify that the records were inserted correctly, filtered here by a specific crop_id.

====================================================================================
*/

CREATE TABLE IF NOT EXISTS variety (
    variety_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    entry VARCHAR(100) NOT NULL,
    pedigree VARCHAR(255),
    name VARCHAR(255),
    breeding_institution VARCHAR(150),
    maturity_group VARCHAR(100),
    crop_id INT,
    FOREIGN KEY (crop_id) REFERENCES crop(crop_id)
);

# Populate the variety table
INSERT INTO variety (
    entry, pedigree, name, breeding_institution, maturity_group, crop_id
)
SELECT DISTINCT
    entry,
    pedigree,
    name,
    breeding_institution,
    maturity_group,
    (SELECT crop_id FROM crop WHERE crop.crop_name = master_crop_table.crop LIMIT 1) AS crop_id
FROM master_crop_table;

# Verify the variety table records
SELECT * FROM variety
WHERE crop_id = 2;
