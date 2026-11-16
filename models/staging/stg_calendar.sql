{{ config(materialized='view') }}

with raw as (
    select * from {{ source('bronze', 'raw_calendar') }}
)

select
    cast(listing_id as bigint) as listing_id,
    cast(date as date) as calendar_date,
    coalesce(available, 'f') = 't' as is_available,
    cast(minimum_nights as integer) as minimum_nights,
    cast(maximum_nights as integer) as maximum_nights
from raw
where listing_id is not null