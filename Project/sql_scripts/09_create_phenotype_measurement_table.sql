/*
====================================================================================
File: 08_create_phenotype_measurement_table_optimized.sql
Purpose: Create and populate the "phenotype_measurement" fact table (OPTIMIZED)

Description:
- This table stores all measured trait values for crop varieties in specific trials.
- OPTIMIZED VERSION: Uses JOINs instead of subqueries for much better performance
- Inserts one trait at a time to avoid cartesian products

Performance improvements:
- Replaced correlated subqueries with direct JOINs
- Added WHERE conditions to filter NULL values early
- Each INSERT processes only relevant rows

====================================================================================
*/

USE Crops_MET;

-- Create the phenotype_measurement table
CREATE TABLE IF NOT EXISTS phenotype_measurement (
    measurement_id INT AUTO_INCREMENT PRIMARY KEY,
    trial_id INT NOT NULL,
    variety_id INT NOT NULL,
    trait_id INT NOT NULL,
    value DECIMAL(12,2),
    FOREIGN KEY (trial_id) REFERENCES trial(trial_id),
    FOREIGN KEY (variety_id) REFERENCES variety(variety_id),
    FOREIGN KEY (trait_id) REFERENCES trait(trait_id)
);

-- Disable keys for faster bulk insert
ALTER TABLE phenotype_measurement DISABLE KEYS;

-- ============================================
-- Insert days_to_anthesis
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.days_to_anthesis
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'days_to_anthesis'
WHERE m.days_to_anthesis IS NOT NULL;

SELECT 'days_to_anthesis inserted' AS Status;

-- ============================================
-- Insert days_to_silking
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.days_to_silking
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'days_to_silking'
WHERE m.days_to_silking IS NOT NULL;

SELECT 'days_to_silking inserted' AS Status;

-- ============================================
-- Insert anthesis_silking_interval
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.anthesis_silking_interval
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'anthesis_silking_interval'
WHERE m.anthesis_silking_interval IS NOT NULL;

SELECT 'anthesis_silking_interval inserted' AS Status;

-- ============================================
-- Insert plant_height
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.plant_height
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'plant_height'
WHERE m.plant_height IS NOT NULL;

SELECT 'plant_height inserted' AS Status;

-- ============================================
-- Insert ear_height
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.ear_height
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'ear_height'
WHERE m.ear_height IS NOT NULL;

SELECT 'ear_height inserted' AS Status;

-- ============================================
-- Insert husk_cover
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.husk_cover
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'husk_cover'
WHERE m.husk_cover IS NOT NULL;

SELECT 'husk_cover inserted' AS Status;

-- ============================================
-- Insert plant_aspect
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.plant_aspect
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'plant_aspect'
WHERE m.plant_aspect IS NOT NULL;

SELECT 'plant_aspect inserted' AS Status;

-- ============================================
-- Insert field_weight
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.field_weight
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'field_weight'
WHERE m.field_weight IS NOT NULL;

SELECT 'field_weight inserted' AS Status;

-- ============================================
-- Insert ear_harvested
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.ear_harvested
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'ear_harvested'
WHERE m.ear_harvested IS NOT NULL;

SELECT 'ear_harvested inserted' AS Status;

-- ============================================
-- Insert ear_per_plant
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.ear_per_plant
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'ear_per_plant'
WHERE m.ear_per_plant IS NOT NULL;

SELECT 'ear_per_plant inserted' AS Status;

-- ============================================
-- Insert ear_aspect
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.ear_aspect
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'ear_aspect'
WHERE m.ear_aspect IS NOT NULL;

SELECT 'ear_aspect inserted' AS Status;

-- ============================================
-- Insert grain_moisture
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.grain_moisture
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'grain_moisture'
WHERE m.grain_moisture IS NOT NULL;

SELECT 'grain_moisture inserted' AS Status;

-- ============================================
-- Insert grain_yield
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.grain_yield
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'grain_yield'
WHERE m.grain_yield IS NOT NULL;

SELECT 'grain_yield inserted' AS Status;

-- ============================================
-- Insert staygreen
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.staygreen
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'staygreen'
WHERE m.staygreen IS NOT NULL;

SELECT 'staygreen inserted' AS Status;

-- ============================================
-- Insert canopy_height
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.canopy_height
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'canopy_height'
WHERE m.canopy_height IS NOT NULL;

SELECT 'canopy_height inserted' AS Status;

-- ============================================
-- Insert branches_per_plant
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.branches_per_plant
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'branches_per_plant'
WHERE m.branches_per_plant IS NOT NULL;

SELECT 'branches_per_plant inserted' AS Status;

-- ============================================
-- Insert peduncles_per_plant
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.peduncles_per_plant
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'peduncles_per_plant'
WHERE m.peduncles_per_plant IS NOT NULL;

SELECT 'peduncles_per_plant inserted' AS Status;

-- ============================================
-- Insert pods_per_plant
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.pods_per_plant
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'pods_per_plant'
WHERE m.pods_per_plant IS NOT NULL;

