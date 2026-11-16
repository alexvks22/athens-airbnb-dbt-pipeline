import duckdb

con = duckdb.connect("data/ci_airbnb.duckdb")
con.execute("CREATE SCHEMA IF NOT EXISTS bronze;")

# Sample raw_listings (περιλαμβάνει active, inactive NULL price, '$', 'N/A' για έλεγχο των macros!)
con.execute("""
    CREATE OR REPLACE TABLE bronze.raw_listings AS
    SELECT * FROM (VALUES
        (101, 501, 'Maria', '98%', '95%', 't', 'ΚΟΥΚΑΚΙ', 'Entire home/apt', 'Entire rental unit', '$85.00', 4, 2, 12, 4.92),
        (102, 502, 'Nikos', 'N/A', '80%', 'f', 'ΠΛΑΚΑ', 'Private room', 'Private room in home', '$1,120.50', 2, 1, 5, 4.75),
        (103, 501, 'Maria', '98%', '95%', 't', 'ΚΟΥΚΑΚΙ', 'Entire home/apt', 'Entire rental unit', NULL, 2, 1, 1, 4.50)
    ) AS t(
        id, host_id, host_name, host_response_rate, host_acceptance_rate,
        host_is_superhost, neighbourhood_cleansed, room_type, property_type,
        price, accommodates, beds, number_of_reviews, review_scores_rating
    );
""")

# Sample raw_reviews (περιλαμβάνει και duplicate review_id=1001 για έλεγχο του deduplication!)
con.execute("""
    CREATE OR REPLACE TABLE bronze.raw_reviews AS
    SELECT * FROM (VALUES
        (1001, 101, '2025-05-10', 'Anna', 'Great apartment!'),
        (1001, 101, '2025-05-10', 'Anna', 'Great apartment!'),
        (1002, 103, '2024-08-15', 'John', 'Nice stay near Acropolis.')
    ) AS t(id, listing_id, date, reviewer_name, comments);
""")

# Sample raw_calendar (σύμφωνα με το νέο schema χωρίς price)
con.execute("""
    CREATE OR REPLACE TABLE bronze.raw_calendar AS
    SELECT * FROM (VALUES
        (101, '2026-06-01', 't', 2, 30),
        (101, '2026-06-02', 'f', 2, 30),
        (102, '2026-06-01', 't', 1, 14)
    ) AS t(listing_id, date, available, minimum_nights, maximum_nights);
""")

print("✅ CI sample Bronze tables created successfully!")
con.close()