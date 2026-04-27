/* -----------------------------------------------------------------------
   Script: Create database Crops_MET and Master Crop Table
   Purpose:
       This script creates database 'Crops_MET' and the 'master_crop_table', which serves as the 
       initial raw staging table for all experimental data imported 
       directly from the CSV file. 

   Usage:
       - This table is populated directly using LOAD DATA INFILE.
       - It is the source for generating all normalized dimension tables 
         such as crop, location, variety, trial, trait, and the main 
         fact table (phenotype_measurement).

   Notes:
	- 	Each row represents a single observation of a crop variety in a trial.
 	- 	Columns include metadata (year, country, region, agro-ecological zone, season, 
  		environment conditions), trial conditions (soil type, pH, N, P, K, elevation, 
  		rainfall, temperature), variety information, and measured phenotypic traits.
	- 	Numeric trait columns allow NULL values for cases where measurements were not 
  		recorded for a specific crop.
	-	Text columns that are critical identifiers (year, country, region, crop) are 
  		marked NOT NULL.
------------------------------------------------------------------------ */

# Create master crop table
CREATE TABLE master_crop_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    `year` INT NOT NULL,
    country VARCHAR(50) NOT NULL,
    region VARCHAR(100) NOT NULL,
    agro_ecological_zone VARCHAR(100),
    season VARCHAR(50),
    environment_condition VARCHAR(50), 
    elevation INT NULL,
    rainfall_mm DECIMAL(10,2) NULL,
    mean_temperature DECIMAL(10,2) NULL,
    soil_type VARCHAR(50),
    soil_pH DECIMAL(4,2) NULL,
    soil_N_content DECIMAL(10,2) NULL,
    soil_P_content DECIMAL(10,2) NULL,
    soil_K_content DECIMAL(10,2) NULL,
    crop VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(150),
    entry VARCHAR(100),
    pedigree VARCHAR(255) NULL,
    name VARCHAR(255),
    breeding_institution VARCHAR(150) NULL,
    maturity_group VARCHAR(100) NULL,
    rep INT NULL,
    days_to_anthesis INT NULL,
    Days_to_silking INT NULL,
    anthesis_silking_interval INT NULL,
    plant_height INT NULL,
    ear_height INT NULL,
    husk_cover INT NULL,
    plant_aspect INT NULL,
    field_weight DECIMAL(12,2) NULL,
    ear_harvested INT NULL,
    ear_per_plant INT NULL,
    ear_aspect INT NULL,
    grain_moisture DECIMAL(10,2) NULL,
    grain_yield DECIMAL(12,2) NULL,
    staygreen INT NULL,
    canopy_height DECIMAL(12,2) NULL,
    branches_per_plant INT NULL,
    peduncles_per_plant INT NULL,
    pods_per_plant INT NULL,
    seeds_per_plot INT NULL,
    seed_100_weight DECIMAL(12,2) NULL,
    dry_matter DECIMAL(12,2) NULL,
    harvest_index DECIMAL(12,2) NULL,
    fodder_yield DECIMAL(10,2) NULL,
    grains_per_panicle INT NULL,
    panicle_width DECIMAL(10,2) NULL,
    panicle_length DECIMAL(10,2) NULL,
    panicle_number INT NULL,
    seed_1000_weight DECIMAL(10,2) NULL,
    tillers_per_plant INT NULL,
    leaf_number INT NULL,
    panicle_harvested INT NULL,
    leaf_length DECIMAL(10,2) NULL,
    leaf_width DECIMAL(10,2) NULL,
    grain_covering INT NULL
);

