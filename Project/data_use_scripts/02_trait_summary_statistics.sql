/*
------------------------------------------------------------------------------------------
SCRIPT: Trait Summary Statistics by Location, Year, and Environment Condition

PURPOSE:
    This query generates descriptive statistics for a selected trait across:
        • Country
        • Region (location)
        • Year
        • Environment condition (Optimum, Low-N, Drought, etc.)

    It computes:
        • Mean value
        • Minimum value
        • Maximum value
        • Variance

    This provides a detailed multi-environment trial summary useful for:
        • Breeders performing MET analysis
        • Agronomists examining environment-specific responses
        • Policymakers evaluating performance trends over years
        • Data analysts generating regional performance dashboards

PARAMETER:
    :trait_name  
        → The trait to analyze (e.g., 'grain_yield', 'plant_height', 'ear_height').

NOTES:
    • The data is grouped by location, environment condition, and year.
    • Useful for identifying environment-specific performance behavior.
    • Variance provides insight into trait stability across repeated trials.

------------------------------------------------------------------------------------------
*/


SELECT
    tr.trait_name,
    l.country,
    l.region AS location,
    t.environment_condition,
    t.year,

    AVG(pm.value) AS mean_value,
    MIN(pm.value) AS min_value,
    MAX(pm.value) AS max_value,
    VARIANCE(pm.value) AS variance_value

FROM phenotype_measurement pm
JOIN trait tr 
    ON pm.trait_id = tr.trait_id
JOIN trial t 
    ON pm.trial_id = t.trial_id
JOIN location l
    ON t.location_id = l.location_id

WHERE tr.trait_name = :trait_name      /* parameter e.g. 'grain_yield' */

GROUP BY 
    tr.trait_name,
    l.country,
    l.region,
    t.environment_condition,
    t.year

ORDER BY 
    l.country,
    l.region,
    t.year,
    t.environment_condition;

