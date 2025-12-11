------------------------------------------------
-- 05_insert_fact_vente.sql
-- Chargement de la table de faits dw.fact_vente
------------------------------------------------

SET search_path TO dw;

-- On vide la table avant rechargement
TRUNCATE TABLE fact_vente;

INSERT INTO fact_vente (
  date_commande_key,
  date_expedition_key,
  client_key,
  produit_key,
  ship_mode_key,
  order_id,
  sales,
  quantity,
  discount,
  profit
)
SELECT
  dc.date_key                          AS date_commande_key,
  de.date_key                          AS date_expedition_key,
  c.client_key,
  p.produit_key,
  sm.ship_mode_key,
  s.order_id,
  s.sales,
  s.quantity,
  s.discount,
  s.profit
FROM stg.stg_superstore s
JOIN dim_date     dc ON dc.full_date = s.order_date
JOIN dim_date     de ON de.full_date = s.ship_date
JOIN dim_client   c  ON c.customer_id = s.customer_id
JOIN dim_produit  p  ON p.product_id  = s.product_id
JOIN dim_ship_mode sm ON sm.ship_mode_name = s.ship_mode;
