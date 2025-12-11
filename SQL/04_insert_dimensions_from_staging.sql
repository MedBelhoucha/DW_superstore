------------------------------------------------
-- 04_insert_dimensions_from_staging.sql
-- Chargement initial des dimensions depuis stg.*
------------------------------------------------

SET search_path TO dw;

------------------------------------------------
-- 1) Dimension Client
------------------------------------------------
INSERT INTO dim_client (
    customer_id,
    customer_name,
    segment,
    country,
    region,
    state,
    city,
    postal_code
)
SELECT DISTINCT
    s.customer_id,
    s.customer_name,
    s.segment,
    s.country,
    s.region,
    s.state,
    s.city,
    s.postal_code
FROM stg.stg_superstore s
WHERE s.customer_id IS NOT NULL
ORDER BY s.customer_id;

------------------------------------------------
-- 2) Dimension Produit
------------------------------------------------
INSERT INTO dim_produit (
    product_id,
    product_name,
    sub_category,
    category
)
SELECT DISTINCT
    s.product_id,
    s.product_name,
    s.sub_category,
    s.category
FROM stg.stg_superstore s
WHERE s.product_id IS NOT NULL
ORDER BY s.product_id;

------------------------------------------------
-- 3) Dimension Ship Mode
------------------------------------------------
INSERT INTO dim_ship_mode (ship_mode_name)
SELECT DISTINCT
    s.ship_mode
FROM stg.stg_superstore s
WHERE s.ship_mode IS NOT NULL
ORDER BY s.ship_mode;

------------------------------------------------
-- 4) Dimension Entrepôt
------------------------------------------------
INSERT INTO dim_entrepot (
    entrepot_id,
    nom_entrepot,
    region
)
SELECT
    e.entrepot_id,
    e.nom_entrepot,
    e.region
FROM stg.stg_entrepots e
ORDER BY e.entrepot_id;

------------------------------------------------
-- 5) Dimension Fournisseur
------------------------------------------------
INSERT INTO dim_fournisseur (
    fournisseur_id,
    nom_fournisseur,
    pays,
    email_contact
)
SELECT
    f.fournisseur_id,
    f.nom_fournisseur,
    f.pays,
    f.email_contact
FROM stg.stg_fournisseurs f
ORDER BY f.fournisseur_id;
