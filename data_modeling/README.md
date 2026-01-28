## Data Modeling – YH-labb

Projektet innehåller en konceptuell, logisk och fysisk datamodell
för ett utbildningssystem.


# Data Modeling Lab – Körinstruktioner

Detta projekt använder Docker och PostgreSQL.

Så här kör och testar du labben:

1. Öppna en terminal i mappen `yh_labb`
2. Starta databasen: docker compose up

3. Öppna PostgreSQL:
docker exec -it postgres psql -U postgres

4. Kör SQL-filerna:
   \i /docker-entrypoint-initdb.d/00_schema.sql
   \i /docker-entrypoint-initdb.d/01_testdata.sql
   \i /docker-entrypoint-initdb.d/02_queries.sql

Samtliga filer kan köras flera gånger utan fel.

