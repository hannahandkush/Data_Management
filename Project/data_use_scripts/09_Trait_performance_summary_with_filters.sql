/*---------------------------------------------------------------------------------------
SCRIPT NAME: Pivot Summary of Trait Performance by Variety with Filters

PURPOSE:
This script dynamically generates and executes a SQL query that returns the 
**mean performance of all varieties of a selected crop**, with optional filtering 
by year, country, region, and environmental condition (stress type). 
It produces **one row per variety**, with each trait shown as a separate column.

OUTPUT FORMAT:
Each row represents a **single variety**, summarizing its average trait values:

| crop_name | variety_id | variety_name | breeding_institution | GrainYield | PlantHeight | EarHeight | ... |
|-----------|------------|--------------|--------------------|------------|-------------|-----------|-----|

---

PARAMETERS (PLACE HOLDERS)
- `@crop_name` → Target crop (e.g., 'Maize')
- `@filter_year` → Optional year (e.g., 2022) or NULL
- `@filter_country` → Optional country (e.g., 'Nigeria') or NULL
- `@filter_region` → Optional region (e.g., 'Zaria') or NULL
- `@filter_environment` → Optional environmental condition (e.g., 'Drought', 'Low-N') or NULL

---------------------------------------------------------------------------------------------
=====================================
STEP 1 — Set input parameters
===================================== */

SET @crop_name = 'Maize';              
SET @filter_year = NULL;               /* optional; e.g., 2022 */
SET @filter_country = NULL;            /* optional; e.g., 'Nigeria' */
SET @filter_region = NULL;             /* optional; e.g., 'Zaria' */
SET @filter_environment = NULL;        /* optional; e.g., 'Low-N' */

SET @sql = NULL;

/*================================================
STEP 2 - Dynamically build trait pivot columns
================================================ */

SELECT
    GROUP_CONCAT(
        DISTINCT CONCAT(
            'AVG(CASE WHEN tr.trait_name = ''',
            trait_name,
            ''' THEN pm.value END) AS `',
            trait_name,
            '`'
        )
    ) INTO @trait_columns
FROM trait;

-- Build the full dynamic SQL with optional filters
SET @sql = CONCAT(
'SELECT
    c.crop_name,
    v.variety_id,
    v.name AS variety_name,
    v.breeding_institution, ',
    @trait_columns,
' 
FROM phenotype_measurement pm
JOIN trait tr ON pm.trait_id = tr.trait_id
JOIN variety v ON pm.variety_id = v.variety_id
JOIN crop c ON v.crop_id = c.crop_id
JOIN trial t ON pm.trial_id = t.trial_id
JOIN location l ON t.location_id = l.location_id
WHERE pm.value IS NOT NULL
  AND c.crop_name = ''', @crop_name, '''',
  IF(@filter_year IS NOT NULL, CONCAT(' AND t.year = ', @filter_year), ''),
  IF(@filter_country IS NOT NULL, CONCAT(' AND l.country = ''', @filter_country, ''''), ''),
  IF(@filter_region IS NOT NULL, CONCAT(' AND l.region = ''', @filter_region, ''''), ''),
  IF(@filter_environment IS NOT NULL, CONCAT(' AND t.environment_condition = ''', @filter_environment, ''''), ''),
' GROUP BY c.crop_name, v.variety_id, v.name, v.breeding_institution
ORDER BY variety_name;'
);

/* ==================================================
   STEP 3 — Execute dynamic SQL
   ================================================== */
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;   /* remove when done if planning multiple executions */
