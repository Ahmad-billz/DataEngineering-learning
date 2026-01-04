    with customers as (
    select
        seller_id,
        order_id,
        cast(price as decimal(10,2)) as price
    from {{ source('olist', 'OLIST_ORDER_ITEMS_DATASET') }}
)

select * from customers