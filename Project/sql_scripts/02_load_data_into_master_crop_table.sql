/* -----------------------------------------------------------------------
   Script: Load Data into master_crop_table
   Purpose:
       This script imports the cleaned CSV file (master_crop_dataset.csv) 
       into the master_crop_table using the LOAD DATA INFILE command.  
       It handles automatic parsing of columns, assigns NULL values where 
       the dataset contains 'NA', and ensures all data types are properly 
       converted before insertion.

   Usage:
       - Must be executed after creating master_crop_table.
       - Replace the file path with the correct local path when running 
         on a different machine.
       - This serves as the ETL (Extract–Transform–Load) step where all 
         raw experiment data is brought into the database before normalization.

   Notes:
       - The first line of the CSV file is ignored as it contains column headers.
       - @variables are used to temporarily hold raw values from the CSV.
       - NULLIF() transforms the string 'NA' into an actual SQL NULL.
       - FIELDS TERMINATED and ENCLOSED options ensure CSV parsing accuracy.
       - LINES TERMINATED BY '\r\n' matches macOS line endings.

------------------------------------------------------------------------ */
USE Crops_MET;

LOAD DATA LOCAL INFILE './processed_data/master_crop_dataset.csv'
INTO TABLE master_crop_table
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    `year`,
    country,
    region,
    agro_ecological_zone,
    season,
    environment_condition, 
    @elevation,
    @rainfall_mm,
    @mean_temperature,
    soil_type,
    @soil_pH,
    @soil_N_content,
    @soil_P_content,
    @soil_K_content,
    crop,
    scientific_name,
    entry,
    @pedigree,
    name,
    @breeding_institution,
    @maturity_group,
    @rep,
    @days_to_anthesis,
    @Days_to_silking,
    @anthesis_silking_interval,
    @plant_height,
    @ear_height,
    @husk_cover,
    @plant_aspect,
    @field_weight,
    @ear_harvested,
    @ear_per_plant,
    @ear_aspect,
    @grain_moisture,
    @grain_yield,
    @staygreen,
    @canopy_height,
    @branches_per_plant,
    @peduncles_per_plant,
    @pods_per_plant,
    @seeds_per_plot,
    @seed_100_weight,
    @dry_matter,
    @harvest_index,
    @fodder_yield,
    @grains_per_panicle,
    @panicle_width,
    @panicle_length,
    @panicle_number,
    @seed_1000_weight,
    @tillers_per_plant,
    @leaf_number,
    @panicle_harvested,
    @leaf_length,
    @leaf_width,
    @grain_covering
)
SET
    elevation = NULLIF(@elevation,'NA'),
    rainfall_mm = NULLIF(@rainfall_mm,'NA'),
    mean_temperature = NULLIF(@mean_temperature,'NA'),
    soil_pH = NULLIF(@soil_pH,'NA'),
    soil_N_content = NULLIF(@soil_N_content,'NA'),
    soil_P_content = NULLIF(@soil_P_content,'NA'),
    soil_K_content = NULLIF(@soil_K_content,'NA'),
    pedigree = NULLIF(@pedigree,'NA'),
    breeding_institution = NULLIF(@breeding_institution,'NA'),
    maturity_group = NULLIF(@maturity_group,'NA'),
    rep = NULLIF(@rep,'NA'),
    days_to_anthesis = NULLIF(@days_to_anthesis,'NA'),
    Days_to_silking = NULLIF(@Days_to_silking,'NA'),
    anthesis_silking_interval = NULLIF(@anthesis_silking_interval,'NA'),
    plant_height = NULLIF(@plant_height,'NA'),
    ear_height = NULLIF(@ear_height,'NA'),
    husk_cover = NULLIF(@husk_cover,'NA'),
    plant_aspect = NULLIF(@plant_aspect,'NA'),
    field_weight = NULLIF(@field_weight,'NA'),
    ear_harvested = NULLIF(@ear_harvested,'NA'),
    ear_per_plant = NULLIF(@ear_per_plant,'NA'),
    ear_aspect = NULLIF(@ear_aspect,'NA'),
    grain_moisture = NULLIF(@grain_moisture,'NA'),
    grain_yield = NULLIF(@grain_yield,'NA'),
    staygreen = NULLIF(@staygreen,'NA'),
    canopy_height = NULLIF(@canopy_height,'NA'),
    branches_per_plant = NULLIF(@branches_per_plant,'NA'),
    peduncles_per_plant = NULLIF(@peduncles_per_plant,'NA'),
    pods_per_plant = NULLIF(@pods_per_plant,'NA'),
    seeds_per_plot = NULLIF(@seeds_per_plot,'NA'),
    seed_100_weight = NULLIF(@seed_100_weight,'NA'),
    dry_matter = NULLIF(@dry_matter,'NA'),
    harvest_index = NULLIF(@harvest_index,'NA'),
    fodder_yield = NULLIF(@fodder_yield,'NA'),
    grains_per_panicle = NULLIF(@grains_per_panicle,'NA'),
    panicle_width = NULLIF(@panicle_width,'NA'),
    panicle_length = NULLIF(@panicle_length,'NA'),
    panicle_number = NULLIF(@panicle_number,'NA'),
    seed_1000_weight = NULLIF(@seed_1000_weight,'NA'),
    tillers_per_plant = NULLIF(@tillers_per_plant,'NA'),
    leaf_number = NULLIF(@leaf_number,'NA'),
    panicle_harvested = NULLIF(@panicle_harvested,'NA'),
    leaf_length = NULLIF(@leaf_length,'NA'),
    leaf_width = NULLIF(@leaf_width,'NA'),
    grain_covering = NULLIF(@grain_covering,'NA');
