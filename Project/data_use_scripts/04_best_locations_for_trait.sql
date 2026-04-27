/*
-------------------------------------------------------------------------------------------
SCRIPT: Top Locations for Trait Expression

PURPOSE:
This query identifies the top locations (country + region) with the highest average expression of a given trait (e.g., grain_yield, plant_height, protein_content). It helps answer questions like:

        • "Which locations gave the highest yields?"
        • "Where does this trait express best?"
        • "Which regions should breeders prioritize for testing?"

    The script calculates:
        • Average trait value per location (country × region)
        • Minimum and maximum trait values
        • Variance (trait stability indicator)

USE CASES:
    • Breeders selecting locations for multi-environment trials (MET)
    • Agronomists evaluating environmental suitability
    • Policymakers identifying high-performing agricultural regions
    • Data analysts building performance dashboards

PARAMETERS:
    :trait_name       → Trait to analyze (e.g., 'grain_yield')
    :country          → Target country (e.g., 'Nigeria')
    :limit_n          → Number of top locations to return (e.g., 5)
------------------------------------------------------------------------------------------
*/

SELECT
    l.country,
    l.region,
    tr.trait_name,

    AVG(pm.value) AS avg_trait_value,
    MIN(pm.value) AS min_trait_value,
    MAX(pm.value) AS max_trait_value,
    VARIANCE(pm.value) AS variance_trait_value

FROM phenotype_measurement pm
JOIN trait tr 
    ON pm.trait_id = tr.trait_id
JOIN trial t 
    ON pm.trial_id = t.trial_id
JOIN location l
    ON t.location_id = l.location_id

WHERE tr.trait_name = :trait_name
  AND l.country = :country

GROUP BY 
    l.country,
    l.region,
    tr.trait_name

ORDER BY 
    avg_trait_value DESC  -- Top performing locations first

LIMIT :limit_n;
