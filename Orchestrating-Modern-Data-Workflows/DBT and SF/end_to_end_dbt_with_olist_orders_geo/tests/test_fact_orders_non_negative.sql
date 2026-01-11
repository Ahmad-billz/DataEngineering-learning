-- Fail if distinct order or customer counts are negative
select *
from {{ ref('fact_orders') }}
where CNT_DISTINCT_ORDER < 0
   or CNT_DISTINCT_CUSTOMER < 0