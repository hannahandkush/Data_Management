/*---------------------------------------------------------------------------------------
SCRIPT NAME: Pivot Summary of Trait Performance by Variety

PURPOSE:
    This script defines and executes a stored procedure that dynamically generates
    a pivot-style summary of varietal trait performance.

    It returns the **mean performance of all varieties for a selected crop**,
    aggregated across:
        • all locations
        • all countries
        • all years
        • all environmental conditions

    Each variety appears **once per row**, with each trait represented as a
    separate dynamically generated column.

OUTPUT FORMAT:
    Each row represents a single variety:

    | crop_name | variety_id | variety_name | breeding_institution | GrainYield | PlantHeight | EarHeight | ... |
    |-----------|-------------|--------------|-----------------------|------------|-------------|-----------|-----|

    The set of trait columns is generated automatically based on the contents
    of the `trait` table.

EXECUTION INSTRUCTIONS:
    1. Create the stored procedure `pivot_trait_summary`.
    2. Execute the procedure using:

        CALL pivot_trait_summary('Maize');

    To run the summary for a different crop, change the input parameter, e.g.:

        CALL pivot_trait_summary('Sorghum');

NOTES:
    • Only non-null trait measurements are included in the aggregation
      (`pm.value IS NOT NULL`).
    • Trait values are aggregated using the mean (AVG).
    • Results are ordered alphabetically by `variety_name`.
    • The query structure adapts automatically as traits are added or removed
      from the `trait` table.

---------------------------------------------------------------------------------------

======================================================================================
 STEP 1 — STORED PROCEDURE DEFINITION
======================================================================================*/

CREATE OR REPLACE PROCEDURE pivot_trait_summary(IN crop_param VARCHAR(50))
BEGIN
    DECLARE trait_cols TEXT;

    SELECT                                                   
        GROUP_CONCAT(
            DISTINCT
            CONCAT(
                'AVG(CASE WHEN tr.trait_name = ''',
                trait_name,
                ''' THEN pm.value END) AS `',
                trait_name,
                '`'
            )
        ) INTO trait_cols
    FROM trait;

    SET @sql = CONCAT(										
        'SELECT
            c.crop_name,
            v.variety_id,
            v.name AS variety_name,
            v.breeding_institution, ',
            trait_cols,
        '
        FROM phenotype_measurement pm
        JOIN trait tr ON pm.trait_id = tr.trait_id
        JOIN variety v ON pm.variety_id = v.variety_id
        JOIN crop c ON v.crop_id = c.crop_id
        WHERE pm.value IS NOT NULL
          AND c.crop_name = ''', crop_param, '''
        GROUP BY
            c.crop_name,
            v.variety_id,
            v.name,
            v.breeding_institution
        ORDER BY variety_name'
    );

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;


/*======================================================================================
 STEP 2 — PROCEDURE EXECUTION
======================================================================================*/

CALL pivot_trait_summary('Sorghum');   -- example parameter








