{{ config(
    materialized='table',
    full_refresh=true
) }}

with orders_items as (
    select * from {{ ref('int_orders_items') }}
),
products as (
    select * from {{ ref('stg_products') }}
)

select
    p.product_category_name,
    sum(oi.price + oi.freight_value) as total_sales,
    count(distinct oi.product_id) as unique_products_sold,
    count(distinct oi.order_id) as number_of_orders,
    avg(oi.delivery_days) as avg_delivery_days,
    avg(p.product_weight_g) as avg_product_weight,
    avg(p.product_photos_qty) as avg_product_photos
from orders_items oi
join products p on oi.product_id = p.product_id
group by p.product_category_name