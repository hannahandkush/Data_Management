-- ============================================
-- Performance Optimization: Add Indexes
-- ============================================
-- Run this script AFTER creating all tables but BEFORE the large INSERT operations
-- This will significantly speed up JOIN operations and lookups

USE Crops_MET;

-- Indexes for master_crop_table (staging table)
CREATE INDEX idx_master_entry ON master_crop_table(entry);
CREATE INDEX idx_master_crop ON master_crop_table(crop);
CREATE INDEX idx_master_year ON master_crop_table(year);
CREATE INDEX idx_master_season ON master_crop_table(season);
CREATE INDEX idx_master_location ON master_crop_table(country, region, agro_ecological_zone);

-- Indexes for variety table
CREATE INDEX idx_variety_entry ON variety(entry);
CREATE INDEX idx_variety_name ON variety(name);
CREATE INDEX idx_variety_crop ON variety(crop_id);

-- Indexes for crop table
CREATE INDEX idx_crop_name ON crop(crop_name);
CREATE INDEX idx_crop_scientific ON crop(scientific_name);

-- Indexes for location table
CREATE INDEX idx_location_country ON location(country);
CREATE INDEX idx_location_region ON location(region, country);
CREATE INDEX idx_location_aez ON location(agro_ecological_zone);
CREATE INDEX idx_location_lookup ON location(country, region, agro_ecological_zone, elevation, soil_type);

-- Indexes for trial table
CREATE INDEX idx_trial_year ON trial(year);
CREATE INDEX idx_trial_season ON trial(season);
CREATE INDEX idx_trial_crop ON trial(crop_id);
CREATE INDEX idx_trial_location ON trial(location_id);
CREATE INDEX idx_trial_lookup ON trial(crop_id, location_id, year, season, environment_condition);

-- Indexes for trait table
CREATE INDEX idx_trait_name ON trait(trait_name);


-- Verify indexes were created
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'Crops_MET'
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;

SELECT 'Indexes created successfully!' AS Status;
