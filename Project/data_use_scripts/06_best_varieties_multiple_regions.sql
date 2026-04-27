/*-----------------------------------------------------------------------------------------
SCRIPT NAME: best_varieties_multiple_regions.sql

PURPOSE: Retrieve the top-performing varieties for a selected trait across MULTIPLE regions within a country,filtered also by crop (optional) and environmental condition.

WHAT THIS QUERY DOES:
    • Allows selection of several regions using IN (...)
    • Calculates the average trait value (e.g., grain_yield, plant_height)
    • Ranks varieties within each selected region
    • Each variety may appear multiple times (once per region)
    • Returns the best-performing varieties under a specific environment condition
    • Optional crop filtering (Maize, Sorghum, Cowpea, etc.)

USE CASES:
    • Compare variety performance across multiple target recommendation domains
    • Multi-region varietal adaptation analysis
    • National-level varietal release decision support
    • MET (Multi-Environment Trial) analysis focusing on regional clusters

IMPLEMENTATION NOTES:
    • The region filter uses `IN (:regions_list)` to support multiple region inputs.
    • If :crop_name IS NULL → query automatically includes all crops.
    • Aggregation uses AVG() so repeated measures or trials are averaged.
    • Results are ranked from highest to lowest.

----------------------------------------------------------------------------------------*/

SELECT
    v.name AS variety_name,
    v.breeding_institution,
    l.country,
    l.region,
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

WHERE tr.trait_name = :trait_name                              /* input parameter e.g. 'grain_yield' */
  AND t.environment_condition = :environment_condition         /* input parameter e.g. 'Optimum' */
  AND l.country = :country                                     /* input parameter e.g. 'Nigeria' */
  AND l.region IN :regions_list                                /* input list e.g. ('Kano','Kaduna','Katsina') */
  AND (:crop_name IS NULL OR c.crop_name = :crop_name)         /* optional filter; NULL includes all crops */


GROUP BY
    v.variety_id,
    v.name,
    v.breeding_institution,
    l.country,
    l.region,
    t.environment_condition,
    c.crop_name

ORDER BY avg_trait_value DESC
LIMIT :limit_n;                     							/* e.g. 5 */
