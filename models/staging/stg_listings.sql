{{ config(materialized='view') }}

with raw as (
    select * from {{ source('bronze', 'raw_listings') }}
)

select
    cast(id as bigint) as listing_id,
    cast(host_id as bigint) as host_id,
    host_name,
    {{ clean_percent('host_response_rate') }} as host_response_rate,
    {{ clean_percent('host_acceptance_rate') }} as host_acceptance_rate,
    coalesce(host_is_superhost, 'f') = 't' as is_superhost,
    neighbourhood_cleansed as neighbourhood,
    room_type,
    property_type,
    {{ clean_currency('price') }} as price_usd,
    price is not null as is_active_listing,
    cast(accommodates as integer) as accommodates,
    cast(beds as integer) as beds,
    cast(number_of_reviews as integer) as number_of_reviews,
    cast(review_scores_rating as double) as review_scores_rating
from raw
where id is not null