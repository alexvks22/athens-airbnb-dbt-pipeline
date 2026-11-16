{{ config(materialized='view') }}

with raw as (
    select * from {{ source('bronze', 'raw_reviews') }}
)

select
    cast(id as bigint) as review_id,
    cast(listing_id as bigint) as listing_id,
    cast(date as date) as review_date,
    reviewer_name,
    comments
from raw
where id is not null
qualify row_number() over (partition by id order by date desc) = 1