
SELECT
  oi.seller_id,
  oi.order_id,
  oi.price
FROM {{ref('stg_order_items')}} oi
WHERE oi.price IS NOT NULL