SELECT 'pods_per_plant inserted' AS Status;

-- ============================================
-- Insert seeds_per_plot
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.seeds_per_plot
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'seeds_per_plot'
WHERE m.seeds_per_plot IS NOT NULL;

SELECT 'seeds_per_plot inserted' AS Status;

-- ============================================
-- Insert seed_100_weight
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.seed_100_weight
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'seed_100_weight'
WHERE m.seed_100_weight IS NOT NULL;

SELECT 'seed_100_weight inserted' AS Status;

-- ============================================
-- Insert dry_matter
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.dry_matter
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'dry_matter'
WHERE m.dry_matter IS NOT NULL;

SELECT 'dry_matter inserted' AS Status;

-- ============================================
-- Insert harvest_index
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.harvest_index
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'harvest_index'
WHERE m.harvest_index IS NOT NULL;

SELECT 'harvest_index inserted' AS Status;

-- ============================================
-- Insert fodder_yield
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.fodder_yield
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'fodder_yield'
WHERE m.fodder_yield IS NOT NULL;

SELECT 'fodder_yield inserted' AS Status;

-- ============================================
-- Insert grains_per_panicle
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.grains_per_panicle
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'grains_per_panicle'
WHERE m.grains_per_panicle IS NOT NULL;

SELECT 'grains_per_panicle inserted' AS Status;

-- ============================================
-- Insert panicle_width
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.panicle_width
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'panicle_width'
WHERE m.panicle_width IS NOT NULL;

SELECT 'panicle_number inserted' AS Status;

-- ============================================
-- Insert seed_1000_weight
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.seed_1000_weight
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'seed_1000_weight'
WHERE m.seed_1000_weight IS NOT NULL;

SELECT 'seed_1000_weight inserted' AS Status;

-- ============================================
-- Insert tillers_per_plant
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.tillers_per_plant
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'tillers_per_plant'
WHERE m.tillers_per_plant IS NOT NULL;

SELECT 'tillers_per_plant inserted' AS Status;

-- ============================================
-- Insert leaf_number
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.leaf_number
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'leaf_number'
WHERE m.leaf_number IS NOT NULL;

SELECT 'leaf_number inserted' AS Status;

-- ============================================
-- Insert panicle_harvested
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.panicle_harvested
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'panicle_harvested'
WHERE m.panicle_harvested IS NOT NULL;

SELECT 'panicle_harvested inserted' AS Status;

-- ============================================
-- Insert leaf_length
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.leaf_length
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'leaf_length'
WHERE m.leaf_length IS NOT NULL;

SELECT 'leaf_length inserted' AS Status;

-- ============================================
-- Insert leaf_width
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.leaf_width
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'leaf_width'
WHERE m.leaf_width IS NOT NULL;

SELECT 'leaf_width inserted' AS Status;

-- ============================================
-- Insert grain_covering
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.grain_covering
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'grain_covering'
WHERE m.grain_covering IS NOT NULL;

SELECT 'grain_covering inserted' AS Status;

-- ============================================
-- Insert panicle_length
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.panicle_length
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'panicle_length'
WHERE m.panicle_length IS NOT NULL;

SELECT 'panicle_length inserted' AS Status;

-- ============================================
-- Insert panicle_number
-- ============================================
INSERT INTO phenotype_measurement (variety_id, trial_id, trait_id, value)
SELECT 
    v.variety_id,
    t.trial_id,
    tr.trait_id,
    m.panicle_number
FROM master_crop_table m
JOIN variety v ON v.entry = m.entry
JOIN crop c ON c.crop_name = m.crop
JOIN location l 
    ON l.country = m.country
    AND l.region = m.region
    AND l.agro_ecological_zone = m.agro_ecological_zone
    AND l.elevation = m.elevation
    AND l.soil_type = m.soil_type
JOIN trial t 
    ON t.year = m.year
    AND t.season = m.season
    AND t.environment_condition = m.environment_condition
    AND t.crop_id = c.crop_id
    AND t.location_id = l.location_id
JOIN trait tr ON tr.trait_name = 'panicle_number'
WHERE m.panicle_number IS NOT NULL;

SELECT 'panicle_number inserted' AS Status;


-- ============================================
-- FINAL VERIFICATION
-- ============================================

-- Re-enable keys after bulk insert
ALTER TABLE phenotype_measurement ENABLE KEYS;

-- Final verification: trait count summary
SELECT 
    CONCAT(
        COUNT(DISTINCT tr.trait_name),
        ' of 34 traits inserted successfully'
    ) AS Status
FROM phenotype_measurement pm
JOIN trait tr ON pm.trait_id = tr.trait_id;

-- Total measurements
SELECT COUNT(*) AS total_measurements 
FROM phenotype_measurement;

-- Per-trait breakdown
SELECT 
    tr.trait_name, 
    COUNT(*) AS count
FROM phenotype_measurement pm
JOIN trait tr ON pm.trait_id = tr.trait_id
GROUP BY tr.trait_name
ORDER BY tr.trait_name;