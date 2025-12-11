# Entrepôt de données ventes & stocks – Superstore / Gestionstock

Ce dépôt contient le code et les scripts du projet d'entrepôt de données
réalisé dans le cadre du module *Data Warehouse & Business Intelligence*.

## 1. Contenu du dépôt

- `SQL/` : scripts PostgreSQL (création des schémas, tables dimensions/faits,
  génération de `dw.dim_date`, chargement initial, vues OLAP).
- `talend/` : export du projet Talend Open Studio (jobs de staging, dimensions,
  faits et job parent d’orchestration).
- `data/` : fichier source `Superstore.csv` (données de ventes).
- `doc/` : rapport du projet et documentation complémentaire.
- `screenshots/` : quelques captures d’écran illustrant l’architecture.

## 2. Prérequis

- PostgreSQL 17 (ou version équivalente)
- Talend Open Studio for Data Integration 8.x

## 3. Installation de la base de données

1. Créer la base `dw_superstore` dans PostgreSQL.
2. Exécuter les scripts dans `sql/` dans l’ordre :
   - `01_create_schemas.sql`
   - `02_create_dimensions.sql`
   - `03_create_facts.sql`
   - `04_dim_date_generate.sql`
   - `05_load_dimensions_initial.sql`
   - `06_load_facts_initial.sql`
   - `07_views_olap.sql`
3. Vérifier que les vues `dw.v_ventes_temps_produit`, `dw.v_stock_temps_entrepot`,
   etc. retournent des données.

## 4. Import du projet Talend

1. Ouvrir Talend Open Studio.
2. `File > Import ...`
3. Sélectionner l’archive `talend/dw_project_talend.zip`.
4. Importer les jobs (staging, dimensions, faits, job parent).

Le job parent `job_parent_dw_superstore` permet d’exécuter toute la chaîne ETL
dans l’ordre logique.

## 5. Auteur

- BELHOUCHA Mohamed
  
