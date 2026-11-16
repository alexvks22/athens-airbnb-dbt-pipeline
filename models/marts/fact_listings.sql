{{ config(materialized='table') }}

with listings as (
    select * from {{ ref('stg_listings') }}
),

reviews_agg as (
    select
        listing_id,
        count(review_id) as total_verified_reviews,
        max(review_date) as last_review_date
    from {{ ref('stg_reviews') }}
    group by 1
),

calendar_agg as (
    select
        listing_id,
        round(avg(case when is_available then 1.0 else 0.0 end), 2) as availability_rate_365d
    from {{ ref('stg_calendar') }}
    group by 1
)

select
    l.listing_id,
    l.host_id,
    l.neighbourhood,
    l.room_type,
    l.property_type,
    l.price_usd as base_price_usd,
    c.availability_rate_365d,
    coalesce(r.total_verified_reviews, 0) as total_verified_reviews,
    r.last_review_date,
    l.review_scores_rating
from listings l
left join reviews_agg r on l.listing_id = r.listing_id
left join calendar_agg c on l.listing_id = c.listing_id
where l.is_active_listing = true