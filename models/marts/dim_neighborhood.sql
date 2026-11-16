{{ config(materialized='table') }}

select
    neighbourhood,
    count(distinct listing_id) as total_listings,
    round(avg(base_price_usd), 2) as avg_nightly_price_usd,
    round(avg(availability_rate_365d) * 100, 1) as avg_occupancy_potential_pct,
    round(avg(review_scores_rating), 2) as avg_rating
from {{ ref('fact_listings') }}
group by 1
order by total_listings desc