------------------------------------------------
-- 06_insert_fact_stock.sql
-- Chargement de la table de faits dw.fact_stock
------------------------------------------------

SET search_path TO dw;

TRUNCATE TABLE fact_stock;

INSERT INTO fact_stock (
  date_key,
  produit_key,
  fournisseur_key,
  entrepot_key,
  quantite_stock
)
SELECT
  d.date_key,
  p.produit_key,
  f.fournisseur_key,
  e.entrepot_key,
  s.quantite_stock
FROM stg.stg_stock s
JOIN dim_date       d ON d.full_date     = s.date_dernier_reapprovisionnement
JOIN dim_produit    p ON p.product_id    = s.product_id
JOIN dim_fournisseur f ON f.fournisseur_id = s.fournisseur_id
JOIN dim_entrepot   e ON e.entrepot_id   = s.entrepot_id;
