/*---------------------------------------------------------------------------------------
SCRIPT NAME: pivot_traits_by_crop.sql

PURPOSE:
    Produce a wide-format (pivoted) dataset showing multiple traits for all varieties 
    of a specified crop across all trials, environments, years, and locations.

QUESTION ANSWERED:
    "How do varieties of crop X perform across different environments, locations, 
    and years for key agronomic traits such as yield, plant height, ASI, and others?"

PARAMETERS:
    :crop_name         – Name of the crop to filter (e.g., 'Maize', 'Rice').
                         If NULL, the script can be adapted to show all crops.

OUTPUT FIELDS:
    crop_name          – Crop type.
    variety_name       – Variety or hybrid name.
    country            – Country where the trial was conducted.
    location           – Region or location name.
    year               – Trial year.
    environment_condition – Trial environment (Optimum, Low-N, Drought, etc.).

    Pivoted trait fields:
    grain_yield
    plant_height
    ear_height
    days_to_anthesis
    days_to_silking
    anthesis_silking_interval (asi)
    staygreen (STG)

NOTES:
    • Converts long-format trait measurements into a pivot table.
    • Useful for multi-trait comparison, stability analysis, and reporting.
    • Only non-null trait measurements are included.
    • Results are grouped per variety per location per year per environment.

--------------------------------------------------------------------------------*/


SELECT
    c.crop_name,
    v.name AS variety_name,
    l.country,
    l.region AS location,
    t.year,
    t.environment_condition,

    -- Pivot traits into columns
    MAX(CASE WHEN tr.trait_name = 'grain_yield' THEN pm.value END) AS grain_yield,
    MAX(CASE WHEN tr.trait_name = 'plant_height' THEN pm.value END) AS plant_height,
    MAX(CASE WHEN tr.trait_name = 'ear_height' THEN pm.value END) AS ear_height,
    MAX(CASE WHEN tr.trait_name = 'days_to_anthesis' THEN pm.value END) AS days_to_anthesis,
    MAX(CASE WHEN tr.trait_name = 'days_to_silking' THEN pm.value END) AS days_to_silking,
    MAX(CASE WHEN tr.trait_name = 'anthesis_silking_interval' THEN pm.value END) AS asi,
	MAX(CASE WHEN tr.trait_name = 'staygreen' THEN pm.value END) AS STG
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

WHERE c.crop_name = :crop_name
  AND pm.value IS NOT NULL      -- ensure only non-null trait values

GROUP BY
    c.crop_name,
    v.variety_id,
    v.name,
    l.country,
    l.region,
    t.year,
    t.environment_condition

ORDER BY
    v.name,
    l.country,
    l.region,
    t.year,
    t.environment_condition;