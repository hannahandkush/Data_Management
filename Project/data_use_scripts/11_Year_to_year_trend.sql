/*--------------------------------------------------------------------------
Query: Year-to-Year Yield Trend for a Crop (Safe for Web Dropdowns)

PURPOSE:
    Analyze yield trends over time by computing the average trait value
    for each year, aggregated across seasons, countries, and environments.

PARAMETERS:
    @trait_name             → Trait to analyze (e.g., 'grain_yield')
    @crop_name              → Crop to filter (e.g., 'Maize'), optional
    @country                → Country filter, optional (NULL = include all)
    @environment_condition  → Environment condition, optional (NULL = include all)

NOTES:
    • AVG() aggregates multiple trials and measurements per year.
    • Produces one row per year for trend visualization.
    • Inline comments guide manual users for parameter substitution.
---------------------------------------------------------------------------*/

/* ========================================
   STEP 1: Set input parameters (manual users)
======================================== */
SET @trait_name = 'grain_yield';                  
/* e.g., 'grain_yield', 'plant_height' */

SET @crop_name = 'Maize';                         
/* optional; set NULL to include all crops */

SET @country = NULL;                              
/* optional; NULL = include all countries */

SET @environment_condition = NULL;               
/* optional; NULL = include all environments */

/* ========================================
   STEP 2: Execute the query
======================================== */
SELECT
    t.year,                                        /* year of trial */
    c.crop_name,                                   /* crop name */
    AVG(pm.value) AS avg_yield                     /* average value of selected trait */
FROM phenotype_measurement pm
JOIN trait tr 
    ON pm.trait_id = tr.trait_id
JOIN variety v 
    ON pm.variety_id = v.variety_id
JOIN crop c 
    ON v.crop_id = c.crop_id
JOIN trial t 
    ON pm.trial_id = t.trial_id
JOIN location l
    ON t.location_id = l.location_id
WHERE tr.trait_name = @trait_name                 /* input trait */
  AND (@crop_name IS NULL OR c.crop_name = @crop_name)              /* optional crop filter */
  AND (@country IS NULL OR l.country = @country)                   /* optional country filter */
  AND (@environment_condition IS NULL OR t.environment_condition = @environment_condition)  /* optional environment filter */
GROUP BY 
    t.year,
    c.crop_name
ORDER BY 
    t.year ASC;                                    /* chronological order */

/*==================== TEST DROPDOWN FILTERS ====================
   This section simulates user dropdown selections to verify
   that the parameterized query works as expected.
   Remove or comment out before production use.
=================================================================*/

/* 1️⃣ All crops, all countries, all environments */
SET @trait_name = 'grain_yield';
SET @crop_name = NULL;
SET @country = NULL;
SET @environment_condition = NULL;

SELECT
    t.year,
    c.crop_name,
    AVG(pm.value) AS avg_yield
FROM phenotype_measurement pm
JOIN trait tr 
    ON pm.trait_id = tr.trait_id
JOIN variety v 
    ON pm.variety_id = v.variety_id
JOIN crop c 
    ON v.crop_id = c.crop_id
JOIN trial t 
    ON pm.trial_id = t.trial_id
JOIN location l
    ON t.location_id = l.location_id
WHERE tr.trait_name = @trait_name
  AND (@crop_name IS NULL OR c.crop_name = @crop_name)
  AND (@country IS NULL OR l.country = @country)
  AND (@environment_condition IS NULL OR t.environment_condition = @environment_condition)
GROUP BY t.year, c.crop_name
ORDER BY t.year ASC;

/* 2️⃣ Specific crop only */
SET @crop_name = 'Maize';
SET @country = NULL;
SET @environment_condition = NULL;

/* Repeat the SELECT query above or wrap in a stored procedure if desired */
