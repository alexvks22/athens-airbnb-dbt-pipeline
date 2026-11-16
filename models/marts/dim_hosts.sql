{{ config(materialized='table') }}

select distinct
    host_id,
    host_name,
    is_superhost,
    max(host_response_rate) as host_response_rate,
    max(host_acceptance_rate) as host_acceptance_rate
from {{ ref('stg_listings') }}
group by 1, 2, 3