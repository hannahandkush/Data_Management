/*
------------------------------------------------------------------------------------------
SCRIPT : Trait Summary by Country and Region

PURPOSE:
    This query provides a broader summary of a trait across country and region,
    without breaking the results down by year or environment condition.

    It calculates:
        • Mean value
        • Minimum value
        • Maximum value
        • Variance

    This script is designed for:
        • National-level varietal performance reporting
        • Regional yield mapping
        • Policy planning and agricultural zone summaries
        • High-level dashboards that do not require year/environment granularity

PARAMETER:
    :trait_name  
        → The desired trait to summarize (e.g., 'grain_yield').

NOTES:
    • Aggregates across all years and all environments.
    • Useful for identifying regions with high or low performance.
    • Helps in resource allocation and national agricultural monitoring.
    • Can be modified to include additional filters (crop, year range, etc.)

------------------------------------------------------------------------------------------
*/

SELECT
    tr.trait_name,
    l.country,
    l.region AS location,

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

WHERE tr.trait_name = :trait_name        /* parameter e.g. 'grain_yield' */

GROUP BY 
    tr.trait_name,
    l.country,
    l.region

ORDER BY 
    l.country,
    l.region;