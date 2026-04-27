/*
------------------------------------------------------------------------------------------
SCRIPT NAME: best_varieties_by_location_condition.sql

PURPOSE: This query identifies the best-performing crop varieties for a specific trait within a defined country, region, and environmental condition. It ranks varieties based on the average measured value of the selected trait (e.g., grain_yield, plant_height, protein_content).

WHAT THIS QUERY DOES:
    • Retrieves varieties evaluated in a specific:
        - Country
        - Region
        - Environmental condition (Optimum, Drought, Low-N)
    • Computes the average trait value across all matching trials.
    • Returns the top 10 best-performing varieties based on the selected trait.
    • Allows optional filtering by crop (e.g., Maize, Cowpea, Sorghum).
    • Useful for MET (multi-environment testing), breeding recommendations, and regional adaptation studies.

USE CASES:
    • Breeders selecting top varieties for a target region/environment.
    • Agronomists analyzing performance under stress conditions.
    • Policymakers choosing which varieties to promote in specific areas.
    • Data analysts generating location-specific performance dashboards.

KEY FEATURES:
    • GROUP BY ensures each variety appears once with aggregated trait performance.
    • AVG() aggregates multiple plot measurements or repeated trials.
    • ORDER BY ranks varieties from highest to lowest performance.
    • LIMIT 10 returns the top 10 best-performing varieties.

NOTES:
    • Ensure parameter strings are wrapped in quotes in SQL clients.
    • If :crop_name is NULL, the crop filter is ignored due to the conditional filter:
            (:crop_name IS NULL OR c.crop_name = :crop_name)
 
-----------------------------------------------------------------------------------------*/

SELECT
    v.name AS variety_name,
    v.breeding_institution,
    l.country,
    l.region AS location,
    t.environment_condition,
    c.crop_name,
    AVG(pm.value) AS avg_trait_value

FROM phenotype_measurement pm
JOIN trait tr 
    ON pm.trait_id = tr.trait_id
JOIN variety v 
    ON pm.variety_id = v.variety_id
JOIN trial t 
    ON pm.trial_id = t.trial_id
JOIN location l
    ON t.location_id = l.location_id
JOIN crop c
    ON v.crop_id = c.crop_id

WHERE tr.trait_name = :trait_name                                /* input parameter e.g., 'grain_yield' */
  AND t.environment_condition = :environment_condition           /* input parameter e.g., 'Optimum' */
  AND l.country = :country                                       /* input parameter e.g., 'Nigeria' */
  AND l.region = :location                                       /* input parameter e.g., 'Kano' */
  AND (:crop_name IS NULL OR c.crop_name = :crop_name)           /* optional crop filter */

GROUP BY
    v.variety_id,
    v.name,
    v.breeding_institution,
    l.country,
    l.region,
    t.environment_condition,
    c.crop_name

ORDER BY avg_trait_value DESC
LIMIT 10; 


