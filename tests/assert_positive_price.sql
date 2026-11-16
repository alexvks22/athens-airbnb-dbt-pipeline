select
    listing_id,
    price_usd
from {{ ref('stg_listings') }}
where price_usd <= 0