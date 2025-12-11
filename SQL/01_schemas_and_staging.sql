------------------------------------------------
-- 01_schemas_and_staging.sql
-- Création des schémas et des tables de staging
------------------------------------------------

-- 1) Création des schémas (si ce n'est pas déjà fait)
CREATE SCHEMA IF NOT EXISTS dw;
CREATE SCHEMA IF NOT EXISTS stg;

------------------------------------------------
-- 2) Tables de STAGING (schema stg)
------------------------------------------------
SET search_path TO stg;

------------------------------------------------
-- 2.1) Staging Superstore (fichier CSV)
------------------------------------------------
CREATE TABLE IF NOT EXISTS stg_superstore (
  row_id            int,              -- Row ID (on peut l’ignorer dans le DW)
  order_id          varchar(50),
  order_date        date,
  ship_date         date,
  ship_mode         varchar(50),

  customer_id       varchar(50),
  customer_name     varchar(100),
  segment           varchar(50),

  country           varchar(50),
  city              varchar(100),
  state             varchar(100),
  postal_code       varchar(20),
  region            varchar(50),

  product_id        varchar(50),
  category          varchar(100),
  sub_category      varchar(100),
  product_name      varchar(200),

  sales             numeric(12,2),
  quantity          int,
  discount          numeric(5,2),
  profit            numeric(12,2)
);

------------------------------------------------
-- 2.2) Staging Entrepôts (depuis base gestionstock)
------------------------------------------------
CREATE TABLE IF NOT EXISTS stg_entrepots (
  entrepot_id    int PRIMARY KEY,
  nom_entrepot   varchar(100),
  region         varchar(100)
);

------------------------------------------------
-- 2.3) Staging Fournisseurs
------------------------------------------------
CREATE TABLE IF NOT EXISTS stg_fournisseurs (
  fournisseur_id   int PRIMARY KEY,
  nom_fournisseur  varchar(150),
  pays             varchar(100),
  email_contact    varchar(150)
);

------------------------------------------------
-- 2.4) Staging Stock
------------------------------------------------
CREATE TABLE IF NOT EXISTS stg_stock (
  product_id                     varchar(50),
  nom_produit                    varchar(200),
  fournisseur_id                 int,
  entrepot_id                    int,
  quantite_stock                 int,
  date_dernier_reapprovisionnement  date
);
