-- Fail if geography-level counts are negative
select *
from {{ ref('fact_orders_geography') }}
where CNT_DISTINCT_ORDER < 0
   or CNT_DISTINCT_CUSTOMER < 0