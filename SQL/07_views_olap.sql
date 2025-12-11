------------------------------------------------
-- 07_views_olap.sql
-- Vues analytiques (ROLAP) sur les tables de faits
------------------------------------------------

SET search_path TO dw;

------------------------------------------------
-- 1) Ventes par Temps x Produit
------------------------------------------------
CREATE OR REPLACE VIEW v_ventes_temps_produit AS
SELECT
  d.annee,
  d.mois,
  d.nom_mois,
  p.category,
  p.sub_category,
  SUM(f.sales)    AS total_sales,
  SUM(f.quantity) AS total_quantity,
  SUM(f.profit)   AS total_profit,
  AVG(f.discount) AS avg_discount
FROM fact_vente f
JOIN dim_date   d ON d.date_key   = f.date_commande_key
JOIN dim_produit p ON p.produit_key = f.produit_key
GROUP BY
  d.annee,
  d.mois,
  d.nom_mois,
  p.category,
  p.sub_category;

------------------------------------------------
-- 2) Ventes par Temps x Client (Région, Segment)
------------------------------------------------
CREATE OR REPLACE VIEW v_ventes_client_region AS
SELECT
  d.annee,
  d.mois,
  d.nom_mois,
  c.region,
  c.segment,
  SUM(f.sales)    AS total_sales,
  SUM(f.quantity) AS total_quantity,
  SUM(f.profit)   AS total_profit
FROM fact_vente f
JOIN dim_date   d ON d.date_key   = f.date_commande_key
JOIN dim_client c ON c.client_key = f.client_key
GROUP BY
  d.annee,
  d.mois,
  d.nom_mois,
  c.region,
  c.segment;

------------------------------------------------
-- 3) Ventes par Temps x Mode de livraison
------------------------------------------------
CREATE OR REPLACE VIEW v_ventes_temps_livraison AS
SELECT
  d.annee,
  d.mois,
  d.nom_mois,
  sm.ship_mode_name AS ship_mode,
  SUM(f.sales)      AS total_sales,
  SUM(f.quantity)   AS total_quantity,
  SUM(f.profit)     AS total_profit,
  AVG(f.discount)   AS avg_discount
FROM fact_vente f
JOIN dim_date     d  ON d.date_key      = f.date_commande_key
JOIN dim_ship_mode sm ON sm.ship_mode_key = f.ship_mode_key
GROUP BY
  d.annee,
  d.mois,
  d.nom_mois,
  sm.ship_mode_name;

------------------------------------------------
-- 4) Stock par Temps x Entrepôt
------------------------------------------------
CREATE OR REPLACE VIEW v_stock_temps_entrepot AS
SELECT
  d.annee,
  d.mois,
  d.nom_mois,
  e.region,
  e.nom_entrepot,
  SUM(fs.quantite_stock) AS total_stock
FROM fact_stock fs
JOIN dim_date     d ON d.date_key      = fs.date_key
JOIN dim_entrepot e ON e.entrepot_key  = fs.entrepot_key
GROUP BY
  d.annee,
  d.mois,
  d.nom_mois,
  e.region,
  e.nom_entrepot;

------------------------------------------------
-- 5) Stock par Temps x Fournisseur x Produit
------------------------------------------------
CREATE OR REPLACE VIEW v_stock_temps_fournisseur_produit AS
SELECT
  d.annee,
  d.mois,
  d.nom_mois,
  f.pays,
  f.nom_fournisseur,
  p.category,
  p.sub_category,
  SUM(fs.quantite_stock) AS total_stock
FROM fact_stock fs
JOIN dim_date       d ON d.date_key       = fs.date_key
JOIN dim_fournisseur f ON f.fournisseur_key = fs.fournisseur_key
JOIN dim_produit     p ON p.produit_key    = fs.produit_key
GROUP BY
  d.annee,
  d.mois,
  d.nom_mois,
  f.pays,
  f.nom_fournisseur,
  p.category,
  p.sub_category;
