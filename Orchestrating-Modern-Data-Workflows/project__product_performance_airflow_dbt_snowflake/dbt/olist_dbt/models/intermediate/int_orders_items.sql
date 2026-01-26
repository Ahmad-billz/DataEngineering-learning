with orders as (
    select * from {{ ref('stg_orders') }}
),
order_items as (
    select * from {{ ref('stg_order_items') }}
)

select
    oi.order_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp as purchase_date,
    o.order_delivered_customer_date as delivered_date,
    datediff(day, o.order_purchase_timestamp, o.order_delivered_customer_date) as delivery_days
from order_items oi
join orders o on oi.order_id = o.order_id
