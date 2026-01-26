with order_items as (
    select
        order_id,
		product_id,
		seller_id,
		price,
		freight_value,
		shipping_limit_date
    from {{ source('olist', 'OLIST_ORDER_ITEMS_DATASET') }}
)

select * from order_items