-- Fail if seller performance metrics are negative
select *
from {{ ref('fact_seller_performance') }}
where TOTAL_SALES_VALUE < 0
   or ORDER_COUNT < 0