with customers as (
    select
        customer_id,
        customer_unique_id,
        customer_city,
        customer_state
    from {{ source('olist', 'OLIST_CUSTOMERS_DATASET') }}
)

select * from customers