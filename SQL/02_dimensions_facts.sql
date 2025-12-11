------------------------------------------------
-- 02_dimensions_facts.sql
-- Création des tables de dimensions et de faits
------------------------------------------------

SET search_path TO dw;

------------------------------------------------
-- 1) Dimension Date
------------------------------------------------
CREATE TABLE IF NOT EXISTS dim_date (
  date_key      int PRIMARY KEY,     -- format : YYYYMMDD
  full_date     date      NOT NULL,
  jour          int,
  jour_semaine  varchar(20),
  semaine       int,
  mois          int,
  nom_mois      varchar(20),
  trimestre     int,
  annee         int,
  is_weekend    boolean
);

------------------------------------------------
-- 2) Dimension Client
------------------------------------------------
CREATE TABLE IF NOT EXISTS dim_client (
  client_key     serial PRIMARY KEY,   -- surrogate key
  customer_id    varchar(50),          -- business key (Superstore)
  customer_name  varchar(100),
  segment        varchar(50),
  country        varchar(50),
  region         varchar(50),
  state          varchar(50),
  city           varchar(100),
  postal_code    varchar(20)
);

------------------------------------------------
-- 3) Dimension Produit
------------------------------------------------
CREATE TABLE IF NOT EXISTS dim_produit (
  produit_key   serial PRIMARY KEY,   -- surrogate key
  product_id    varchar(50),          -- business key (Superstore)
  product_name  varchar(150),
  sub_category  varchar(100),
  category      varchar(100)
);

------------------------------------------------
-- 4) Dimension Entrepôt
------------------------------------------------
CREATE TABLE IF NOT EXISTS dim_entrepot (
  entrepot_key   serial PRIMARY KEY,  -- surrogate key
  entrepot_id    int,                 -- business key (gestionstock)
  nom_entrepot   varchar(100),
  region         varchar(100)
);

------------------------------------------------
-- 5) Dimension Fournisseur
------------------------------------------------
CREATE TABLE IF NOT EXISTS dim_fournisseur (
  fournisseur_key  serial PRIMARY KEY, -- surrogate key
  fournisseur_id   int,                -- business key
  nom_fournisseur  varchar(150),
  pays             varchar(100),
  email_contact    varchar(150)
);

------------------------------------------------
-- 6) Dimension Ship Mode
------------------------------------------------
CREATE TABLE IF NOT EXISTS dim_ship_mode (
  ship_mode_key   serial PRIMARY KEY,   -- surrogate key
  ship_mode_name  varchar(50)           -- Standard Class, First Class, ...
);

------------------------------------------------
-- 7) Fact VENTE
-- grain : 1 ligne = 1 ligne de commande (OrderID + ProductID)
------------------------------------------------
CREATE TABLE IF NOT EXISTS fact_vente (
  fact_vente_id        serial PRIMARY KEY,

  -- role-playing de dim_date
  date_commande_key    int NOT NULL,
  date_expedition_key  int NOT NULL,

  client_key           int NOT NULL,
  produit_key          int NOT NULL,
  ship_mode_key        int NOT NULL,

  -- degenerate dimension
  order_id             varchar(50),

  -- mesures
  sales                numeric(12,2),
  quantity             int,
  discount             numeric(5,2),
  profit               numeric(12,2),

  -- contraintes FK
  CONSTRAINT fk_factvente_date_commande
    FOREIGN KEY (date_commande_key)
    REFERENCES dim_date(date_key),

  CONSTRAINT fk_factvente_date_expedition
    FOREIGN KEY (date_expedition_key)
    REFERENCES dim_date(date_key),

  CONSTRAINT fk_factvente_client
    FOREIGN KEY (client_key)
    REFERENCES dim_client(client_key),

  CONSTRAINT fk_factvente_produit
    FOREIGN KEY (produit_key)
    REFERENCES dim_produit(produit_key),

  CONSTRAINT fk_factvente_shipmode
    FOREIGN KEY (ship_mode_key)
    REFERENCES dim_ship_mode(ship_mode_key)
);

------------------------------------------------
-- 8) Fact STOCK
-- grain : 1 ligne = stock d’un produit dans un entrepôt à une date
-- NB : on utilise stock_key (BIGSERIAL) comme dans la version finale.
------------------------------------------------
CREATE TABLE IF NOT EXISTS fact_stock (
  stock_key       bigserial PRIMARY KEY,

  date_key        int NOT NULL,
  produit_key     int NOT NULL,
  entrepot_key    int NOT NULL,
  fournisseur_key int NOT NULL,

  quantite_stock  int,

  CONSTRAINT fk_factstock_date
    FOREIGN KEY (date_key)
    REFERENCES dim_date(date_key),

  CONSTRAINT fk_factstock_produit
    FOREIGN KEY (produit_key)
    REFERENCES dim_produit(produit_key),

  CONSTRAINT fk_factstock_entrepot
    FOREIGN KEY (entrepot_key)
    REFERENCES dim_entrepot(entrepot_key),

  CONSTRAINT fk_factstock_fournisseur
    FOREIGN KEY (fournisseur_key)
    REFERENCES dim_fournisseur(fournisseur_key)
);
