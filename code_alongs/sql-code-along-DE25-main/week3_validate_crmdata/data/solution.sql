---     Create a database called crm with a staging schema
---// duckdb crm.duckdb
---// .read solution.sql när ändring gjorts i koden
CREATE SCHEMA IF NOT EXISTS staging;

--- then create two tables under the staging schema to store the data of the two csv files
---// skapar tabellen, läser in datan, sätter automatiskt rätt kolumntyper,
---// det är det smartaste och renaste sättet för ett staging-schema.
---// Du kan se allt du skapat i databasen (schema, tabeller, kolumner, innehåll) direkt via terminalen.
---// Här är exakt vad du ska skriva —SELECT schema_name FROM information_schema.schemata;
CREATE TABLE
    staging.crm_old AS
SELECT
    *
FROM
    read_csv_auto ('crm_old.csv');

CREATE TABLE
    staging.crm_new AS
SELECT
    *
FROM
    read_csv_auto ('crm_new.csv');