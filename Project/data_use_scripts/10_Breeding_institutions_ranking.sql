/*
---------------------------------------------------------------------------
Query: Ranking Breeding Institutions by Variety Performance

PURPOSE:
    Evaluate breeding institutions by calculating the average trait value
    (e.g., grain yield) of all varieties from each institution. Useful for
    identifying institutions producing superior germplasm across environments.

USE CASES:
    • Breeding program benchmarking
    • Policy and donor reporting on genetic gains
    • Institution-level performance monitoring
    • Identifying high-performing breeding pipelines

PARAMETERS:
    @trait_name             → Trait to evaluate (e.g., 'grain_yield')
    @crop_name              → Crop to filter (e.g., 'Maize')
    @year (optional)        → Filter by trial year (NULL = include all)
    @country (optional)     → Filter by country (NULL = include all)
    @environment_condition (optional) → Filter by environment condition (NULL = include all)

NOTES:
    • AVG() aggregates multiple observations across trials/environments.
    • NULLable filters allow flexible reporting.
    • GROUP BY ensures one row per breeding institution.
---------------------------------------------------------------------------*/

/* ==============================
   STEP 1 — Set input parameters
   ============================== */
SET @trait_name = 'grain_yield';                 
/* e.g., 'grain_yield', 'plant_height' */

SET @crop_name = 'Maize';                        
/* optional; set NULL to include all crops */

SET @year = NULL;                                
/* optional; NULL = include all years */

SET @country = NULL;                             
/* optional; NULL = include all countries */

SET @environment_condition = NULL;              
/* optional; NULL = include all environments */

/* ==============================
   STEP 2 — Execute query
   ============================== */
SELECT
    v.breeding_institution,                       /* name of the breeding institution */
    c.crop_name,                                  /* crop name */
    COUNT(DISTINCT v.variety_id) AS number_of_varieties_tested,  /* number of varieties tested */
    AVG(pm.value) AS avg_trait_value              /* average trait value */
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
WHERE tr.trait_name = @trait_name                /* input trait */
  AND (@crop_name IS NULL OR c.crop_name = @crop_name)                  /* optional crop filter */
  AND (@year IS NULL OR t.year = @year)                                   /* optional year filter */
  AND (@country IS NULL OR l.country = @country)                          /* optional country filter */
  AND (@environment_condition IS NULL OR t.environment_condition = @environment_condition)  /* optional environment filter */
GROUP BY 
    v.breeding_institution,
    c.crop_name
ORDER BY avg_trait_value DESC;                   /* rank institutions by performance */
