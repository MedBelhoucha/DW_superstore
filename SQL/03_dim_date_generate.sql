------------------------------------------------
-- 03_dim_date_generate.sql
-- Génération de la dimension temps dw.dim_date
------------------------------------------------

SET search_path TO dw;

-- On vide la table avant de la regénérer (optionnel)
TRUNCATE TABLE dim_date;

-- Intervalle temporel (à adapter au besoin)
WITH dates AS (
    SELECT generate_series(
        DATE '2014-01-01',   -- date de début
        DATE '2025-12-31',   -- date de fin
        INTERVAL '1 day'
    )::date AS d
)
INSERT INTO dim_date (
    date_key,
    full_date,
    jour,
    jour_semaine,
    semaine,
    mois,
    nom_mois,
    trimestre,
    annee,
    is_weekend
)
SELECT
    TO_CHAR(d, 'YYYYMMDD')::int                AS date_key,
    d                                         AS full_date,
    EXTRACT(DAY    FROM d)::int               AS jour,
    TO_CHAR(d, 'Day')                         AS jour_semaine,
    EXTRACT(WEEK   FROM d)::int               AS semaine,
    EXTRACT(MONTH  FROM d)::int               AS mois,
    TO_CHAR(d, 'Month')                       AS nom_mois,
    EXTRACT(QUARTER FROM d)::int              AS trimestre,
    EXTRACT(YEAR   FROM d)::int               AS annee,
    CASE WHEN EXTRACT(ISODOW FROM d) IN (6,7) THEN true ELSE false END AS is_weekend
FROM dates
ORDER BY d;
