-- SELECT 
-- * 
-- FROM crosstab(
--     'SELECT 
--         date AS dt, 
--         drink_name, 
--         quantity
--     FROM drinks
--     ORDER BY 1, 2
--     '
-- ) AS pivot(
--     dt date,
--     baileys INT,
--     eggnog INT,
--     "Hot Cocoa" INT,
--     "Mulled wine" INT,
--     "Peppermint Schnapps" INT,
--     sheery INT)
-- WHERE pivot."Hot Cocoa" = 38
--     AND pivot."Peppermint Schnapps" = 298
--     AND pivot.eggnog = 198;
WITH agg AS (
SELECT
    date AS dt,
    SUM(CASE WHEN drink_name = 'Hot Cocoa' THEN quantity END) AS hot_cocoa,
    SUM(CASE WHEN drink_name = 'Peppermint Schnapps' THEN quantity END) AS peppermint_schnapps,
    SUM(CASE WHEN drink_name = 'Eggnog' THEN quantity END) AS eggnog
FROM drinks
GROUP BY 1
)

SELECT
    dt
FROM agg
WHERE hot_cocoa = 38
    AND peppermint_schnapps = 298
    AND eggnog = 198
;
