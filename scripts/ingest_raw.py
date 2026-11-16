import duckdb

# Συνδέεται (ή δημιουργεί αν δεν υπάρχει) το αρχείο data/athens_airbnb.duckdb
con = duckdb.connect("data/athens_airbnb.duckdb")

# Φτιάχνουμε το bronze schema (όπως στο Unity Catalog!)
con.execute("CREATE SCHEMA IF NOT EXISTS bronze;")

# Διαβάζει κατευθείαν τα .csv.gz και φτιάχνει τους Bronze πίνακες
con.execute("""
    CREATE OR REPLACE TABLE bronze.raw_listings AS
    SELECT * FROM read_csv_auto('data/raw/listings.csv.gz', ignore_errors=true);
""")

con.execute("""
    CREATE OR REPLACE TABLE bronze.raw_reviews AS
    SELECT * FROM read_csv_auto('data/raw/reviews.csv.gz', ignore_errors=true);
""")

con.execute("""
    CREATE OR REPLACE TABLE bronze.raw_calendar AS
    SELECT * FROM read_csv_auto('data/raw/calendar.csv.gz', ignore_errors=true);
""")

print("✅ Bronze tables loaded successfully into DuckDB!")
con.close()